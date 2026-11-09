# Evidencia 09 — Sesiones activas con pg_stat_activity

**Estudiante:** Carmen Ariana Salazar Bojorquez 
**Actividad:** 9

## Reporte de larga duración (Terminal A)
**Comando:**
```bash
psql "postgresql://soporte_ana:Soporte_Practica_2026@127.0.0.1:5433/comercial?application_name=reporte-mensual" -c "SELECT pg_sleep(90)"
```
![Evidencia 1](../imagenes/captura9-1.png)
## pg_stat_activity mientras corre el reporte


PID de la sesión de soporte_ana: 579

## Bitácora por PID mientras corre el reporte
![Evidencia 1](../imagenes/captura9-2.png)

## pg_stat_activity después de que terminó
![Evidencia 1](../imagenes/captura9-3.png)

## Bitácora por PID después de que terminó
![Evidencia 1](../imagenes/captura9-4.png)

## Preguntas

**1. ¿Qué columna permite relacionar una sesión con sus líneas de bitácora?**
La columna `pid` de `pg_stat_activity`. Es el identificador del proceso del servidor que atiende la sesión, y la bitácora lo escribe en cada línea mediante `%p` de `log_line_prefix` (aparece entre corchetes, por ejemplo `[296]`). Buscar ese número en `dba.bitacora` devuelve todas las líneas de esa sesión: la conexión recibida, la autenticación, la autorización y la desconexión. Cuidado: el PID se reutiliza con el tiempo, así que conviene acotarlo también con la fecha y hora.

**2. Después de que termina el reporte, ¿qué fuente conserva evidencia de que existió?**
La bitácora. `pg_stat_activity` es una vista del estado actual: muestra solo las sesiones que están abiertas en este momento, y al cerrarse la sesión de `soporte_ana` desapareció de la consulta. En cambio, la bitácora guarda el historial: sigue mostrando la conexión de `soporte_ana` y la línea de desconexión con `session time` (aprox. 1 minuto 30 segundos), el usuario y la IP. Una sirve para ver qué ocurre ahora y la otra para reconstruir lo que ocurrió.

**3. ¿Por qué `client_addr` aparece vacío en la sesión del administrador?**
Porque la sesión de administrador se abre por el socket Unix local (`docker exec ... psql -U postgres`), no por la red. Una conexión por socket local no tiene dirección IP de cliente, por lo que `client_addr` queda vacío (nulo); en la bitácora esa misma sesión aparece con `client=[local]`. La sesión por red de `soporte_ana`, en cambio, sí muestra una IP (`172.17.0.1`, la de la red de Docker).
