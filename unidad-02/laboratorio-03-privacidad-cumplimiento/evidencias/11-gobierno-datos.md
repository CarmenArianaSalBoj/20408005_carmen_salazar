
## Actividad 11 — Diseñar una matriz de gobierno de datos
### Objetivo

Diseñar una matriz de gobierno de datos que establezca la finalidad de cada dato personal, los responsables de su tratamiento, los usuarios autorizados, las medidas de protección, los periodos de retención y las acciones que deben realizarse cuando la información deje de ser necesaria.

### Procedimiento

Se revisaron los campos personales almacenados en la tabla `clientes` y se relacionaron con las actividades de atención al cliente, facturación y analítica. Para cada campo se definieron responsables, usuarios autorizados, medidas de protección y criterios de conservación y eliminación.

### Resultado



| **Dato** | **Finalidad** | **Responsable** | **Usuarios autorizados** | **Protección** | **Retención** | **Acción al finalizar** |
|---|---|---|---|---|---|---|
| nombre | Identificar al cliente y gestionar solicitudes. | Atención al cliente | Atención al cliente, Facturación | Control de acceso y permisos por rol. | Mientras sea necesario para el servicio y las obligaciones aplicables. | Eliminar o anonimizar cuando ya no sea necesario. |
| correo | Contactar al cliente y enviar información relacionada con el servicio. | Atención al cliente | Atención al cliente; Marketing solo si está autorizado. | Acceso restringido y protección de credenciales. | Mientras sea necesario para la comunicación autorizada. | Eliminar o actualizar cuando corresponda. |
| telefono | Contactar al cliente para resolver solicitudes. | Atención al cliente | Atención al cliente | Acceso restringido y visualización limitada cuando sea posible. | Mientras sea necesario para la atención. | Eliminar cuando deje de ser necesario. |
| rfc | Gestionar facturas y cumplir obligaciones fiscales. | Facturación | Facturación y personal autorizado que lo requiera. | Acceso restringido y registro de consultas. | Durante el periodo exigido por las obligaciones fiscales aplicables. | Eliminar de forma segura al terminar el periodo de conservación, si no existe otra obligación. |
| edad | Elaborar estadísticas mediante rangos de edad, cuando esté justificado. | Analítica | Analítica mediante vistas con rangos de edad. | Generalización de valores y acceso limitado. | Mientras se necesite para los análisis autorizados. | Eliminar o conservar únicamente estadísticas anónimas. |
| ciudad | Elaborar estadísticas geográficas y, cuando corresponda, gestionar servicios locales. | Analítica / Atención al cliente | Analítica mediante vistas; Atención al cliente si lo necesita. | Acceso por rol y agregación para estadísticas. | Mientras exista una finalidad justificada. | Eliminar o conservar estadísticas agregadas que no identifiquen personas. |
| codigo_postal | Gestionar entregas o servicios por zona, cuando sea necesario. | Atención al cliente | Atención al cliente solo para funciones que lo requieran; Analítica mediante región generalizada. | Restricción de acceso y generalización para analítica. | Mientras sea necesario para el servicio o análisis autorizado. | Eliminar o generalizar cuando deje de ser necesario. |

### Análisis

La matriz permite observar que cada dato debe tener una finalidad definida y un responsable que supervise su tratamiento. También demuestra que el acceso debe asignarse según las funciones de cada área, evitando que todos los empleados puedan consultar la información completa de los clientes.

Los datos fiscales, como el `rfc`, requieren mayores restricciones y deben conservarse durante los periodos que correspondan a las obligaciones aplicables. En cambio, datos utilizados para analítica, como `edad`, `ciudad` y `codigo_postal`, pueden generalizarse para reducir la posibilidad de identificar a una persona.

Además, establecer una acción al finalizar el periodo de retención ayuda a evitar que la información permanezca almacenada indefinidamente. Para que la matriz sea efectiva, la empresa debe documentar los plazos definitivos, revisar periódicamente los permisos y verificar que las medidas se apliquen también a copias, respaldos y sistemas relacionados.

### Conclusión

La matriz permite relacionar cada dato con una finalidad concreta y asignar el acceso únicamente a los roles que lo necesitan. También establece medidas de protección y criterios de retención para evitar la conservación indefinida de información personal. Los periodos definitivos deben documentarse según las necesidades operativas y las obligaciones legales aplicables.
