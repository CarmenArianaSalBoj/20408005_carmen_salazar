# Actividad 1. Inventario y finalidad de los datos

## Objetivo

Identificar los datos personales almacenados en la base de datos de Comercializadora Norte S.A. de C.V., establecer su finalidad, determinar si son necesarios y proponer niveles de acceso y periodos de retención adecuados.

## Procedimiento

Se analizaron los campos de la tabla `clientes`, considerando las necesidades de atención al cliente, facturación y analítica. Para cada campo se determinó su clasificación, finalidad, necesidad, nivel de acceso y criterio de retención.

## Matriz de inventario de datos

| Campo | ¿Es dato personal? | Finalidad | ¿Es necesario? | Nivel de acceso | Retención |
|---|---|---|---|---|---|
| `id` | No directamente, pero puede identificar a una persona al relacionarse con otros datos. | Identificar registros y relacionar información. | Sí, para administrar los registros. | Limitado a usuarios autorizados. | Mientras existan registros que requieran esa identificación. |
| `nombre` | Sí, identifica a una persona. | Identificar al cliente y brindar atención. | Sí, para atención y facturación. | Atención al cliente, facturación y DBA autorizado según sus funciones. | Mientras sea necesario para la finalidad correspondiente y las obligaciones aplicables. |
| `correo` | Sí, permite identificar o contactar al cliente. | Comunicación y atención al cliente. | Sí, cuando sea necesario contactar al cliente. | Atención al cliente y personal autorizado que lo requiera. | Mientras sea necesario para la comunicación y las obligaciones aplicables. |
| `telefono` | Sí, permite contactar al cliente. | Atención y comunicación. | Sí, cuando se utilice como medio de contacto. | Atención al cliente y usuarios autorizados. | Mientras sea necesario para la finalidad de contacto. |
| `rfc` | Sí, es un dato personal que identifica fiscalmente a una persona física. | Identificación fiscal y facturación. | Sí, cuando se requiera para cumplir obligaciones fiscales. | Principalmente facturación y personal expresamente autorizado. | Durante el periodo necesario para cumplir las obligaciones fiscales y demás requisitos aplicables. |
| `edad` | Sí, cuando está asociada con un cliente identificable. | Estadísticas y segmentación por grupos de edad, si existe una necesidad justificada. | No para la atención básica; puede ser necesaria para estadísticas. | Analítica mediante rangos de edad; acceso individual restringido cuando exista justificación. | Mientras se necesite para la finalidad autorizada; preferentemente usar rangos para estadísticas. |
| `ciudad` | Puede ser dato personal cuando se relaciona con un cliente identificable. | Ubicación general y estadísticas geográficas. | Sí para estadísticas por ciudad; no siempre para atención básica. | Atención al cliente cuando sea necesario y analítica mediante información agregada. | Mientras sea necesaria para la finalidad establecida. |
| `codigo_postal` | Puede ser dato personal cuando se relaciona con otros datos del cliente. | Ubicación y análisis geográfico. | Solo cuando sea necesario para la operación o para estadísticas regionales. | Facturación o atención si se requiere; analítica mediante regiones agrupadas. | Mientras se requiera para la finalidad correspondiente. |
| `fecha_alta` | Puede ser dato personal al relacionarse con un cliente identificable. | Registrar el ingreso del cliente y analizar la antigüedad de la relación comercial. | Sí, si se necesita administrar la relación o generar estadísticas de antigüedad. | Atención al cliente y áreas autorizadas; analítica cuando sea pertinente. | Durante el periodo necesario para la gestión de la relación y las obligaciones aplicables. |

## Justificación de las decisiones

El identificador `id` es necesario para relacionar registros, aunque por sí solo no revele directamente el nombre del cliente. Los campos `nombre`, `correo` y `telefono` se justifican principalmente por las actividades de identificación y contacto.

El RFC requiere mayor restricción porque se utiliza para fines fiscales y no es necesario para todas las áreas. Por su parte, `edad`, `ciudad` y `codigo_postal` deben utilizarse únicamente cuando exista una necesidad concreta. Para analítica es preferible agrupar las edades y regiones y presentar resultados estadísticos, evitando entregar datos que permitan identificar directamente a los clientes.

La fecha de alta permite conocer la antigüedad de la relación comercial, pero no justifica conservar todos los demás datos indefinidamente.

Los periodos de retención indicados son criterios iniciales y no plazos legales definitivos. La organización debe establecerlos según la finalidad, las obligaciones aplicables y las decisiones de las áreas responsables de privacidad, cumplimiento y facturación.

## Resultado

Se identificaron los datos personales y las finalidades principales de cada campo. También se propusieron restricciones de acceso y criterios de conservación para evitar el uso innecesario de información.

## Análisis

Los resultados muestran que no todos los campos de la tabla `clientes` necesitan estar disponibles para todas las áreas. Los datos como `nombre`, `correo` y `telefono` facilitan la identificación y comunicación con los clientes, mientras que el `rfc` requiere mayores restricciones porque se utiliza principalmente para fines fiscales.

Por otra parte, los campos `edad`, `ciudad` y `codigo_postal` pueden utilizarse para generar estadísticas sin necesidad de exponer todos los datos individuales. Para ello, se recomienda trabajar con rangos de edad, regiones agrupadas y resultados estadísticos.

También se identificó la importancia de establecer periodos de retención definidos. Conservar información sin una justificación puede aumentar los riesgos de acceso no autorizado y uso indebido. Por ello, la empresa debe determinar cuánto tiempo necesita cada dato, considerando su finalidad y las obligaciones aplicables.

Finalmente, se recomienda aplicar permisos por roles, limitar el acceso directo a la tabla `clientes` y utilizar vistas que muestren únicamente la información necesaria para cada área. Estas medidas permiten reducir la exposición de datos personales y aplicar el principio de mínimo privilegio.
## Conclusión

El inventario permite reconocer que no todos los datos deben estar disponibles para todos los usuarios. La información debe utilizarse según una finalidad definida, limitarse a lo necesario y conservarse únicamente durante el tiempo justificado. Estas decisiones sirven como base para aplicar minimización de datos y controles de acceso en PostgreSQL.
