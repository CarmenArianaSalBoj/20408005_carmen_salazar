# Evidencia 15 — Cronología y respuestas a Dirección

**Estudiante:** Carmen Salazar
**Actividad:** 17

## Método

Fuentes: la bitácora exportada (`evidencias/bitacora-lab01.log`, citada por número de línea) y la tabla `auditoria.cambios_clientes` (citada por `id_evento`). Todas las horas están en UTC; mi equipo está en UTC-7, así que, por ejemplo, 02:11 UTC del 3 de noviembre son las 19:11 del 2 de noviembre. `172.17.0.1` es la IP de la red de Docker (mi equipo conectándose al puerto publicado) y `[local]` es una sesión por socket del propio servidor.

**Comando para extraer los eventos de la bitácora:**
```bash
grep -nE 'parameter "log_|statement: (REVOKE|GRANT|ALTER TABLE clientes ADD|CREATE ROLE|UPDATE clientes SET (telefono|rfc|segmento)|DELETE FROM (clientes|auditoria)|ALTER TABLE clientes (DIS|EN)ABLE)|permission denied|must be owner|password authentication failed' evidencias/bitacora-lab01.log
```

**Consulta a la auditoría:**
```sql
SELECT id_evento, momento AT TIME ZONE 'UTC' AS momento_utc, usuario_sesion, aplicacion, ip_cliente, operacion, id_cliente
FROM auditoria.cambios_clientes ORDER BY id_evento;
```

## Cronología

| # | Fecha y hora (UTC) | Usuario | Cliente | Tipo de evento | Qué ocurrió | ¿Exitoso? | Fuente |
|---|---|---|---|---|---|---|---|
| 1 | 2026-11-03 01:20:17 | servidor (PID 1) | — | Configuración | Arranca el servidor con el colector de bitácora activo; empieza el archivo exportado | Sí | línea 1 |
| 2 | 2026-11-03 02:11:38 | proceso principal (PID 1) | — | Configuración | Recarga: `log_connections` y `log_disconnections` pasan a `on`, cambia `log_line_prefix` y `log_statement` pasa a `ddl` | Sí | líneas 12 a 15 |
| 3 | 2026-11-03 02:30:20 | app_ventas | 172.17.0.1 | Acceso | Intento de conexión con contraseña incorrecta (`app=[unknown]`: la sesión no llegó a crearse) | No | línea 20 |
| 4 | 2026-11-03 02:30:35 | usuario_inexistente | 172.17.0.1 | Acceso | Intento de conexión con un rol que no existe | No | línea 23 |
| 5 | 2026-11-03 02:51:15 | postgres | [local] | Privilegio | `REVOKE UPDATE ... FROM soporte_ana` y `GRANT UPDATE ... TO app_ventas` (revocación y concesión preventivas: ninguna cambió un permiso real) | Sí | líneas 32 y 33 |
| 6 | 2026-11-03 02:51:28 | postgres | [local] | Estructura | `ALTER TABLE clientes ADD COLUMN segmento` | Sí | línea 34 |
| 7 | 2026-11-03 02:52:01 | postgres | [local] | Privilegio | `CREATE ROLE rol_temporal ... PASSWORD`: la contraseña quedó en texto claro en el servidor (en el archivo exportado aparece como `<REDACTED>`) | Sí | línea 35 |
| 8 | 2026-11-03 03:10:34 | proceso principal (PID 1) | — | Configuración | `log_statement` cambia de `ddl` a `mod` | Sí | línea 50 |
| 9 | 2026-11-03 03:11:03 | app_ventas (`app-ventas-web`) | 172.17.0.1 | Datos | `UPDATE clientes SET telefono = '6679990000' WHERE id = 3` | Sí | línea 55 |
| 10 | 2026-11-03 04:12:49 | soporte_ana | 172.17.0.1 | Error | `DELETE FROM clientes WHERE id = 5` rechazado: `permission denied for table clientes` (error de autorización: la sesión sí existe) | No | líneas 65 y 66 |
| 11 | 2026-11-03 04:41:22 | postgres | [local] | Privilegio | `REVOKE ALL ON SCHEMA auditoria FROM PUBLIC`: el esquema de auditoría queda sin acceso público | Sí | línea 86 |
| 12 | 2026-11-03 04:56:57 | postgres | [local] | Privilegio | `REVOKE ALL ON FUNCTION auditoria.registrar_cambio_cliente() FROM PUBLIC` | Sí | línea 124 |
| 13 | 2026-11-03 05:00:19 | app_ventas (`app-ventas-web`) | 172.17.0.1 | Datos | Cambio de RFC del cliente 3: `GAMA780912XYZ` a `GAMA780912ZZZ` | Sí | línea 134; id_evento 1 |
| 14 | 2026-11-03 05:00:32 | app_ventas (`app=psql`) | 172.17.0.1 | Error | `SELECT * FROM auditoria.cambios_clientes` rechazado: `permission denied for schema auditoria` | No | línea 139 |
| 15 | 2026-11-03 05:11:34 | postgres | [local] | Datos | Alta y baja del cliente 6 (Pedro Ruiz); la baja es el `DELETE` de la bitácora | Sí | línea 148; id_evento 2 y 3 |
| 16 | 2026-11-03 05:19:45 | app_ventas (`app-ventas-web`) | 172.17.0.1 | Error | Intento de `DELETE FROM auditoria.cambios_clientes` (`permission denied for schema auditoria`) y de `DISABLE TRIGGER` (`must be owner of table clientes`) | No | líneas 155 a 159 |
| 17 | 2026-11-03 05:20:07 | postgres | [local] | Datos | Se desactiva el disparador (05:20:07), se cambia el RFC del cliente 3 a `GAMA780912GHI` (05:20:13) y se reactiva (05:20:18) | Sí | líneas 164, 165 y 166; sin id_evento |
| 18 | 2026-11-03 05:49:47 | postgres | [local] | Datos | `UPDATE clientes SET segmento = 'regular'` sobre 5 clientes: una línea en la bitácora, cinco filas en la auditoría | Sí | línea 176; id_evento 4 a 8 |

## Respuestas a Dirección (solo con la evidencia)

**1. ¿Quién cambió el RFC la primera vez (Actividad 3)? ¿Y en las Actividades 7, 12 y 14?**
- **Actividad 3 (`GAMA780912XXX`): No hay evidencia.** En ese momento `log_connections` estaba en `off`, `log_statement` en `none` y no existía el disparador. No quedó registrada la conexión, la sentencia ni la hora.
- **Actividad 7 (`GAMA780912XYZ`): No hay evidencia del cambio.** Con `log_statement = ddl` la sentencia no se registra: en la bitácora exportada solo hay dos `UPDATE` sobre `rfc` (líneas 134 y 165) y ninguno es este. El `id_evento` 1 solo prueba que ese era el valor justo antes de las 05:00:19 UTC, no quién ni cuándo lo puso.
- **Actividad 12 (`GAMA780912ZZZ`): `app_ventas`**, aplicación `app-ventas-web`, desde 172.17.0.1, a las 05:00:19 UTC (línea 134, `id_evento` 1). `usuario_efectivo` es `postgres` porque la función es `SECURITY DEFINER`.
- **Actividad 14 (`GAMA780912GHI`): `postgres`**, sesión local (`app=psql`, `client=[local]`), a las 05:20:13 UTC (línea 165), entre la desactivación (línea 164) y la reactivación (línea 166) del disparador. Este cambio no está en la auditoría.

**2. ¿Quién cambió el teléfono?**
`app_ventas`, aplicación `app-ventas-web`, desde 172.17.0.1, a las 03:11:03 UTC (línea 55). **No hay evidencia del valor anterior:** la bitácora solo guarda la sentencia con el valor nuevo y la auditoría todavía no existía. El teléfono de la carga inicial (`6673456789`, sección 6.5) es el dato de partida, no un registro del cambio.

**3. ¿Hubo intentos de acceso fallidos? ¿De qué usuarios y desde dónde?**
Sí, dos, ambos desde 172.17.0.1: `app_ventas` con contraseña incorrecta (02:30:20 UTC, línea 20) y `usuario_inexistente` (02:30:35 UTC, línea 23). Ocurrieron antes del cambio auditado de la Actividad 12 (05:00:19 UTC), pero la bitácora no permite relacionarlos con él. **Para los cambios de las Actividades 3 y 7 no hay evidencia sobre intentos previos**, porque entonces las conexiones no se registraban. Los rechazos de las líneas 66, 139, 156 y 159 son errores de **autorización**, no de acceso.

**4. ¿Qué valor tenía el RFC antes de cada cambio?**
- **Actividad 3: No hay evidencia.** `GAMA780912GHI` es el valor de la carga inicial (sección 6.5), no un registro.
- **Actividad 7: No hay evidencia.**
- **Actividad 12: `GAMA780912XYZ`**, registrado en `valores_antes` del `id_evento` 1.
- **Actividad 14: no hay registro directo.** La auditoría no tiene ese cambio. Comparar `clientes` con el último valor auditado (`ZZZ`) permite deducir el valor anterior, pero es una inferencia, no un registro.

## Huecos declarados

- Los cambios de RFC de las Actividades 3 y 7 no tienen hora ni usuario porque no se registraron; no los estimo.
- No hay valor anterior del teléfono ni del RFC de la Actividad 14.
- La lectura de RFC y teléfono por `soporte_ana` (Actividad 15) no dejó rastro del contenido: `mod` no registra `SELECT` y el disparador no cubre lecturas.
- La bitácora identifica roles, no personas: si varias personas usaran `app_ventas`, no podrían distinguirse.
