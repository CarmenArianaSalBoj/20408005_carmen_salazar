
## 14. Actividad 8 — Derecho de cancelación y ciclo de vida

### Objetivo

Analizar por qué el derecho de cancelación de los datos personales requiere revisar todo el ciclo de vida de la información y no solamente eliminar un registro de la tabla principal.

### Procedimiento

Se identificaron los lugares donde pueden existir copias de los datos de un cliente, incluyendo tablas relacionadas, respaldos, réplicas, reportes, exportaciones, copias para analítica, registros de auditoría y sistemas externos. Posteriormente, se revisó la necesidad de considerar estas ubicaciones al atender una solicitud de cancelación.

### Resultado

Se identificaron las siguientes ubicaciones donde puede permanecer información personal después de eliminar un registro de la tabla principal:

### Mapa del ciclo de vida de los datos

```text
clientes
   |
   |-- tablas relacionadas
   |-- respaldos
   |-- réplicas
   |-- reportes
   |-- exportaciones
   |-- copias para analítica
   |-- registros de auditoría
   `-- sistemas externos
```

La cancelación debe analizarse durante todo el ciclo de vida de los datos, no solamente en la tabla principal.

### Análisis

Eliminar un registro de la tabla `clientes` no garantiza que toda la información personal haya desaparecido, porque pueden existir copias en otros sistemas, archivos exportados, respaldos o tablas relacionadas. Si estas ubicaciones no se revisan, la información podría seguir almacenada y utilizarse después de la eliminación inicial.

Por ello, la organización debe localizar los datos relacionados con la persona, revisar las obligaciones de conservación aplicables y determinar qué información debe eliminarse, bloquearse o conservarse cuando exista una justificación legal. También debe establecer procedimientos para gestionar respaldos, réplicas y sistemas externos, así como documentar las acciones realizadas.

Los registros de auditoría requieren una revisión particular, ya que pueden ser necesarios para mantener la trazabilidad y cumplir obligaciones. Su conservación debe limitarse a lo justificado y evitar incluir datos personales innecesarios.

### Conclusión

El derecho de cancelación debe gestionarse considerando todas las ubicaciones donde se almacena o reproduce la información personal. Para atenderlo correctamente, la empresa necesita identificar las copias existentes, aplicar las acciones que correspondan según las obligaciones aplicables y documentar el proceso. Esto permite reducir la conservación innecesaria de datos y mejorar el control sobre su ciclo de vida.

