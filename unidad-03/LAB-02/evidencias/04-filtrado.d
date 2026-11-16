# Actividad 4 - Reducir el volumen con un filtro

**Materia:** DBA  
**Alumna:** Carmen Ariana Salazar Bojórquez

## 1. Configuración del filtro

Primero se desactivó el perfilador y se eliminaron los registros anteriores de `system.profile`:

```javascript
db.setProfilingLevel(0)
db.system.profile.drop()
```

Después se activó el perfilador en nivel 1, aplicando un filtro para registrar únicamente las operaciones de inserción, actualización y eliminación:

```javascript
db.setProfilingLevel(1, {
  filter: {
    op: { $in: ["insert", "update", "remove"] }
  }
})
```

Se comprobó la configuración mediante `db.getProfilingStatus()`. El resultado mostró que el perfilador estaba activo en nivel 1 y que el filtro estaba aplicado.

## 2. Operaciones realizadas

Desde la aplicación `app_ventas` se ejecutaron dos operaciones sobre la colección `clientes`:

1. Una consulta (`find`) para buscar el documento con `_id: 1`.
2. Una actualización (`updateOne`) para cambiar el teléfono a `6670000000`.

Al consultar `system.profile`, se observó que únicamente apareció la operación `update`, mientras que la consulta no fue registrada debido al filtro configurado.

## 3. Preguntas

**¿Qué perdiste de evidencia al aplicar el filtro? ¿Qué ganaste?**

Perdí el registro de las consultas de lectura (`query`), por lo que ya no puedo conocer desde el perfilador qué información consultó la aplicación. A cambio, reduje la cantidad de registros almacenados y conservé las operaciones que modifican los datos, como inserciones, actualizaciones y eliminaciones.

**¿Qué filtro usarías si solo interesaran operaciones sobre la colección clientes?**

Utilizaría el campo `ns`, que identifica el espacio de nombres de la colección:

```javascript
db.setProfilingLevel(1, {
  filter: {
    ns: "comercial.clientes"
  }
})
```

Este filtro permite registrar las operaciones de la colección `clientes` dentro de la base de datos `comercial`.

Si únicamente interesaran las modificaciones sobre esa colección, combinaría el criterio `ns` con el filtro de operaciones:

```javascript
db.setProfilingLevel(1, {
  filter: {
    ns: "comercial.clientes",
    op: { $in: ["insert", "update", "remove"] }
  }
})
```

## Conclusión

Esta actividad permitió comprobar que los filtros del perfilador ayudan a reducir el volumen de información almacenada. Al registrar únicamente las modificaciones, se obtiene evidencia más específica sobre los cambios realizados en la base de datos, aunque se pierde información sobre las consultas de lectura.

