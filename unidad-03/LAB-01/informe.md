# LAB-01 — Bitácoras y auditoría del dato en PostgreSQL

Carmen Ariana Salazar Bojórquez 

## 1. Despliegue y situación inicial

Desplegué PostgreSQL 16.14 (Debian 16.14-1.pgdg13+1) en un contenedor Docker con la imagen oficial `postgres:16`, llamado `dba-u3-pg`. El puerto 5432 de mi equipo ya estaba ocupado por una instalación nativa de PostgreSQL, así que publiqué el contenedor en el 5433. Trabajé con dos tipos de sesión: la de administrador (`docker exec -it dba-u3-pg psql -U postgres -d comercial`) y las sesiones por red desde mi equipo hacia `127.0.0.1:5433`, que en la bitácora aparecen con la IP de la red de Docker (`172.17.0.1`). Revisé las reglas de `pg_hba.conf` y comprobé que las conexiones por red exigen contraseña (`scram-sha-256`); lo confirmé con los intentos fallidos de la Actividad 5.

Con la configuración por defecto, el servidor no podía responder a Dirección: `log_connections` y `log_disconnections` estaban en `off`, `log_statement` en `none`, el prefijo era solo `%m [%p]` (sin usuario, base, aplicación ni IP) y `logging_collector` estaba apagado, por lo que la bitácora salía por `stderr` y su destino lo decidía Docker. En la Actividad 3 cambié el RFC de María García como `app_ventas` y, al buscar evidencia, la consulta a `dba.bitacora` devolvió cero filas: no quedó la conexión, ni la sentencia, ni la hora, ni el valor anterior. Los privilegios de la Unidad II permitían ese cambio, pero no dejaban rastro de él.

## 2. Configuración aplicada

| Parámetro | Valor | Cómo se aplica | Por qué |
|---|---|---|---|
| `logging_collector` | `on` | Reinicio (`docker restart dba-u3-pg`) | El colector es un proceso que el servidor lanza al arrancar. Con él, el servidor escribe sus propios archivos y puedo leerlos con SQL. |
| `log_connections` | `on` | Recarga | Registrar quién entra, incluidos los accesos fallidos. |
| `log_disconnections` | `on` | Recarga | Registrar la duración de cada sesión. |
| `log_line_prefix` | `%m [%p] user=%u db=%d app=%a client=%h ` | Recarga | Sin usuario, base, aplicación e IP, una línea dice qué pasó pero no quién ni desde dónde. |
| `log_statement` | `ddl` y después `mod` | Recarga | `ddl` registra estructura y privilegios; `mod` agrega `INSERT`, `UPDATE` y `DELETE`. No usé `all` por el volumen y por el riesgo de registrar datos sensibles. |

Todos los cambios se hicieron con `ALTER SYSTEM`, que escribe en `postgresql.auto.conf`, y los verifiqué en `pg_settings` con la columna `source`. La recarga es asíncrona, así que consulté siempre en un paso aparte. Creé la vista `dba.bitacora` (acceso solo para el administrador) para leer y filtrar el archivo de bitácora con SQL.

## 3. Eventos observados

Los números entre paréntesis son los eventos de la cronología (`evidencias/15-cronologia.md`).

- **Acceso.** `2026-11-03 02:30:20.948 UTC [296] user=app_ventas db=comercial app=[unknown] client=172.17.0.1 FATAL: password authentication failed` (línea 20 de la bitácora exportada, evento 3). Prueba que alguien presentó el nombre `app_ventas` desde 172.17.0.1 y falló. No prueba que haya sido la aplicación, porque el nombre de usuario lo declara el cliente. `app=[unknown]` porque la sesión nunca llegó a establecerse.
- **Privilegio.** `statement: CREATE ROLE rol_temporal LOGIN PASSWORD ...` ejecutado por `postgres` (línea 35, evento 7). La sentencia incluía la contraseña, que quedó en texto claro en la bitácora; eliminar el rol no la borra.
- **Estructura.** `statement: ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20)`, ejecutado por `postgres` desde una sesión local (evento 6). Queda registrado quién y cuándo se cambió el esquema.
- **Datos.** `statement: UPDATE clientes SET telefono = '6679990000' WHERE id = 3`, con `user=app_ventas app=app-ventas-web client=172.17.0.1` (evento 9). Responde quién, cuándo, desde dónde y con qué aplicación, pero no cuál era el teléfono anterior.
- **Error.** `ERROR: permission denied for table clientes` con `STATEMENT: DELETE FROM clientes WHERE id = 5` de `soporte_ana` (evento 10). Es un error de autorización: la identidad ya se había verificado y el servidor rechazó la operación. Se registra gracias a `log_min_error_statement = error`.
- **Configuración.** `parameter "log_statement" changed to "mod"`, escrito por el proceso principal (PID 1) con usuario, base y aplicación vacíos, porque es el servidor quien relee la configuración al recibir la señal de recarga (evento 8).

## 4. Auditoría del dato

Para conservar el valor anterior creé el esquema `auditoria` (sin acceso para `PUBLIC`) y la tabla `auditoria.cambios_clientes`, con momento (`TIMESTAMPTZ`), usuario de sesión, usuario efectivo, aplicación, IP, operación, id del cliente y los registros completos antes y después en `JSONB`. Guardar la fila completa evita rediseñar la tabla si `clientes` cambia (como cuando agregué `segmento`). El disparador `AFTER INSERT OR UPDATE OR DELETE ... FOR EACH ROW` llama a una función `SECURITY DEFINER`, que se ejecuta con los privilegios de su dueño y por eso puede escribir en un esquema al que `app_ventas` no tiene acceso. Fijé su `search_path` para que nadie pueda redirigirla con objetos de otro esquema. Dentro de la función `current_user` es el dueño (`postgres`), así que el usuario real se obtiene con `session_user`.

En el incidente auditado, `app_ventas` cambió el RFC y el registro quedó en el id_evento 1: usuario de sesión `app_ventas`, aplicación `app-ventas-web`, IP 172.17.0.1, de `GAMA780912XYZ` a `GAMA780912ZZZ`. La misma aplicación no pudo leer la auditoría ni borrarla ni desactivar el disparador (`permission denied for schema auditoria`, `must be owner of table clientes`). Con ese registro, la sentencia que restauraría el valor es `UPDATE clientes SET rfc = 'GAMA780912XYZ' WHERE id = 3;` (no la ejecuté para no alterar la auditoría).

## 5. Limitaciones

- **Lecturas.** Con `log_statement = mod` y sin disparador para `SELECT`, la lectura de RFC y teléfono por `soporte_ana` no dejó rastro del contenido; solo constan su conexión y su desconexión. Registrarla exigiría `all`, una función de acceso que registre el uso o `pgaudit`, que no incluí en mi entrega.
- **Volumen.** Un `UPDATE` masivo sobre 5 clientes produjo una línea en la bitácora y cinco filas en la auditoría. Con un millón de registros, la auditoría crecería un millón de filas con dos documentos JSON cada una y el `UPDATE` tardaría mucho más.
- **Administrador con control total.** El propietario de la tabla pudo desactivar el disparador, cambiar el RFC y volverlo a activar sin que quedara en la auditoría. Solo la bitácora lo registró (desactivación, `UPDATE` y reactivación), y quien controla el servidor también podría alterarla.
- **Identidad.** La bitácora registra el rol con que se autenticó la sesión, no la persona. `application_name` lo declara el propio cliente y no es evidencia fuerte; la IP que veo es la de la red de Docker, no la de un equipo concreto.

## 6. Riesgos de la bitácora

- **Secretos expuestos.** La contraseña del rol temporal quedó en texto claro. `\password` evita el problema porque envía solo el resumen SCRAM. La bitácora puede además contener datos personales dentro de las sentencias, así que debe tratarse como información sensible y leerse solo por el administrador o un rol de auditoría.
- **Pérdida.** El archivo vive en el servidor: rota por día o por tamaño, se reemplaza al reiniciar y desaparece si el contenedor se elimina. Por eso exporté la bitácora vigente.
- **Acceso de terceros.** `pg_read_file` solo está disponible para superusuarios, y la vista `dba.bitacora` no tiene acceso para `PUBLIC`.

**Exportación e integridad.** Exporté el archivo vigente con la contraseña de `rol_temporal` sustituida por `<REDACTED>` antes de que saliera del servidor (`evidencias/bitacora-lab01.log`, 184 líneas) y comprobé que la contraseña original no aparece (`grep -c` devuelve 0). El hash SHA-256 es:

```
77ea28c381bacd9c73d3356fd3dac92cee40a28a1929e50094c06bb18f7e8edf
```

- *¿El hash impide modificar la bitácora?* No; permite detectar una modificación posterior, porque cambiar un solo carácter cambia el resultado. No demuestra que el contenido sea verdadero ni quién lo generó.
- *¿Dónde guardarlo?* Aparte del archivo, de preferencia de solo lectura y bajo custodia de otra persona o área. Si vive junto al `.log`, quien lo altere puede recalcular el hash.
- *Riesgos de dejar la bitácora solo en el servidor:* pérdida por rotación o reinstalación, alteración por un administrador, borrado de huellas si el servidor se compromete y acceso a secretos para quien tenga acceso al servidor.
- *Conservación:* propongo un año como mínimo, porque un cambio erróneo puede descubrirse meses después en un cierre contable, y no más, para no acumular datos personales que ya no se necesitan. El plazo definitivo debe fijarlo el responsable de los datos con el área legal, y se formaliza en el LAB-03.

## 7. Cronología y conclusión

La cronología completa está en `evidencias/15-cronologia.md`. Con esta configuración **sí puede demostrarse quién cambió un dato sensible y qué valor tenía antes, pero solo para los cambios ocurridos después de activar la bitácora y mientras el disparador estaba activo**. El cambio de RFC de la Actividad 12 quedó completo: usuario `app_ventas`, aplicación `app-ventas-web`, IP 172.17.0.1, valor anterior `GAMA780912XYZ`.

No puede demostrarse para los cambios previos (Actividades 3 y 7), que son huecos: sin registro no hay hora ni usuario, y no los estimo. Tampoco para el cambio de la Actividad 14, donde la bitácora prueba que `postgres` lo hizo, pero la auditoría estaba desactivada y no conserva el valor anterior. Y ni la bitácora ni el disparador protegen contra un administrador con control total.

## Preguntas de reflexión

**1. ¿Por qué la auditoría no puede configurarse después de un incidente para investigarlo?**
Porque solo registra lo que ocurre a partir del momento en que se activa. En la Actividad 3 el cambio de RFC no dejó ni conexión ni sentencia, y activar la bitácora después no recuperó nada de lo anterior: ese evento sigue siendo un hueco sin hora ni usuario.

**2. ¿Por qué conviene que la bitácora la administre el propio servidor y no el mecanismo de despliegue?**
Con el colector apagado, PostgreSQL solo escribe a `stderr` y el destino lo decide el despliegue (en mi caso, Docker), fuera del control del servidor y con comportamientos distintos según la plataforma. Con el colector activo, el servidor escribe sus archivos, sabe cuál es el vigente y puedo leerlo con SQL igual en cualquier despliegue. Aun así, lo que controla el servidor también lo controla quien lo administra, por lo que además hay que exportar la bitácora.

**3. ¿Por qué el prefijo de línea es tan importante como el nivel de `log_statement`?**
Porque el nivel decide qué se registra y el prefijo decide qué sabes de cada línea. Sin `%u`, `%d`, `%a` y `%h`, una sentencia registrada dice qué se hizo, pero no quién, desde qué aplicación ni desde dónde. Además, `%p` permite agrupar todas las líneas de una sesión.

**4. ¿Qué diferencia práctica hay entre registrar la sentencia y registrar el cambio en el dato?**
La sentencia muestra el texto ejecutado, con el valor nuevo, pero no el anterior: no sirve para restaurar. Un `UPDATE` sobre 5 clientes dejó una línea en la bitácora. La auditoría del dato guarda el antes y el después de cada fila afectada (cinco filas), y permite restaurar el valor.

**5. ¿Qué evidencia ofrece `pg_stat_activity` que no ofrece la bitácora, y viceversa?**
`pg_stat_activity` muestra el estado actual: quién está conectado, qué consulta está ejecutando y desde cuándo, incluso antes de que termine. La bitácora conserva el historial: cuando terminó el reporte de `soporte_ana`, desapareció de `pg_stat_activity`, pero la bitácora siguió mostrando su conexión y la duración de la sesión.

**6. Si el administrador puede cambiar `log_statement` a `none` y desactivar el disparador, ¿quién audita al administrador?**
Dentro del servidor, nadie de forma confiable: en la Actividad 14, `postgres` desactivó el disparador y cambió el RFC sin dejar fila en la auditoría. Lo reduce enviar la bitácora a un sistema externo administrado por otra área, separar a quien opera la base de quien custodia la evidencia, exigir autorización para desactivar controles y revisar periódicamente la bitácora con una persona independiente.
