# Actividad 3 - Activar el perfilador y registrar operaciones

**Materia:** DBA  
**Alumna:** Carmen Ariana Salazar Bojórquez

## 1. Activación del perfilador

Se activó el perfilador en nivel 2 dentro de la base de datos `comercial`, utilizando el siguiente comando:

```javascript
db.setProfilingLevel(2)
```

Posteriormente, se comprobó su estado:

```javascript
db.getProfilingStatus()
```

El resultado confirmó que el perfilador quedó activado:

```javascript
{ was: 2, slowms: 100, sampleRate: 1, ok: 1 }
```

El nivel 2 permite registrar todas las operaciones realizadas en la base de datos.

## 2. Operaciones realizadas por la aplicación

Desde la conexión de `app_ventas` se ejecutaron tres operaciones sobre la colección `clientes`:

1. **Consulta (`find`):** se buscaron los clientes cuya ciudad es Culiacán.
2. **Actualización (`updateOne`):** se modificó el RFC del cliente con `_id: 3` a `GAMA780912XYZ`.
3. **Eliminación (`deleteOne`):** se eliminó el cliente con `_id: 2`.

## 3. Interpretación de los registros

| # | Operación | Usuario | Cliente | Aplicación | Qué hizo | Documentos afectados |
|---|---|---|---|---|---|---|
| 1 | query | app_ventas@comercial | 127.0.0.1 | app-ventas-web | Consultó clientes de Culiacán | 3 devueltos; 5 examinados |
| 2 | update | app_ventas@comercial | 127.0.0.1 | app-ventas-web | Modificó el RFC del cliente `_id: 3` | 1 modificado |
| 3 | remove | app_ventas@comercial | 127.0.0.1 | app-ventas-web | Eliminó el cliente `_id: 2` | 1 eliminado |

Los registros del perfilador permiten identificar el tipo de operación, el usuario, la dirección del cliente, la aplicación que realizó la conexión y el momento en que ocurrió cada operación.

## 4. Preguntas

**¿Puedes saber cuál era el RFC antes del cambio con la información de `system.profile`?**

No. El perfilador registra la operación de actualización y el nuevo valor establecido (`GAMA780912XYZ`), pero no conserva automáticamente el valor anterior del RFC. Por lo tanto, no es posible conocer el RFC anterior únicamente con ese registro.

**¿Puedes saber qué datos tenía el documento eliminado?**

No. El registro de eliminación muestra el filtro utilizado (`_id: 2`) y que se eliminó un documento (`ndeleted: 1`), pero no guarda una copia completa de los datos que contenía.

**A diferencia de `log_statement = 'mod'` en PostgreSQL, el nivel 2 sí registró la consulta. ¿Qué ventaja y qué riesgo tiene eso?**

La ventaja es que permite tener mayor trazabilidad, porque registra tanto las consultas como las modificaciones y eliminaciones. Esto ayuda a investigar incidentes y conocer qué operaciones realizaron los usuarios.

El riesgo es que puede generar muchos registros, aumentar el consumo de almacenamiento y afectar el rendimiento. Además, los registros pueden contener información sensible, por lo que deben protegerse y controlarse sus accesos.

**¿Por qué el campo `user` incluye @comercial?**

Porque identifica tanto al usuario autenticado como a la base de datos donde se autenticó. En este caso, `app_ventas` es el usuario y `comercial` es la base de datos asociada a su autenticación.

## Conclusión

Con esta actividad se comprobó que el perfilador de MongoDB en nivel 2 permite registrar consultas, actualizaciones y eliminaciones. Esto proporciona mayor información para investigar las operaciones realizadas por una aplicación. Sin embargo, los registros no conservan necesariamente los valores anteriores ni los documentos eliminados completos, por lo que es importante complementar el perfilado con otros mecanismos de auditoría y respaldo.
