# Laboratorio 03 — Privacidad y cumplimiento

## 1. Introducción

Este laboratorio aborda la protección de los datos personales almacenados en una base de datos PostgreSQL, considerando los principios de privacidad, minimización, finalidad, retención, control de acceso y gobierno de datos.

En el escenario de Comercializadora Norte S.A. de C.V., la tabla `clientes` contiene información como nombre, correo electrónico, teléfono, RFC, edad, ciudad, código postal y fecha de alta.

El problema consiste en determinar si todos estos datos son necesarios, quién debe consultarlos, para qué pueden utilizarse y durante cuánto tiempo deben conservarse. También se analiza cómo atender técnicamente las solicitudes relacionadas con los derechos ARCO.

## 2. Inventario de datos

Los principales datos identificados en la tabla `clientes` son:

| Campo | Clasificación | Finalidad principal |
|---|---|---|
| `id` | Identificador del registro | Relacionar registros de clientes |
| `nombre` | Dato personal | Identificar al cliente |
| `correo` | Dato personal | Contactar al cliente |
| `telefono` | Dato personal | Comunicación y atención |
| `rfc` | Dato personal identificativo | Facturación y obligaciones fiscales |
| `edad` | Dato personal cuando se relaciona con una persona identificable | Estadísticas justificadas |
| `ciudad` | Puede relacionarse con una persona identificable | Operaciones y estadísticas |
| `codigo_postal` | Puede contribuir a identificar o localizar a una persona | Validación de ubicación y análisis regional |
| `fecha_alta` | Dato relacionado con el historial del cliente | Seguimiento de la relación comercial |

La necesidad, el nivel de acceso y el periodo de retención deben determinarse según la finalidad de cada dato. El inventario detallado y sus justificaciones se encuentran en `evidencias/01-inventario-datos.md`.

## 3. Finalidades

Los datos deben utilizarse de acuerdo con las necesidades de cada área:

- **Atención al cliente:** consulta de información básica de identificación y contacto.
- **Facturación:** consulta del nombre, RFC y demás datos fiscales necesarios.
- **Analítica:** uso de información agregada o generalizada para generar estadísticas sin identificar individualmente a los clientes.
- **Administración de la base de datos:** mantenimiento, respaldos, monitoreo y protección de la información.

La existencia de un dato en la base de datos no significa que pueda utilizarse automáticamente para cualquier propósito. Las finalidades secundarias, como las campañas promocionales, deben analizarse antes de implementarse.

## 4. Minimización

El principio de minimización establece que solo deben utilizarse los datos adecuados, pertinentes y necesarios para una finalidad determinada.

Para la atención básica al cliente, se propone limitar la información a `id`, `nombre`, `correo` y `telefono`. Datos como el RFC, la edad y el código postal no deben estar disponibles para esta área si no existe una necesidad justificada.

Para analítica, se propone utilizar consultas que agrupen los datos por ciudad o rango de edad, evitando exponer nombres, correos, teléfonos y RFC cuando no sean necesarios.

Estas medidas pueden implementarse mediante tablas específicas, vistas, consultas agregadas y permisos restringidos.

## 5. Control de acceso

Los permisos deben asignarse de acuerdo con las funciones de cada área, aplicando el principio de mínimo privilegio.

| Área o rol | Acceso propuesto |
|---|---|
| Atención al cliente | Datos básicos necesarios para resolver consultas |
| Facturación | Datos de identificación y fiscales necesarios |
| Analítica | Vistas con información agregada o generalizada |
| DBA | Administración técnica según sus responsabilidades |
| Desarrollo | Datos sintéticos o anonimizados para pruebas |

En PostgreSQL, el control de acceso puede implementarse mediante roles, privilegios `GRANT` y `REVOKE`, vistas y separación de esquemas.

El DBA debe administrar los controles técnicos, pero el acceso administrativo no justifica utilizar los datos para finalidades no autorizadas.

## 6. Derechos ARCO

Los derechos ARCO son acceso, rectificación, cancelación y oposición al tratamiento de datos personales.

Desde el punto de vista técnico:

- **Acceso:** localizar los registros de la persona y preparar la información correspondiente.
- **Rectificación:** actualizar los datos incorrectos y verificar los cambios.
- **Cancelación:** identificar los datos que deban bloquearse o eliminarse cuando corresponda, considerando las obligaciones de conservación.
- **Oposición:** limitar el tratamiento para la finalidad correspondiente cuando proceda.

El DBA debe conocer las tablas, relaciones, respaldos, réplicas, exportaciones, vistas y sistemas que utilizan los datos. Las áreas responsables de privacidad y jurídica deben intervenir en las decisiones que les correspondan.

## 7. Retención

La conservación de los datos debe justificarse según la finalidad, las necesidades operativas y las obligaciones legales aplicables. No todos los campos deben conservarse durante el mismo periodo.

La organización debe documentar los periodos de retención, los responsables de autorizar las acciones y los procedimientos aplicables cuando los datos dejan de ser necesarios.

En PostgreSQL pueden utilizarse consultas de revisión, políticas documentadas y procesos controlados de eliminación. Antes de borrar información, deben verificarse las relaciones entre tablas, los respaldos y las obligaciones de conservación.

## 8. Gobierno de datos

El gobierno de datos permite establecer responsabilidades sobre el uso, la protección y la administración de la información.

| Responsable | Responsabilidad |
|---|---|
| Propietario de los datos o del proceso | Justificar la finalidad y las necesidades de uso |
| DBA | Implementar permisos, administrar la base de datos y mantener controles técnicos |
| Responsable de privacidad | Coordinar las medidas de protección y apoyar la atención de solicitudes |
| Área jurídica | Asesorar sobre las obligaciones legales aplicables |
| Desarrolladores | Implementar controles y utilizar datos de prueba adecuados |
| Usuarios de las áreas | Consultar los datos únicamente para funciones autorizadas |

La matriz detallada de responsabilidades, protección y retención se documenta en `evidencias/11-gobierno-datos.md`.

## 9. Evaluación integral

Los principales riesgos identificados en el escenario son:

| Problema o riesgo | Principio afectado | Control propuesto |
|---|---|---|
| Acceso general de analítica a `clientes` | Mínimo privilegio | Crear vistas con información limitada |
| Uso de datos para finalidades no documentadas | Limitación de finalidad | Documentar y revisar los usos |
| Acceso innecesario al RFC | Minimización | Restringir los permisos |
| Copias reales en desarrollo | Privacidad y confidencialidad | Utilizar datos sintéticos o anonimizados |
| Conservación durante periodos injustificados | Retención | Establecer una política de conservación |
| Ausencia de trazabilidad | Responsabilidad y seguridad | Registrar accesos y cambios relevantes |
| Uso de correos para promociones sin análisis previo | Limitación de finalidad | Revisar la finalidad y las condiciones aplicables |
| Datos personales en reportes detallados | Minimización | Agregar o generalizar los resultados |
| Respaldos sin controles suficientes | Confidencialidad | Protegerlos y limitar su acceso |
| Falta de responsables definidos | Gobierno de datos | Establecer una matriz de responsabilidades |

La evaluación integral completa se encuentra en `evidencias/14-evaluacion-integral.md`.

## 10. Conclusiones

El laboratorio permite comprender que una base de datos técnicamente segura no necesariamente cumple por sí sola con todos los principios de privacidad. También es necesario justificar la recopilación y utilización de los datos, limitar los accesos y definir periodos de conservación.

PostgreSQL proporciona mecanismos técnicos para implementar medidas de protección, como roles, permisos, vistas y registros de auditoría. Sin embargo, las decisiones sobre finalidades, obligaciones legales y atención de solicitudes requieren la participación de las áreas responsables.

La administración de bases de datos debe integrar la seguridad, la privacidad y el gobierno de datos desde el diseño hasta la conservación y eliminación de la información.

## 11. Preguntas de reflexión

### 1. ¿Una base de datos técnicamente segura necesariamente cumple con todos los requisitos de privacidad?

No. Puede contar con permisos y cifrado adecuados, pero utilizar datos para finalidades no autorizadas o conservarlos más tiempo del necesario. La privacidad también requiere controlar el uso de la información.

### 2. ¿Por qué el principio de mínimo privilegio también contribuye a la privacidad?

Porque limita el acceso de cada usuario a los datos necesarios para sus funciones, reduciendo la exposición y el riesgo de uso indebido.

### 3. ¿Por qué el DBA no debería decidir por sí solo la finalidad del tratamiento de los datos?

Porque su responsabilidad principal es técnica. Las finalidades deben ser justificadas por los responsables de los procesos y revisadas con las áreas de privacidad y jurídica cuando corresponda.

### 4. ¿Por qué los desarrolladores no deberían recibir automáticamente copias completas de bases de datos productivas?

Porque pueden contener información personal que no es necesaria para desarrollar o probar aplicaciones. Las copias completas aumentan los lugares donde los datos pueden quedar expuestos.

### 5. ¿Por qué una copia utilizada para desarrollo también puede representar un riesgo de privacidad?

Porque puede contener datos reales y estar en un entorno con controles diferentes a los de producción. Una filtración o publicación accidental podría exponer la información.

### 6. ¿Por qué la retención debe formar parte del ciclo de vida de los datos?

Porque permite determinar cuánto tiempo se necesita conservar la información y cuándo corresponde eliminarla, anonimizarla o bloquearla, respetando las obligaciones aplicables.

### 7. ¿Qué relación existe entre privacidad por diseño y diseño de bases de datos?

La privacidad por diseño incorpora la protección desde el inicio, mediante la selección de campos necesarios, la separación por finalidades, los permisos y las reglas de conservación.

### 8. ¿Qué controles técnicos implementarías para reducir el riesgo de exposición de datos personales?

Implementaría roles con mínimo privilegio, vistas limitadas, cifrado cuando corresponda, conexiones protegidas mediante TLS, auditoría, respaldos protegidos y datos sintéticos o anonimizados para desarrollo.

### 9. ¿Qué información debería conocer un DBA para responder técnicamente a una solicitud ARCO?

Debe conocer las tablas, columnas, relaciones, vistas, permisos, respaldos, réplicas, exportaciones y sistemas que utilizan los datos, así como los procedimientos autorizados para consultarlos, rectificarlos, bloquearlos o eliminarlos.

### 10. ¿Qué responsabilidades deberían corresponder al DBA, al responsable de privacidad, al área jurídica y al propietario de los datos?

El DBA implementa los controles técnicos; el responsable de privacidad coordina la protección de los datos; el área jurídica asesora sobre las obligaciones legales; y el propietario de los datos justifica las finalidades y necesidades operativas. Todos deben colaborar dentro de sus responsabilidades.
