# Actividad 8 — Conservación: exportar antes de perder

## 1. Objetivo

Conservar la evidencia generada por el perfilador y la bitácora de MongoDB mediante su exportación a archivos externos. También comprobar la importancia de respaldar los registros antes de reiniciar el servicio.

## 2. Exportación de system.profile

Se exportaron los registros del perfilador de la base de datos `comercial` al archivo `system-profile.json`.

Se obtuvieron dos registros:

| Operación | Colección | Usuario | Aplicación |
|---|---|---|---|
| update | comercial.clientes | app_ventas@comercial | app-ventas-web |
| command | comercial.system.profile | admin@admin | mongosh 2.14.2 |

El registro de tipo `update` muestra que el usuario `app_ventas` modificó el teléfono del cliente con `_id: 1`, estableciendo el valor `6670000000`.

La exportación permitió conservar información como el tipo de operación, el usuario, la aplicación, la dirección del cliente y la fecha de ejecución.

## 3. Exportación de la bitácora

Se exportó la bitácora de MongoDB mediante el comando `getLog("global")` y se guardó en el archivo:

`bitacora-mongod.log`

Este archivo contiene los eventos disponibles en la memoria de MongoDB al momento de realizar la exportación.

## 4. Verificación de integridad

Se calcularon las huellas digitales SHA-256 de los dos archivos exportados y se guardaron en `hashes.sha256`.

Al ejecutar:

```bash
sha256sum -c hashes.sha256
```

Se obtuvo el siguiente resultado:

```text
system-profile.json: OK
bitacora-mongod.log: OK
```

Esto indica que ambos archivos coinciden con las huellas digitales calculadas y que su integridad fue verificada.

## 5. Preguntas

**1. Menciona tres formas en que la evidencia del perfilador o de la bitácora puede perderse sin que nadie la borre deliberadamente.**

Primero, al reiniciar MongoDB se pierde la información de la bitácora que solamente estaba almacenada en la memoria de `getLog`. Segundo, la colección `system.profile` tiene un tamaño limitado, por lo que los registros antiguos pueden dejar de conservarse cuando se alcanza su capacidad. Tercero, si el contenedor o el almacenamiento donde se encuentran los registros se elimina, se reemplaza o presenta una falla, también puede perderse la evidencia que no tenga un respaldo externo.

**2. ¿Por qué el tamaño de 1 MB de system.profile es un problema de conservación y no solo de espacio?**

Porque limita la cantidad de operaciones que pueden conservarse. Cuando se alcanza ese límite, los registros anteriores pueden dejar de estar disponibles, lo que provoca que se pierda información necesaria para investigar incidentes, identificar operaciones y reconstruir lo sucedido. Por eso representa un problema de trazabilidad y conservación de evidencia, no solamente de almacenamiento.

**3. ¿Por qué getLog sirve para interpretar pero no para conservar?**

Porque `getLog` permite consultar y analizar los eventos recientes de MongoDB, pero los mantiene en memoria y no funciona como un archivo histórico permanente. Al reiniciar el servicio, esa información puede perderse. Para conservarla es necesario exportarla a un archivo o configurar MongoDB para escribir la bitácora en un archivo persistente.

## 6. Conclusión

Esta actividad permitió comprobar la importancia de conservar la evidencia generada por MongoDB. Se exportaron los registros del perfilador y la bitácora a archivos externos, y se calcularon sus hashes SHA-256 para verificar su integridad.

También se identificó que el perfilador puede regresar a su configuración inicial después de un reinicio y que la bitácora almacenada en memoria puede perderse. Por esta razón, es importante realizar respaldos y mantener los registros en un almacenamiento persistente para facilitar futuras auditorías e investigaciones de incidentes.
