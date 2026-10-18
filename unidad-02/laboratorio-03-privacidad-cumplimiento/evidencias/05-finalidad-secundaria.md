
## 11. Actividad 5 — Analizar una finalidad secundaria

La empresa propone utilizar los datos de clientes para una nueva finalidad:

> Enviar promociones personalizadas basadas en la edad, ciudad y comportamiento de compra.

### Objetivo

Analizar si la empresa puede utilizar los datos personales de sus clientes para una finalidad secundaria, como enviar promociones personalizadas basadas en la edad, ciudad y comportamiento de compra, e identificar los requisitos y controles necesarios para realizar este tratamiento.

### Procedimiento

Se revisó la propuesta de utilizar los datos de los clientes con fines de marketing. Para ello, se analizaron la finalidad original de la información, la necesidad de utilizar cada dato, el acceso que requeriría el área de marketing y los controles técnicos que podrían aplicarse para proteger la información personal.

### Resultado

### 1. ¿El hecho de que la organización ya tenga los datos significa automáticamente que puede utilizarlos para cualquier finalidad?

No. Los datos deben utilizarse para finalidades específicas y justificadas. Antes de emplearlos para enviar promociones personalizadas, la organización debe verificar que ese uso sea compatible con la finalidad original y cumpla con las obligaciones de privacidad aplicables.

### 2. ¿Qué preguntas debería realizar la organización antes de implementar este tratamiento?

- ¿Se informó a los clientes que sus datos se utilizarían para enviar promociones?
- ¿Se cuenta con una base legal adecuada para este tratamiento?
- ¿Es necesario utilizar todos los datos propuestos?
- ¿Cómo podrán los clientes rechazar las promociones?
- ¿Durante cuánto tiempo se conservará la información?

### 3. ¿Qué datos serían realmente necesarios?

Depende de cómo se personalicen las promociones. Podrían utilizarse las preferencias de compra, las categorías de productos de interés y la ciudad si se ofrecen promociones locales. El rango de edad solo debería utilizarse si es relevante y está justificado. No serían necesarios el RFC ni el teléfono si las promociones se envían por correo electrónico y no se requieren para otra finalidad autorizada.

### 4. ¿Necesitaría el área de marketing acceso directo a `clientes`?

No necesariamente. Marketing debería acceder únicamente a la información necesaria para preparar y gestionar las promociones. Puede utilizar una vista o una tabla específica que excluya los datos personales y fiscales que no necesita.

### 5. ¿Qué controles técnicos podrían limitar la información entregada?

- **Vistas SQL:** mostrar únicamente las columnas necesarias.
- **Roles y privilegios:** conceder a marketing solo los permisos necesarios.
- **Seudonimización:** utilizar identificadores en lugar de nombres cuando sea posible.
- **Agregación de datos:** generar estadísticas sin identificar a los clientes.
- **Auditoría:** registrar y revisar los accesos realizados.
- **Restricción de acceso:** impedir que marketing consulte directamente la tabla original si no lo necesita.

### Análisis

El análisis muestra que disponer de los datos no significa que la empresa pueda utilizarlos para cualquier propósito. El envío de promociones constituye una finalidad distinta que debe evaluarse antes de implementarse, considerando la información proporcionada a los clientes, la base legal aplicable y los mecanismos para oponerse a este tratamiento cuando corresponda.

También se observa que no todos los datos almacenados son necesarios para personalizar promociones. Utilizar únicamente las preferencias de compra y otros datos pertinentes permite reducir la exposición de información personal. El RFC, por ejemplo, no es necesario para esta actividad.

Desde el punto de vista técnico, las vistas SQL, los roles y los privilegios ayudan a limitar el acceso a la información. La seudonimización y la auditoría complementan estas medidas al reducir la identificación directa y permitir revisar las consultas realizadas.

### Conclusión

La empresa debe evaluar y justificar la finalidad secundaria antes de utilizar los datos de sus clientes para marketing. Se recomienda limitar los datos utilizados, informar adecuadamente a los clientes, establecer mecanismos para rechazar las promociones y aplicar controles de acceso. De esta manera, es posible gestionar las actividades comerciales sin exponer información personal innecesaria.
