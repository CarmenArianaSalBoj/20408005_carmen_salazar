# Actividad 6 - Correlacionar un cambio de configuración con su autor

**Materia:** DBA  
**Alumna:** Carmen Ariana Salazar Bojórquez

## 1. Identificación del cambio de configuración

Se consultó la bitácora global mediante la función `bitacora()` para localizar el evento `Profiler settings changed`.

El evento mostró que la configuración del perfilador de la base de datos `comercial` fue modificada desde la conexión `conn31`.

El registro incluye la configuración anterior y la nueva, pero no identifica directamente al usuario que realizó el cambio.

## 2. Identificación del usuario

Para identificar al responsable, se buscó el evento `Successfully authenticated` utilizando el mismo identificador de conexión (`conn31`).

El resultado mostró que el usuario `admin`, autenticado en la base de datos `admin`, utilizó esa misma conexión.

Por lo tanto, se relacionaron los dos eventos y se identificó a `admin` como el usuario que realizó el cambio de configuración.

## 3. Preguntas

**¿Qué usuario cambió la configuración del perfilador? ¿Qué dos eventos lo demuestran?**

El usuario `admin` realizó el cambio de configuración del perfilador. Esto se demuestra mediante dos eventos:

- `Profiler settings changed`: registra la modificación de la configuración en la conexión `conn31`.
- `Successfully authenticated`: registra que el usuario `admin` se autenticó utilizando esa misma conexión.

La coincidencia del identificador de conexión permite relacionar ambos eventos.

**¿Qué condición debe cumplirse para que esta correlación sea válida?**

Los dos eventos deben pertenecer al mismo periodo de ejecución del servidor MongoDB. Si el servidor se reinicia, los identificadores de conexión pueden volver a comenzar y reutilizarse. Por eso no sería seguro relacionar eventos de ejecuciones diferentes únicamente por el campo `ctx`.

**¿Por qué es relevante que quede registrado un cambio de configuración del propio mecanismo de registro?**

Porque permite detectar modificaciones que podrían afectar la trazabilidad de la base de datos. Por ejemplo, si alguien desactiva el perfilador o cambia sus filtros, podría reducir la cantidad de operaciones registradas. Identificar quién realizó esos cambios ayuda a detectar posibles manipulaciones y mantener la integridad de la evidencia.

## Conclusión

Esta actividad permitió comprobar que es posible relacionar eventos de configuración y autenticación mediante el identificador de conexión. De esta manera se puede identificar al usuario responsable de modificar el perfilador, siempre que los eventos pertenezcan al mismo periodo de ejecución del servidor.
