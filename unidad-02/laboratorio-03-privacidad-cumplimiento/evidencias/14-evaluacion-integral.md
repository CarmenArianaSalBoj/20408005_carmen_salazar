
## 20. Actividad 14 — Escenario integral

### Objetivo

Identificar y evaluar los principales riesgos relacionados con el acceso, uso, conservación y protección de los datos personales de los 50,000 clientes de la empresa, proponiendo controles para mejorar su gobierno y seguridad.

### Procedimiento

Se analizó el escenario de la empresa y se identificaron los problemas relacionados con los permisos de acceso, la recopilación y utilización de datos, las copias de desarrollo, la conservación de información, las campañas promocionales y la atención de solicitudes de los titulares. Para cada problema se determinó el principio afectado, el riesgo asociado y un control para reducirlo.

### Resultado

La empresa presenta diversos riesgos relacionados con el acceso, el uso, la conservación y la protección de los datos personales de sus 50,000 clientes. La siguiente matriz identifica los principales problemas y propone controles para reducirlos.

| **Problema** | **Principio afectado** | **Riesgo** | **Control propuesto** |
|---|---|---|---|
| 1. Todo el personal de analítica puede consultar directamente la tabla `clientes`. | Mínimo privilegio y confidencialidad. | Acceso innecesario a datos personales y posible exposición de información sensible. | Crear una vista con información agregada y otorgar acceso únicamente a esa vista mediante roles. |
| 2. Analítica puede consultar nombres, correos y teléfonos, aunque solo genera estadísticas mensuales. | Minimización de datos. | Uso y exposición de datos que no son necesarios para el análisis. | Proporcionar únicamente datos agregados, como cantidad de clientes por ciudad o rango de edad. |
| 3. Los datos se conservan desde hace 12 años sin una política documentada. | Limitación de la conservación. | Acumulación innecesaria de datos y mayor impacto ante una filtración. | Establecer periodos de retención justificados según la finalidad y las obligaciones aplicables. |
| 4. Los desarrolladores reciben copias completas de la base de datos. | Minimización y confidencialidad. | Exposición de información personal a personas que no la necesitan para desarrollar o probar el sistema. | Utilizar bases de datos de prueba con datos sintéticos o anonimizados. |
| 5. Las copias de desarrollo contienen información real. | Privacidad por diseño y seguridad. | Filtraciones accidentales, divulgación de datos y uso indebido durante las pruebas. | Enmascarar o sustituir los datos personales antes de crear las copias de desarrollo. |
| 6. Marketing utiliza los correos electrónicos para campañas promocionales sin una finalidad claramente documentada. | Limitación de la finalidad y transparencia. | Uso de los datos para una finalidad secundaria sin verificar su justificación ni los requisitos aplicables. | Documentar la finalidad, verificar la base legal y los avisos de privacidad aplicables, y establecer mecanismos para gestionar las preferencias de los clientes. |
| 7. No existe documentación que relacione cada dato con su finalidad. | Limitación de la finalidad y responsabilidad. | Uso de información para actividades no justificadas y dificultad para demostrar el cumplimiento. | Crear una matriz de gobierno de datos que defina finalidad, responsable, usuarios autorizados y periodo de conservación por campo. |
| 8. No se especifican permisos diferentes para cada área. | Mínimo privilegio y control de acceso. | Empleados con permisos superiores a los necesarios para sus funciones. | Definir roles separados para atención al cliente, facturación, analítica, marketing y administración técnica. |
| 9. No se indica cómo se registran ni revisan los accesos a la información. | Responsabilidad y seguridad. | Dificultad para detectar accesos indebidos e investigar incidentes. | Habilitar registros de auditoría, revisar eventos relevantes y proteger los registros contra modificaciones no autorizadas. |
| 10. No se especifica cómo se protegen las copias de la base de datos. | Confidencialidad e integridad. | Copias expuestas por permisos inadecuados, almacenamiento inseguro o transferencia no protegida. | Restringir el acceso, cifrar las copias cuando corresponda y proteger su transferencia y almacenamiento. |
| 11. No se establece cómo atender solicitudes de acceso, rectificación o cancelación. | Derechos de los titulares y responsabilidad. | Solicitudes incompletas, cambios incorrectos o información que permanece en sistemas no identificados. | Definir un procedimiento para verificar solicitudes, localizar los datos, registrar las acciones y revisar copias y sistemas relacionados. |
| 12. No se indica cómo se eliminan los datos cuando dejan de ser necesarios. | Limitación de la conservación y minimización. | Información personal que permanece en respaldos, exportaciones y sistemas de desarrollo después de finalizar su finalidad. | Definir procedimientos de eliminación segura y gestionar respaldos, réplicas, exportaciones y sistemas externos según sus ciclos de conservación. |

### Análisis

La matriz muestra que los riesgos de la empresa están relacionados entre sí. El acceso amplio a la tabla `clientes`, la entrega de copias con datos reales y la falta de controles de auditoría aumentan la posibilidad de exposición de información personal. Estos problemas pueden agravarse cuando los datos se conservan durante largos periodos sin una finalidad documentada.

También se observa que las áreas de analítica y marketing no necesitan necesariamente los mismos datos que atención al cliente o facturación. Por ello, es importante definir permisos por rol, utilizar vistas con información limitada y proporcionar datos agregados cuando sean suficientes para elaborar estadísticas.

La ausencia de una política de retención y de procedimientos para atender solicitudes de los titulares dificulta controlar el ciclo de vida de la información. Para corregirlo, la empresa debe documentar las finalidades, justificar los periodos de conservación y establecer procedimientos que contemplen las tablas relacionadas, los respaldos, las exportaciones y los sistemas externos.

Se recomienda priorizar la restricción de accesos innecesarios, la sustitución de datos reales en los entornos de desarrollo y la definición de una política de retención. Posteriormente, deben fortalecerse la auditoría, la protección de copias y los procedimientos para atender solicitudes de los titulares.


### Conclusión

La empresa debe limitar el acceso a los datos según las funciones de cada área, utilizar información agregada para analítica y evitar el uso de datos reales en desarrollo cuando no sea necesario. También necesita documentar las finalidades, establecer periodos de retención justificados y aplicar controles de seguridad y auditoría. Estas medidas reducen la exposición de información personal y facilitan la gestión responsable de los datos durante todo su ciclo de vida.
