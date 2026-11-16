# Informe — Auditoría y trazabilidad en MongoDB Community

**Materia:** Gestión de Seguridad y Desempeño de Bases de Datos  
**Unidad:** III — Auditoría, trazabilidad y gobierno práctico de datos  
**Motor:** MongoDB 7 Community Edition

## 1. Despliegue, edición y limitación

Para realizar el laboratorio se utilizó MongoDB Community Edition versión 7.0.48, desplegado mediante Docker. Se trabajó con el contenedor `dba-u3-mongo` y la base de datos `comercial`.

Se configuraron dos usuarios principales: `admin`, con privilegios administrativos, y `app_ventas`, con el rol `readWrite` sobre la base de datos `comercial`. Esto permitió realizar operaciones administrativas y simular las actividades de una aplicación.

Para verificar la edición instalada se consultó la versión con `db.version()` y se revisó la información del servidor mediante:

```javascript
db.adminCommand({ buildInfo: 1 }).modules
```

El resultado fue un arreglo vacío (`[]`), lo que permitió comprobar que no estaban disponibles los módulos adicionales de Enterprise.

La principal limitación identificada fue que MongoDB Community no cuenta con el sistema de auditoría nativa disponible en MongoDB Enterprise y Atlas. Por ello, durante el laboratorio se utilizaron el perfilador, la bitácora de `mongod` y las instantáneas de privilegios como mecanismos de trazabilidad y controles compensatorios.

## 2. Perfilador

Se utilizó el perfilador de MongoDB para registrar y analizar las operaciones realizadas sobre las colecciones.

Se probaron diferentes niveles de configuración:

- Nivel 0: perfilador desactivado.
- Nivel 1: registra operaciones que cumplen las condiciones establecidas, como las operaciones lentas o un filtro específico.
- Nivel 2: registra todas las operaciones de la base de datos.

Durante la práctica se configuró el nivel 2 para observar consultas, actualizaciones y eliminaciones. Posteriormente, se utilizó el nivel 1 con un filtro para registrar únicamente operaciones de tipo `insert`, `update` y `remove`.

Los registros permitieron identificar información como el tipo de operación, el espacio de nombres, el usuario, el cliente, la aplicación y el tiempo de ejecución.

Por ejemplo, se observó una actualización ejecutada por `app_ventas@comercial`, desde la aplicación `app-ventas-web`, que modificó el teléfono del cliente con `_id: 1`.

El perfilador aporta trazabilidad porque permite reconstruir parte de la actividad realizada en la base de datos. Sin embargo, tiene costos y limitaciones: el nivel 2 puede generar mayor consumo de almacenamiento y afectar el rendimiento. Además, no conserva automáticamente los valores anteriores de los documentos ni sustituye un sistema de auditoría de seguridad.

## 3. Bitácora de mongod

La bitácora del servidor se consultó mediante:

```javascript
db.adminCommand({ getLog: "global" })
```

También se utilizó la función auxiliar `bitacora()` para interpretar los eventos en formato JSON.

En el despliegue utilizado, los registros se consultaron desde la memoria de `mongod` y también podían revisarse desde la salida del contenedor mediante:

```bash
docker logs dba-u3-mongo
```

Se observaron eventos de autenticación exitosa y fallida. Entre los intentos fallidos se identificaron dos situaciones:

- Una contraseña incorrecta para el usuario `app_ventas`.
- Un intento de autenticación con el usuario inexistente `usuario_inexistente`.

También se identificaron eventos relacionados con cambios en la configuración del perfilador, como `Profiler settings changed`.

Mediante el campo `ctx` se relacionaron algunos eventos de una misma conexión. Por ejemplo, se identificó que la conexión `conn31` correspondía a una sesión autenticada como `admin@admin` que realizó un cambio en la configuración del perfilador.

Una limitación importante es que los eventos consultados mediante `getLog` se mantienen en memoria y pueden perderse al reiniciar el servidor. Para una conservación permanente se puede configurar `systemLog.destination: file` y `systemLog.path` en el archivo de configuración de MongoDB.

## 4. Privilegios

Para analizar los cambios de privilegios se utilizaron instantáneas de los usuarios y sus roles, almacenadas en la colección `auditoria.instantaneas_privilegios`.

Se tomó una primera instantánea y posteriormente se agregó el rol `dbAdmin` al usuario `app_ventas` en la base de datos `comercial`.

Al comparar ambas instantáneas se identificó la siguiente diferencia:

- Antes: `app_ventas` tenía únicamente el rol `readWrite`.
- Después: `app_ventas` tenía los roles `readWrite` y `dbAdmin`.

Esto permitió detectar que los privilegios del usuario habían cambiado.

También se comprobó que las consultas realizadas sobre `system.profile` y la bitácora no proporcionaron evidencia suficiente para identificar con certeza quién realizó el cambio y en qué momento exacto.

Como control compensatorio, se utilizaron instantáneas de privilegios para comparar el estado de los usuarios antes y después de una modificación. Posteriormente, se revocó el rol `dbAdmin` para restaurar los privilegios originales.

La principal limitación de este método es que permite detectar diferencias entre dos estados, pero no garantiza la identificación del responsable ni la hora exacta del cambio.

## 5. Conservación

Durante el laboratorio se identificaron riesgos relacionados con la conservación de la evidencia.

El nivel del perfilador configurado mediante `db.setProfilingLevel()` no permanece necesariamente después de reiniciar MongoDB. También se comprobó que la bitácora consultada mediante `getLog` se almacena en memoria y puede perder sus eventos anteriores al reiniciar el servicio.

Por otra parte, la colección `system.profile` tiene un tamaño limitado, por lo que no debe considerarse un almacenamiento histórico permanente.

Para reducir estos riesgos se exportaron los registros a los siguientes archivos:

- `system-profile.json`: contiene los registros del perfilador.
- `bitacora-mongod.log`: contiene los eventos disponibles en la bitácora al momento de la exportación.
- `hashes.sha256`: contiene las huellas digitales de los archivos exportados.

Se verificó la integridad mediante:

```bash
sha256sum -c hashes.sha256
```

El resultado obtenido fue:

```text
system-profile.json: OK
bitacora-mongod.log: OK
```

Esto permitió comprobar que los archivos coincidían con los hashes calculados. Sin embargo, los hashes por sí solos no garantizan la autenticidad ni la conservación a largo plazo; también es necesario proteger los respaldos y controlar quién puede modificarlos.

## 6. Comparación de los tres escenarios

Durante la Actividad 9 se compararon PostgreSQL con bitácora y disparadores, MongoDB Community con perfilador y bitácora, y MongoDB Enterprise/Atlas con auditoría nativa.

PostgreSQL permite utilizar disparadores para registrar modificaciones y conservar valores anteriores y nuevos mediante `OLD` y `NEW`, siempre que se haya implementado esa lógica.

MongoDB Community permite identificar diferentes operaciones mediante el perfilador y consultar eventos de autenticación y configuración mediante la bitácora. Sin embargo, no proporciona automáticamente un historial completo de los valores anteriores ni una atribución completa de los cambios de privilegios con los mecanismos utilizados en este laboratorio.

MongoDB Enterprise y Atlas ofrecen auditoría nativa, con opciones para registrar eventos de autenticación, autorización, operaciones CRUD y cambios de estructura, dependiendo de la configuración y de las capacidades disponibles en cada servicio. Estas características se revisaron documentalmente, pero no se practicaron en este laboratorio.

La comparación demuestra que la trazabilidad depende tanto de las capacidades del motor como de la configuración y de los mecanismos adicionales de conservación.

## 7. Recomendación

Para una organización que necesite auditar cambios de privilegios en MongoDB, recomendaría utilizar MongoDB Enterprise o MongoDB Atlas con auditoría nativa configurada y una política de conservación de registros.

Esta recomendación se basa en que la auditoría nativa ofrece mecanismos específicos para registrar eventos relacionados con autenticación y autorización, lo que permite contar con evidencia más completa que las instantáneas utilizadas en MongoDB Community.

**Hechos verificados durante el laboratorio:**

- MongoDB Community 7.0.48 no tenía módulos adicionales de Enterprise.
- El perfilador permitió registrar operaciones y reconocer usuarios y aplicaciones.
- La bitácora permitió observar autenticaciones y cambios de configuración.
- Las instantáneas permitieron detectar que `app_ventas` recibió el rol `dbAdmin`.
- Los mecanismos utilizados no permitieron atribuir con certeza quién y cuándo realizó ese cambio.

**Aspectos documentados, pero no practicados:**

- La disponibilidad de auditoría nativa en MongoDB Enterprise y Atlas.
- La posibilidad de registrar eventos de autenticación, autorización, CRUD y cambios de estructura mediante la auditoría, según su configuración.

La organización también debería establecer controles de acceso para impedir que los usuarios de las aplicaciones puedan modificar o eliminar los registros de auditoría, conservar las evidencias en un almacenamiento protegido y realizar revisiones periódicas de los privilegios.

Si la organización debe permanecer en Community, recomendaría como mínimo mantener instantáneas periódicas de privilegios, utilizar un proceso externo y protegido para registrar los cambios administrativos, conservar las bitácoras fuera del contenedor y aplicar el principio de mínimo privilegio. Estos controles reducen los riesgos, pero no equivalen a la auditoría nativa.

---

# Preguntas de reflexión

## 1. ¿Por qué el perfilador no debe presentarse como un mecanismo de auditoría de seguridad?

Porque su objetivo principal es registrar operaciones para analizar el comportamiento y rendimiento de la base de datos. Aunque proporciona información sobre usuarios, consultas y modificaciones, no garantiza que todos los eventos de seguridad queden registrados ni permite reconstruir completamente quién realizó cada cambio y con qué intención. Por eso no sustituye un sistema de auditoría de seguridad.

## 2. ¿Por qué el perfilador sí aporta trazabilidad aunque no sea auditoría?

Porque permite conocer qué operaciones se ejecutaron, sobre qué colecciones, cuándo ocurrieron y, en algunos casos, qué usuario y aplicación las realizaron. Esta información ayuda a reconstruir actividades y analizar incidentes, aunque no proporcione toda la evidencia necesaria para una auditoría formal.

## 3. ¿Qué riesgo introduce el nivel 2 al registrar filtros de consultas que pueden contener datos personales?

El nivel 2 registra todas las operaciones, por lo que puede almacenar filtros de consultas que contengan información personal, identificadores o datos sensibles. Si una persona no autorizada obtiene acceso a esos registros, podría consultar información que normalmente estaría protegida. Además, se incrementan el almacenamiento utilizado y el impacto potencial en el rendimiento.

## 4. ¿Qué diferencia hay entre detectar un cambio y atribuirlo a alguien?

Detectar un cambio significa identificar que un dato, una configuración o un privilegio es diferente de su estado anterior. Atribuirlo significa contar con evidencia suficiente para identificar quién realizó la modificación y cuándo ocurrió. En el laboratorio se pudo detectar el cambio de privilegios de `app_ventas`, pero no se pudo identificar con certeza al responsable ni el momento exacto.

## 5. ¿Por qué reconocer una limitación técnica es parte del trabajo profesional del DBA?

Porque un DBA debe conocer las capacidades y limitaciones de las herramientas que administra para no presentar información incompleta como si fuera evidencia definitiva. Reconocer una limitación permite implementar controles adicionales, reducir riesgos y comunicar correctamente qué se puede comprobar y qué información no está disponible. Esto ayuda a tomar decisiones responsables sobre la seguridad y la integridad de los datos.
