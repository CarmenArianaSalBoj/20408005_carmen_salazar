
## Actividad 12 — Privacidad por diseño


### Objetivo

Analizar el diseño de una aplicación para identificar la recopilación innecesaria de datos personales y proponer medidas de privacidad desde el inicio, aplicando los principios de minimización, limitación de la finalidad y privacidad por defecto.

### Procedimiento

Se revisaron los datos que la aplicación propone recopilar y se evaluó si cada campo tiene una finalidad específica. También se identificaron los datos que requieren una justificación adicional y se propusieron medidas para limitar la recopilación, restringir los accesos y establecer periodos de conservación.

### Resultado

### 1. ¿Qué problemas identificas?

El diseño propone recopilar demasiados datos personales sin definir para qué se utilizará cada uno. Esto aumenta el riesgo de filtraciones, accesos no autorizados y uso indebido de la información. Además, dificulta administrar los permisos, justificar la conservación de los datos y atender solicitudes de cancelación.

### 2. ¿Qué principio de privacidad se está ignorando?

Se ignora principalmente el principio de **minimización de datos**, porque se pretende almacenar toda la información por si pudiera ser útil en el futuro, sin demostrar que sea necesaria. También se relaciona con la limitación de la finalidad, ya que no se especifica para qué se utilizará cada dato.

### 3. ¿Qué preguntas realizarías antes de aprobar el diseño?

- ¿Cuál es la finalidad de la aplicación?
- ¿Qué datos son indispensables para registrar y atender a cada cliente?
- ¿Para qué se utilizará cada campo?
- ¿Qué áreas necesitan consultar cada dato?
- ¿Existe una base legal adecuada para recopilarlo?
- ¿Durante cuánto tiempo se conservará la información?
- ¿Cómo se protegerán los datos y se atenderán las solicitudes de los titulares?

### 4. ¿Qué datos eliminarías?

Eliminaría inicialmente los campos `ocupacion`, `salario`, `estado_civil` y `fecha_nacimiento`, porque no se ha demostrado que sean necesarios para el registro básico de clientes. También evaluaría si `edad`, `direccion` y `codigo_postal` son indispensables. Los campos que no tengan una finalidad justificada no deberían recopilarse.

### 5. ¿Qué datos requerirían una justificación adicional?

- **RFC:** podría ser necesario para facturación u obligaciones fiscales, pero no necesariamente para un registro básico.
- **Edad y fecha de nacimiento:** deben justificarse según los requisitos del servicio. Si solo se necesita verificar un rango de edad, podría ser suficiente registrar ese rango.
- **Teléfono:** se justifica si se utiliza para contactar al cliente o atender solicitudes.
- **Dirección y código postal:** pueden ser necesarios para entregas o servicios que dependan de la ubicación.
- **Ocupación, salario y estado civil:** requieren una justificación específica, porque pueden revelar información personal que no es necesaria para la mayoría de los registros básicos.

### 6. ¿Cómo aplicarías privacidad por defecto?

Configuraría la aplicación para recopilar únicamente los datos indispensables desde el inicio. Además, aplicaría estas medidas:

- Establecer permisos por rol para limitar el acceso a los datos.
- Separar los datos de facturación de los utilizados para atención al cliente.
- Utilizar vistas con información limitada para analítica.
- Definir periodos de conservación y procedimientos de eliminación.
- Proteger los datos mediante controles de acceso, auditoría y medidas de seguridad apropiadas.
- Desactivar por defecto los usos secundarios, como las promociones personalizadas, hasta verificar su justificación y los requisitos aplicables.

### Análisis

Las respuestas muestran que recopilar información sin una finalidad definida aumenta la cantidad de datos que la organización debe proteger y administrar. Por ello, antes de aprobar el diseño, es necesario evaluar cada campo y conservar únicamente aquellos que sean adecuados, pertinentes y necesarios para las actividades de la aplicación.

También se identifica que la privacidad por defecto requiere establecer configuraciones iniciales restrictivas. Los usuarios deben acceder solo a los datos que necesitan para realizar sus funciones, mientras que el área de analítica debe utilizar información generalizada cuando sea suficiente. Asimismo, los datos fiscales o de contacto deben recopilarse únicamente cuando exista una necesidad justificada.

Estas medidas deben complementarse con controles de seguridad, periodos de retención documentados y procedimientos para atender las solicitudes de los titulares. De esta forma, la protección de los datos se incorpora desde el diseño y no únicamente después de que surja un problema.

### Conclusión

La privacidad por diseño consiste en considerar la protección de los datos desde la etapa de diseño de la aplicación, en lugar de intentar resolver los problemas después. La organización debe justificar cada campo, limitar los accesos y establecer medidas de protección y retención acordes con la finalidad del tratamiento.
