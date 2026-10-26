# Laboratorio 04 — Hardening

## Objetivo

Inspeccionar la configuración de seguridad de PostgreSQL 16, identificar posibles riesgos en la superficie de ataque y elaborar una propuesta de hardening basada en controles de red, autenticación, autorización, cifrado, sistema operativo y mantenimiento.

El laboratorio busca aplicar el principio de mínimo privilegio, reducir la exposición innecesaria y documentar las verificaciones realizadas, las recomendaciones y los cambios que realmente se apliquen.

## Entorno

- **Sistema gestor:** PostgreSQL 16.
- **Versión observada:** PostgreSQL 16.15.
- **Base de datos de laboratorio:** `laboratorio1`.
- **Puerto configurado:** `5432`.
- **Dirección de escucha configurada:** `localhost`.
- **Dirección observada mediante `ss -lntp`:** `127.0.0.1:5432`.
- **Archivo principal de configuración:** `/etc/postgresql/16/main/postgresql.conf`.
- **Archivo de autenticación:** `/etc/postgresql/16/main/pg_hba.conf`.
- **Directorio de datos:** `/var/lib/postgresql/16/main`.
- **Método de cifrado de contraseñas:** `scram-sha-256`.
- **TLS:** habilitado mediante `ssl = on`.
- **Versión mínima de TLS configurada:** `TLSv1.2`.

## Superficie de ataque inicial

La superficie de ataque comprende los puntos mediante los cuales un usuario o proceso podría intentar acceder al servidor, autenticarse, utilizar privilegios o acceder a información almacenada.

Durante la inspección se revisaron los siguientes componentes:

- Interfaces y puertos de escucha.
- Reglas de acceso y autenticación de `pg_hba.conf`.
- Roles, atributos administrativos y privilegios.
- Parámetros de configuración y límites de conexión.
- Extensiones instaladas.
- Configuración de TLS y estado de cifrado de la sesión.
- Archivos de configuración y directorio de datos.
- Controles del sistema operativo y política de firewall.

La inspección inicial mostró que PostgreSQL escucha en la interfaz local. No se observó una escucha del servicio en todas las interfaces de red.

## Hallazgos

1. **Exposición de red:** PostgreSQL escucha en `127.0.0.1:5432`, de acuerdo con el resultado obtenido mediante `ss -lntp`.
2. **Autenticación:** las reglas inspeccionadas utilizan `peer` para conexiones locales y `scram-sha-256` para conexiones TCP desde las direcciones de loopback.
3. **Cifrado de contraseñas:** el parámetro `password_encryption` tiene el valor `scram-sha-256`.
4. **TLS:** el servidor tiene TLS habilitado y establece `TLSv1.2` como versión mínima configurada.
5. **Sesión inspeccionada:** la sesión local consultada mostró `ssl = false`. Esto no demuestra que TLS esté deshabilitado en el servidor; debe verificarse mediante una conexión TCP.
6. **Parámetros de conexión:** `max_connections` tiene el valor `100`, mientras que `statement_timeout` e `idle_in_transaction_session_timeout` tienen el valor `0`.
7. **Extensiones:** se identificaron `pgcrypto` versión `1.3` y `plpgsql` versión `1.0`.
8. **Sistema operativo:** se identificaron las rutas de configuración y del directorio de datos; sus propietarios y permisos deben verificarse.
9. **Autorización:** se identificó la cuenta `postgres` durante la sesión administrativa. El inventario completo de roles y privilegios debe documentarse con los resultados de las consultas correspondientes.

Los hallazgos anteriores describen la configuración inspeccionada. Los elementos pendientes no se consideran vulnerabilidades confirmadas sin una evaluación adicional.

## Cambios realizados

Durante el laboratorio se realizaron actividades de inspección y documentación de la configuración de PostgreSQL 16.

Se documentaron:

- Los parámetros principales de seguridad.
- Las reglas de acceso interpretadas por PostgreSQL.
- Las extensiones instaladas.
- Las rutas de configuración.
- La dirección de escucha y el puerto.
- Las recomendaciones para separar cuentas administrativas y de aplicación.
- Una propuesta de línea base de seguridad.

Las recomendaciones pendientes incluyen completar la revisión de roles y privilegios, verificar los permisos del sistema operativo y realizar una prueba TCP de TLS.

No se registran modificaciones de configuración del servidor como aplicadas en este README. Si se aplican cambios posteriormente, deberán documentarse en `configuracion/cambios.md` con sus valores anteriores y nuevos, justificación y resultado de verificación.

## Justificación de los cambios

Las medidas propuestas buscan reducir los riesgos de acceso no autorizado y limitar el impacto de posibles incidentes.

- **Escucha local:** reduce la exposición de red cuando no se requiere acceso remoto.
- **SCRAM-SHA-256:** proporciona un método de autenticación mediante contraseña más robusto que los métodos obsoletos basados en contraseñas sin protección adecuada.
- **Separación de cuentas:** evita que las aplicaciones utilicen privilegios administrativos innecesarios.
- **Mínimo privilegio:** limita las operaciones que cada rol puede ejecutar.
- **TLS:** protege la confidencialidad e integridad del tráfico de red cuando se configura y verifica correctamente.
- **Control de conexiones:** permite evaluar el uso de recursos y reducir riesgos asociados con sesiones prolongadas.
- **Protección del sistema operativo:** restringe el acceso a los archivos de configuración y a los datos almacenados.
- **Mantenimiento:** ayuda a conservar la seguridad mediante actualizaciones, revisiones periódicas y documentación.

## Verificación

Las verificaciones se realizan mediante consultas SQL y comandos del sistema operativo.

| Control | Método | Resultado |
|---|---|---|
| Puerto y dirección de escucha | `SHOW port;`, `SHOW listen_addresses;` | `5432` y `localhost` |
| Escucha efectiva | `ss -lntp` | `127.0.0.1:5432` |
| Reglas de autenticación | Consulta a `pg_hba_file_rules` | Reglas inspeccionadas |
| Cifrado de contraseñas | `SHOW password_encryption;` | `scram-sha-256` |
| Configuración TLS | `SHOW ssl;` y `SHOW ssl_min_protocol_version;` | `on` y `TLSv1.2` |
| Extensiones | Consulta a `pg_extension` | `pgcrypto` y `plpgsql` |
| Roles | Consulta a `pg_roles` | Inventario por completar |
| Permisos del sistema operativo | `ls -l` y `ls -ld` | Pendiente de registrar |
| Uso de TLS en conexión TCP | Consulta a `pg_stat_ssl` durante una conexión TCP | Pendiente de completar |

Los resultados y las capturas de evidencia se encuentran organizados en la carpeta `evidencias/`, según las comprobaciones realizadas.

## Checklist de hardening

- [x] Identificar la superficie de ataque.
- [x] Identificar las interfaces de escucha.
- [x] Identificar el puerto PostgreSQL.
- [x] Inspeccionar `pg_hba.conf`.
- [x] Analizar los métodos de autenticación.
- [x] Revisar el parámetro `password_encryption`.
- [ ] Completar el inventario de cuentas administrativas y privilegios.
- [x] Proponer la separación de cuentas administrativas y de aplicación.
- [x] Revisar las extensiones instaladas.
- [x] Revisar los parámetros de conexión.
- [ ] Verificar propietarios y permisos del sistema operativo.
- [x] Inspeccionar la exposición de red.
- [x] Revisar la configuración TLS del servidor.
- [ ] Confirmar el uso de TLS mediante una conexión TCP.
- [x] Elaborar una línea base de seguridad.
- [x] Documentar las recomendaciones y el estado de los cambios.
- [ ] Completar las verificaciones pendientes y actualizar esta lista.

Las casillas se marcarán conforme se realicen las comprobaciones y se obtengan sus evidencias.

## Conclusiones

La inspección permitió conocer aspectos importantes de la configuración de PostgreSQL 16, entre ellos la escucha local, las reglas de autenticación, el método de cifrado de contraseñas, las extensiones instaladas y la configuración TLS del servidor.

La línea base propuesta establece controles para limitar la exposición de red, separar las cuentas según sus responsabilidades, aplicar el principio de mínimo privilegio y proteger la información almacenada y transmitida.

Para completar la evaluación es necesario registrar los permisos del sistema operativo, finalizar el inventario de roles y privilegios y comprobar TLS desde una conexión TCP. Estas verificaciones permitirán respaldar las conclusiones con evidencia y mantener una distinción clara entre los controles observados y las mejoras pendientes.
