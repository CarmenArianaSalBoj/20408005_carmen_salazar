
## Actividad 15 — Propuesta de arquitectura de datos protegidos

### 1. Objetivo

Diseñar una arquitectura conceptual que separe la información de los clientes según la finalidad de cada área, aplicando controles de acceso, minimización de datos, protección de información sensible, retención, trazabilidad, eliminación y atención de solicitudes.

### Procedimiento

Se identificaron las principales áreas que utilizan los datos de la empresa: operación, analítica y auditoría. Después, se definieron las necesidades de información de cada área y se propusieron controles para limitar el acceso, proteger los datos personales y administrar su ciclo de vida.

### Resultado

#### 1. Arquitectura propuesta

```text
                       BASE DE DATOS
                             |
             +---------------+---------------+
             |               |               |
             v               v               v
       OPERACIÓN         ANALÍTICA        AUDITORÍA
             |               |               |
             v               v               v
      Datos necesarios   Datos agregados   Registros de
      para el servicio   y generalizados   actividad
             |               |               |
             v               v               v
      Atención al        Estadísticas      Revisión de
      cliente y          sin identificar   accesos y
      facturación        directamente      modificaciones
             |
             v
      Datos personales
      protegidos
```

### 2. Controles propuestos

#### Acceso

Crear roles independientes para atención al cliente, facturación, analítica, auditoría y administración de la base de datos. Cada rol tendrá únicamente los permisos necesarios para realizar sus funciones. Se evitará conceder acceso directo a las tablas originales cuando una vista sea suficiente.

#### Minimización

Proporcionar a cada área solamente los campos que necesita. Atención al cliente podrá consultar los datos necesarios para resolver solicitudes; facturación accederá a los datos fiscales requeridos, y analítica utilizará datos agregados o generalizados.

#### Protección de información sensible

Restringir el acceso al RFC y a otros datos personales que requieran protección especial. Aplicar cifrado cuando corresponda, proteger las copias de seguridad y utilizar datos sintéticos o anonimizados en los ambientes de desarrollo y pruebas.

#### Retención

Definir periodos de conservación según la finalidad de cada dato y las obligaciones aplicables. Revisar periódicamente si la información continúa siendo necesaria y documentar la justificación de los periodos establecidos.

#### Trazabilidad

Registrar los accesos relevantes, las modificaciones, los cambios de permisos y las operaciones de eliminación. Los registros deberán incluir información suficiente para identificar al usuario responsable y el momento de la operación, y estarán protegidos contra modificaciones no autorizadas.

#### Eliminación

Establecer procedimientos para eliminar los datos cuando dejen de ser necesarios y no exista una obligación de conservación. Considerar las tablas relacionadas, respaldos, réplicas, exportaciones y sistemas externos, documentando las acciones realizadas.

#### Atención de solicitudes

Implementar un procedimiento para recibir, verificar y atender solicitudes de acceso, rectificación y cancelación. La organización deberá localizar los datos relacionados con el titular, registrar las acciones realizadas y revisar los sistemas donde pueda existir información adicional.

### 4. Beneficios de la arquitectura

- Reduce la exposición de datos personales.
- Evita que todas las áreas consulten la información completa de los clientes.
- Facilita la aplicación del principio de mínimo privilegio.
- Permite utilizar información estadística sin revelar innecesariamente identidades.
- Mejora la trazabilidad y la atención de solicitudes.
- Facilita la aplicación de políticas de retención y eliminación.

### Análisis

La arquitectura propuesta separa las funciones de operación, analítica y auditoría para evitar que todas las áreas tengan acceso a la misma información. Esta separación permite que cada departamento consulte únicamente los datos necesarios para cumplir sus responsabilidades.

El uso de vistas, roles y datos agregados reduce la exposición de información personal. Asimismo, los controles de retención y eliminación permiten administrar los datos durante todo su ciclo de vida, mientras que los registros de auditoría facilitan la revisión de accesos y modificaciones.

Para que la arquitectura funcione correctamente, será necesario configurar los permisos en la base de datos, documentar las responsabilidades de cada área y revisar periódicamente los controles. También deberán considerarse los respaldos y sistemas externos para evitar que la información permanezca almacenada sin justificación.

### Conclusión

La arquitectura propuesta separa los datos de acuerdo con su finalidad y establece controles técnicos para protegerlos durante todo su ciclo de vida. Su implementación permitiría reducir los accesos innecesarios, limitar la exposición de información personal y facilitar el cumplimiento de las políticas internas de privacidad y seguridad.
