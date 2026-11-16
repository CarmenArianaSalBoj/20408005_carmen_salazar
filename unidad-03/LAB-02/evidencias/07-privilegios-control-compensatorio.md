# Actividad 7 - Cambios de privilegios: el límite más importante

**Materia:** DBA  
**Alumna:** Carmen Ariana Salazar Bojórquez

## 1. Instantánea inicial de privilegios

Se creó una instantánea en la colección `auditoria.instantaneas_privilegios` para guardar los usuarios y sus roles actuales.

La captura almacena la fecha y hora, el usuario que realizó la operación y los privilegios de los usuarios de la base de datos `comercial`.

## 2. Modificación de privilegios

Se activó el perfilador en nivel 2 y se otorgó el rol adicional `dbAdmin` al usuario `app_ventas`, que inicialmente contaba únicamente con el rol `readWrite`.

## 3. Búsqueda de evidencia

Se consultaron las siguientes fuentes:

```javascript
db.system.profile.countDocuments({
  "command.grantRolesToUser": { $exists: true }
})
```

```javascript
bitacora().filter(e =>
  JSON.stringify(e).includes("grantRoles")
).length
```

Los resultados obtenidos fueron:

```text
0
0
```

Esto indica que no se encontró evidencia del cambio de privilegios en el perfilador ni en la bitácora global consultada.

## 4. Comparación de instantáneas

Se tomó una segunda instantánea y se compararon ambas capturas.

Los resultados mostraron que inicialmente `app_ventas` tenía el rol `readWrite` y posteriormente contaba con dos roles:

- `readWrite`
- `dbAdmin`

La comparación permitió identificar que los privilegios cambiaron y reconocer cuál fue el rol agregado.

## 5. Preguntas

**¿Por qué un cambio de privilegios es uno de los eventos auditables más importantes?**

Porque un cambio de privilegios puede permitir que un usuario acceda a información o realice operaciones para las que anteriormente no tenía autorización. Si no se controla, puede provocar modificaciones no autorizadas, pérdida de información o exposición de datos sensibles.

**¿Con qué frecuencia tomarías instantáneas? ¿Qué factores influyen?**

Tomaría instantáneas diariamente y también después de cada cambio importante de usuarios o permisos. La frecuencia dependería del nivel de riesgo, la cantidad de usuarios, la importancia de la información y los requisitos de seguridad de la organización.

**¿Quién debería poder escribir en `auditoria.instantaneas_privilegios`?**

Únicamente una cuenta de auditoría o un proceso automatizado autorizado. Los usuarios de las aplicaciones no deberían tener permisos para modificar o eliminar estas evidencias, para evitar que puedan alterar los registros de privilegios.

**Redacta en tres líneas cómo comunicarías esta limitación a Dirección.**

MongoDB Community permite consultar los privilegios actuales y detectar diferencias mediante instantáneas, pero no identifica necesariamente quién realizó un cambio ni el momento exacto.  
Esto representa una limitación para investigar modificaciones de permisos y garantizar la trazabilidad completa.  
Se recomienda complementar el mecanismo con controles de acceso, registros protegidos y una solución de auditoría que permita identificar al responsable de cada cambio.

## 6. Restauración de la configuración

Al finalizar, se revocó el rol `dbAdmin` del usuario `app_ventas`, dejando únicamente su rol original `readWrite`.

También se restableció el perfilador en nivel 1 con el filtro de operaciones de inserción, actualización y eliminación utilizado en la Actividad 4.

## Conclusión

Esta actividad permitió comprobar que las instantáneas sirven para detectar diferencias entre los privilegios de los usuarios. Sin embargo, no permiten identificar con certeza quién realizó el cambio ni el momento exacto en que ocurrió. Por ello, es necesario complementar este mecanismo con controles de seguridad y auditoría que protejan la integridad de las evidencias.
