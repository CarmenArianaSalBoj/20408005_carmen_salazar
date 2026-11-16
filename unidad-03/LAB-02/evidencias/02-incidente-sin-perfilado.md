# Actividad 2 - El incidente sin perfilado

**Materia:** DBA  
**Alumna:** Carmen Ariana Salazar Bojórquez

## Comprobación del perfilador

Primero se consultó el estado del perfilador en la base de datos `comercial` mediante el comando:

```javascript
db.getProfilingStatus()
```

El resultado obtenido fue:

```javascript
{ was: 0, slowms: 100, sampleRate: 1, ok: 1 }
```

El valor `was: 0` indica que el perfilador se encontraba apagado, por lo que las operaciones realizadas no se almacenaban en la colección `system.profile`.

## Modificación realizada por la aplicación

Desde otra terminal se ejecutó una actualización utilizando el usuario `app_ventas`, modificando el RFC del cliente con `_id: 3` a `GAMA780912XXX`.

El comando utilizado fue:

```bash
docker exec dba-u3-mongo mongosh "mongodb://app_ventas:Ventas_Practica_2026@127.0.0.1:27017/comercial?appName=app-ventas-web" --quiet --eval 'db.clientes.updateOne({ _id: 3 }, { $set: { rfc: "GAMA780912XXX" } })'
```

El resultado obtenido fue:

```javascript
{
  acknowledged: true,
  insertedId: null,
  matchedCount: 1,
  modifiedCount: 1,
  upsertedCount: 0
}
```

Esto confirma que MongoDB encontró el documento y modificó correctamente su RFC.

## Preguntas

**1. ¿Puedes demostrar qué cambió? ¿Y quién se conectó a esa hora?**

El resultado de `updateOne()` demuestra que se modificó un documento, específicamente el cliente con `_id: 3`. Sin embargo, como el perfilador estaba apagado, no se generó un registro de esta operación en `system.profile`.

La bitácora global puede mostrar información sobre las conexiones y autenticaciones. En este caso, la conexión se realizó utilizando el usuario `app_ventas` y la aplicación identificada como `app-ventas-web`. Sin embargo, para confirmar los eventos y la hora exacta es necesario consultar los registros de la bitácora.

**2. ¿Por qué `mongosh` abre varias conexiones (`conn8`, `conn9`, …) para una sola instrucción? ¿Cuál es la que se autentica?**

MongoDB Shell puede establecer varias conexiones para realizar diferentes tareas de comunicación con el servidor, como obtener información del servidor y ejecutar operaciones. Por eso aparecen distintos identificadores, como `conn8` y `conn9`.

La conexión que se autentica correctamente es la que muestra el mensaje `Successfully authenticated` en la bitácora. El identificador puede cambiar dependiendo de las conexiones que se hayan realizado anteriormente.

## Conclusión

Esta actividad permitió comprobar que, cuando el perfilador está apagado, no se almacena un registro detallado de las operaciones realizadas sobre los documentos. Aunque el resultado de la actualización confirma que el cambio se realizó correctamente, no es posible reconstruirlo mediante `system.profile`. La bitácora permite revisar información de conexiones y autenticaciones, pero no sustituye el registro detallado de las operaciones.
