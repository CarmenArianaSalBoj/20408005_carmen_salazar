# Línea base de seguridad para PostgreSQL 16

## 1. Objetivo

Establecer una línea base de seguridad para PostgreSQL 16 que permita identificar la configuración observada, definir controles recomendados y facilitar la verificación periódica del servidor, las cuentas, los datos y el sistema operativo.

Esta línea base distingue entre el **estado verificado en el laboratorio** y las **medidas recomendadas pendientes de implementación**.

## 2. Red

### Estado verificado

- Puerto PostgreSQL: `5432`.
- Dirección de escucha configurada: `localhost`.
- Resultado de `ss -lntp`: PostgreSQL escucha en `127.0.0.1:5432`.
- No se observó una escucha de PostgreSQL en todas las interfaces de red.
- Las reglas de `pg_hba.conf` revisadas incluyen conexiones locales mediante `peer` y conexiones TCP desde `127.0.0.1` y `::1` mediante `scram-sha-256`.

### Baseline propuesta

- Mantener PostgreSQL escuchando únicamente en las interfaces necesarias.
- En un servidor de uso exclusivamente local, conservar `listen_addresses = 'localhost'`.
- Mantener el puerto `5432`, salvo que exista una justificación técnica para cambiarlo.
- Configurar el firewall para permitir TCP/5432 únicamente desde las redes autorizadas.
- Evitar la exposición directa a Internet y las reglas que permitan conexiones desde cualquier origen, como `0.0.0.0/0`, sin una necesidad justificada.
- Documentar las redes autorizadas y revisar periódicamente las reglas de firewall.

**Estado:** la escucha local está verificada. La política de firewall se documentó como recomendación; no se afirma que haya sido aplicada.

## 3. Autenticación

### Estado verificado

- Método de cifrado de contraseñas para nuevas asignaciones: `scram-sha-256`.
- Las reglas locales de `pg_hba.conf` utilizan `peer`.
- Las conexiones TCP de loopback utilizan `scram-sha-256`.

### Baseline propuesta

- Preferir `scram-sha-256` para la autenticación mediante contraseña.
- Utilizar contraseñas largas, únicas y no reutilizadas.
- No almacenar contraseñas en repositorios, scripts SQL, capturas de evidencia ni documentos públicos.
- No asumir que cambiar `password_encryption` actualiza automáticamente las contraseñas existentes.
- Limitar las cuentas administrativas a personal autorizado.
- Utilizar autenticación mediante contraseña o certificados de acuerdo con la política del entorno y los requisitos de acceso.
- Revisar periódicamente las reglas de `pg_hba.conf` y evitar permisos de conexión más amplios de lo necesario.

## 4. Autorización

### Estado verificado

- Se identificó la cuenta `postgres` en la sesión de administración utilizada.
- La existencia y los privilegios de todas las cuentas de aplicación todavía deben comprobarse mediante el inventario de roles.

### Baseline propuesta

- Separar las cuentas administrativas de las cuentas de aplicación.
- Evitar que las aplicaciones se conecten como `postgres`.
- Aplicar el principio de mínimo privilegio.
- Crear roles diferenciados para administración, operación de aplicaciones y consulta.
- Conceder únicamente los privilegios requeridos sobre las bases de datos, esquemas, tablas y secuencias.
- Otorgar permisos de solo lectura a los usuarios que únicamente consultan información.
- Revisar y retirar roles, cuentas y privilegios que ya no sean necesarios.
- Evitar privilegios de superusuario para tareas ordinarias.

Los roles propuestos deben crearse únicamente después de verificar los roles existentes y los requisitos del laboratorio.

## 5. Configuración y conexiones

### Estado verificado

| Parámetro | Valor observado |
|---|---|
| `port` | `5432` |
| `listen_addresses` | `localhost` |
| `max_connections` | `100` |
| `superuser_reserved_connections` | `3` |
| `statement_timeout` | `0` |
| `idle_in_transaction_session_timeout` | `0` |
| `password_encryption` | `scram-sha-256` |

### Baseline propuesta

- Mantener documentados los parámetros relevantes y justificar cualquier modificación.
- Evaluar límites para consultas de larga duración y transacciones inactivas.
- Definir valores de tiempo de espera adecuados para las aplicaciones, considerando sus necesidades.
- Revisar `max_connections` de acuerdo con la capacidad del servidor y el uso de conexiones.
- Supervisar las conexiones activas y detectar sesiones inusuales.
- Inventariar las extensiones instaladas y conservar solo las necesarias.

### Extensiones observadas

- `pgcrypto`, versión `1.3`.
- `plpgsql`, versión `1.0`.

No se recomienda eliminar extensiones sin comprobar antes si las aplicaciones o los ejercicios dependen de ellas.

## 6. Sistema operativo

### Rutas identificadas

- Archivo principal de configuración: `/etc/postgresql/16/main/postgresql.conf`
- Archivo de reglas de acceso: `/etc/postgresql/16/main/pg_hba.conf`
- Directorio de datos: `/var/lib/postgresql/16/main`

### Baseline propuesta

- Verificar que los archivos de configuración y el directorio de datos tengan propietarios y permisos apropiados.
- Restringir la modificación de archivos de configuración a las cuentas administrativas autorizadas.
- Proteger el directorio de datos para impedir el acceso de usuarios del sistema operativo que no lo necesiten.
- Evitar permisos de escritura para usuarios no autorizados.
- Revisar los permisos mediante herramientas del sistema operativo y documentar los resultados.
- No cambiar propietarios ni permisos sin conocer los requisitos del servicio y sin autorización.

**Estado:** las rutas están identificadas; los permisos y propietarios deben registrarse después de ejecutar la inspección correspondiente.

## 7. Cifrado y protección de la información

### Estado verificado

- `ssl = on`.
- `ssl_min_protocol_version = TLSv1.2`.
- La sesión local inspeccionada mostró `ssl = false`; esto es compatible con una conexión mediante socket Unix local y no demuestra que TLS esté deshabilitado en el servidor.
- `password_encryption = scram-sha-256`.

### Baseline propuesta

- Mantener TLS habilitado para las conexiones TCP que lo requieran.
- Exigir y verificar TLS en conexiones de red conforme a la política del entorno.
- Comprobar la versión TLS y el cifrado negociado desde una conexión TCP de prueba.
- Gestionar adecuadamente los certificados y sus claves privadas.
- No incluir contraseñas, tokens ni claves reales en el repositorio.
- Proteger los datos sensibles mediante controles de acceso, permisos mínimos, copias de seguridad protegidas y cifrado cuando corresponda.
- Considerar la protección de las copias de seguridad con medidas equivalentes a las de los datos originales.

**Estado:** TLS está habilitado en la configuración del servidor; falta completar una prueba desde una conexión TCP que confirme el cifrado de la sesión.

## 8. Mantenimiento y revisión

### Baseline propuesta

- Aplicar actualizaciones de seguridad siguiendo el procedimiento autorizado para el entorno.
- Realizar revisiones periódicas de cuentas, roles, privilegios, conexiones y reglas de acceso.
- Mantener copias de seguridad protegidas y comprobar que puedan restaurarse.
- Revisar los registros disponibles para detectar errores de autenticación y actividad inusual.
- Documentar la configuración inicial, los cambios realizados, su justificación y los resultados de las pruebas.
- Repetir las verificaciones después de cambios importantes o actualizaciones.

## 9. Registro de estado

| Control | Estado |
|---|---|
| Puerto y dirección de escucha | Verificados |
| Reglas de `pg_hba.conf` | Inspeccionadas |
| Cifrado de contraseñas configurado | `scram-sha-256` verificado |
| Extensiones | Inventariadas |
| Configuración TLS del servidor | Habilitada; prueba TCP pendiente |
| Roles y privilegios completos | Pendiente de completar el inventario |
| Propietarios y permisos del sistema operativo | Pendiente de verificar |
| Firewall | Recomendación documentada; aplicación no verificada |
| Límites de conexión y tiempos de espera | Inspeccionados; ajuste pendiente de evaluación |
| Cambios de configuración | Documentar solo los que realmente se apliquen |

## 10. Conclusión

La inspección permitió identificar parámetros importantes de PostgreSQL 16, las reglas de autenticación, las extensiones instaladas y las interfaces de escucha. La configuración observada limita la escucha de PostgreSQL a la interfaz local y tiene TLS habilitado en el servidor. Sin embargo, deben completarse la verificación de permisos del sistema operativo, el inventario de roles y privilegios, y la prueba de TLS mediante TCP.

Esta línea base sirve como referencia para evaluar el estado de seguridad actual y planificar mejoras sin confundir recomendaciones con cambios ya aplicados.
