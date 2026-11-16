# Actividad 1 - Lo que no existe en esta edición

**Materia:** DBA  
**Alumna:** Carmen Ariana Salazar Bojórquez

## 1. ¿Qué edición de MongoDB estás usando? ¿Qué evidencia lo demuestra?

Se está utilizando MongoDB Community Server versión **7.0.48**. Esto se comprobó mediante el comando `db.version()`, que devuelve el número de versión del servidor.

Además, al ejecutar `db.adminCommand({ buildInfo: 1 }).modules`, el resultado es un arreglo vacío (`[]`), lo que demuestra que esta instalación no cuenta con módulos adicionales habilitados que identifiquen funciones de otras ediciones.

## 2. ¿A dónde escribe tu servidor su bitácora? ¿Cómo lo sabes?

El servidor registra sus eventos en la salida estándar del contenedor Docker (`stdout`), por lo que se pueden consultar desde la terminal del sistema mediante el comando:

```bash
docker logs dba-u3-mongo
```

También comprobé que MongoDB mantiene una bitácora global que se puede consultar desde `mongosh` utilizando:

```javascript
db.adminCommand({ getLog: "global" })
```

La función auxiliar `bitacora()` permite convertir los registros a objetos JSON para facilitar su consulta y análisis.

## 3. Según REF-U3-04, ¿qué cuatro categorías de eventos registraría la auditoría nativa?

Según la documentación de MongoDB, la auditoría nativa, disponible en MongoDB Enterprise y MongoDB Atlas, permite registrar cuatro categorías de eventos:

1. **Cambios de esquema (DDL):** registra modificaciones en la estructura de la base de datos.
2. **Eventos de conjuntos de réplicas y clústeres fragmentados:** registra eventos relacionados con la configuración y administración de estos entornos.
3. **Autenticación y autorización:** registra eventos relacionados con el acceso de los usuarios y sus permisos.
4. **Operaciones CRUD:** registra las operaciones de creación, lectura, actualización y eliminación de datos. Para registrar estas operaciones exitosas se requiere configurar `auditAuthorizationSuccess: true`.

## 4. ¿Qué tendría que evaluar una organización antes de licenciar Enterprise o migrar a Atlas solo para obtener auditoría?

Una organización tendría que analizar si realmente necesita las funciones de auditoría nativa y si estas justifican el costo adicional. También debería considerar los requisitos legales de protección de datos, el nivel de trazabilidad que necesita, el impacto en el rendimiento, el almacenamiento de las bitácoras y los recursos necesarios para administrar la plataforma.

En el caso de MongoDB Atlas, también debe considerar que la auditoría está disponible para clústeres M10 o superiores. Por lo tanto, tendría que comparar el costo de utilizar Atlas o Enterprise con los beneficios que obtendría.

## Conclusión

Con esta actividad se identificaron las características de la edición Community de MongoDB y sus limitaciones respecto a la auditoría nativa. Aunque no se dispone de esa funcionalidad, es posible consultar la bitácora global y los registros del contenedor Docker para revisar eventos y obtener información útil sobre la actividad del servidor.
