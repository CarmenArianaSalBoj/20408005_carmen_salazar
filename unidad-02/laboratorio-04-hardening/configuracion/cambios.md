## Registro general de cambios y verificaciones

### 1. Objetivo

Documentar el estado observado durante el laboratorio de hardening de PostgreSQL 16, las recomendaciones de seguridad identificadas y las modificaciones que quedan pendientes de implementación.

Este documento diferencia entre las verificaciones realizadas, las propuestas y los cambios efectivamente aplicados.

### 2. Registro de configuración

| Elemento | Estado observado | Acción o recomendación | Estado |
|---|---|---|---|
| Puerto PostgreSQL | `5432` | Mantener el puerto documentado, salvo justificación técnica. | Verificado |
| Dirección de escucha | `localhost` | Mantener la escucha local si no se requiere acceso remoto. | Verificado |
| Reglas de acceso | Reglas locales y TCP de loopback inspeccionadas. | Revisar periódicamente las reglas de `pg_hba.conf`. | Inspeccionado |
| Autenticación | `peer` para conexiones locales y `scram-sha-256` para TCP de loopback. | Mantener métodos apropiados según el tipo de conexión. | Verificado |
| Cifrado de contraseñas | `scram-sha-256` | Mantener este método para nuevas asignaciones de contraseñas. | Verificado |
| TLS | `ssl = on`; protocolo mínimo `TLSv1.2`. | Confirmar el cifrado mediante una conexión TCP. | Prueba pendiente |
| Extensiones | `pgcrypto` 1.3 y `plpgsql` 1.0. | Mantener únicamente las extensiones necesarias. | Inventariadas |
| Conexiones | `max_connections = 100`. | Evaluar límites de acuerdo con las necesidades del servicio. | Evaluación pendiente |
| Tiempos de espera | `statement_timeout = 0` e `idle_in_transaction_session_timeout = 0`. | Evaluar límites apropiados para consultas y transacciones inactivas. | Evaluación pendiente |
| Roles y privilegios | Se identificó la cuenta `postgres`. | Completar el inventario de roles y revisar sus privilegios. | Revisión pendiente |
| Archivos del sistema operativo | Rutas de configuración y datos identificadas. | Verificar propietarios y permisos. | Revisión pendiente |
| Firewall | No se documentó una modificación aplicada. | Definir reglas para permitir únicamente las conexiones autorizadas. | Propuesta pendiente |

### 3. Cambios de configuración aplicados

Con base en las verificaciones documentadas hasta el momento, no se registra en este archivo ninguna modificación de configuración del servidor como aplicada.

Los valores de los parámetros corresponden a la configuración observada durante la inspección. Las recomendaciones de hardening se mantienen como propuestas hasta que se implementen y se comprueben.

### 4. Medidas de seguridad pendientes

1. Completar el inventario de cuentas y privilegios.
2. Verificar propietarios y permisos de los archivos de configuración y del directorio de datos.
3. Realizar una prueba de conexión TCP para confirmar el uso de TLS.
4. Evaluar límites para consultas de larga duración y transacciones inactivas.
5. Revisar las políticas de firewall aplicables al entorno.
6. Documentar cualquier cambio futuro con su justificación y resultado de verificación.

### 5. Procedimiento para registrar futuros cambios

Para cada modificación que se aplique, registrar:

- Fecha de realización.
- Archivo o parámetro modificado.
- Valor anterior.
- Valor nuevo.
- Justificación de seguridad.
- Resultado de la verificación.
- Evidencia asociada.

### 6. Conclusión

El laboratorio permitió inspeccionar la configuración de red, autenticación, cifrado, conexiones y extensiones de PostgreSQL 16. Se identificaron recomendaciones para fortalecer el control de acceso, revisar permisos y verificar TLS.

Las propuestas pendientes no se consideran cambios aplicados. Cualquier modificación posterior deberá documentarse y verificarse para mantener un registro confiable del proceso de hardening.
