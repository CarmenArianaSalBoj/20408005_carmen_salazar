# Laboratorio 1: Protección de datos

**Estudiante:** Carmen Ariana Salazar Bojórquez  
**Materia:** DBA  
**Grupo:** 4-4  

## 19. Informe

### 19.1 Clasificación

En esta actividad se identificaron los datos almacenados en la tabla `clientes`, como el nombre, correo electrónico, teléfono, RFC, edad, ciudad, código postal y fecha de alta.

El nombre, correo electrónico, teléfono y RFC requieren protección porque pueden permitir identificar directamente a una persona. La edad, ciudad, código postal y fecha de alta también deben protegerse, ya que, al combinarse con otros datos, pueden facilitar la identificación de un cliente.

La clasificación permite reconocer qué información necesita protección y establecer medidas adecuadas para evitar el acceso o uso no autorizado.

### 19.2 Enmascaramiento

El enmascaramiento se implementó mediante la vista `v_clientes_soporte`, destinada al área de soporte.

Se ocultaron parcialmente el correo electrónico, el teléfono y el RFC. Por ejemplo, el correo muestra una parte inicial y el dominio, mientras que el teléfono conserva únicamente sus últimos cuatro dígitos.

El mecanismo utilizado fue una vista de PostgreSQL que transforma los valores originales al momento de consultarlos. Además, se otorgaron permisos al rol `soporte` para consultar la vista y se revocó el acceso directo a la tabla original.

Esta medida permite que el personal de soporte consulte información limitada sin necesitar acceso a todos los datos personales completos.

### 19.3 Seudonimización

La seudonimización se realizó mediante la generación de tokens UUID para representar a los clientes. Los tokens se generaron utilizando la función `gen_random_uuid()` de PostgreSQL.

El mapa de correspondencia se encuentra en la tabla `pii.mapa_cliente`, donde se relaciona cada token con el identificador original del cliente.

Los datos destinados al análisis se almacenaron en `analitica.clientes`, utilizando el token y otros atributos necesarios para el análisis.

El mapa debe estar disponible únicamente para personal autorizado que tenga una justificación para relacionar los tokens con los clientes originales.

Se separaron los permisos para que el rol `analista` pueda consultar `analitica.clientes`, pero no tenga acceso a `pii.mapa_cliente` ni a `public.clientes`. Esta separación reduce el riesgo de que una persona pueda relacionar directamente los datos analíticos con la identidad de los clientes.

### 19.4 Anonimización

La anonimización se abordó mediante consultas estadísticas que no incluyen identificadores directos como el nombre, el correo electrónico, el teléfono y el RFC.

Se generalizaron las edades mediante rangos de edad y la región mediante los dos primeros dígitos del código postal. También se combinaron ambos atributos para obtener estadísticas por grupo.

Posteriormente, se utilizó la condición `HAVING COUNT(*) >= 5` para mostrar únicamente los grupos que contienen cinco o más registros.

Los grupos que no cumplen el umbral se excluyen de los resultados de esa consulta. Sin embargo, la ausencia de identificadores directos no garantiza que los datos sean completamente anónimos.

Permanece cierto riesgo de reidentificación debido a los cuasi-identificadores y a la posibilidad de combinar los resultados con información externa. Por ello, es necesario evaluar el tamaño de los grupos y el nivel de detalle de los atributos antes de publicar estadísticas.

### 19.5 Retención

Para la actividad de retención se utilizó un periodo hipotético de conservación de cinco años. Se preparó una consulta SQL para identificar los registros cuya fecha de alta es anterior a la fecha actual menos cinco años.

La consulta permite reconocer los registros que podrían requerir una revisión de conservación. El resultado obtenido fue: [escribir aquí cuántos registros identificó la consulta].

La información que debe conservarse es aquella que siga siendo necesaria para la finalidad establecida o cuyo almacenamiento sea obligatorio conforme a las disposiciones aplicables.

La información que haya dejado de ser necesaria y cuya conservación ya no esté justificada podría ser candidata a eliminación, previa revisión y autorización.

Antes de eliminar datos, deben existir controles como la aprobación del área responsable, la identificación precisa de los registros afectados, un respaldo válido, un procedimiento de recuperación y evidencia documentada de la autorización y de las acciones realizadas.

Durante esta práctica únicamente se identificaron los registros mediante una consulta. No se ejecutó una eliminación física de datos.

### 19.6 Conclusiones

**¿Qué técnica utilizarías para un área de soporte?**

Utilizaría el enmascaramiento mediante una vista de PostgreSQL, porque permite mostrar únicamente la información necesaria para atender las solicitudes sin exponer todos los datos personales.

**¿Qué técnica utilizarías para un área de analítica?**

Utilizaría la seudonimización y la separación de permisos, porque permiten trabajar con datos representados por tokens sin conceder al analista acceso directo al mapa de correspondencia ni a la tabla original.

**¿Qué técnica utilizarías para publicar estadísticas?**

Utilizaría la generalización de atributos, la agregación de resultados y la supresión de grupos pequeños. También evaluaría el riesgo de reidentificación antes de publicar la información.

**¿Por qué ninguna de estas técnicas sustituye al control de acceso?**

Porque estas técnicas protegen los datos de distintas maneras, pero no determinan por sí solas quién puede consultar las tablas o ejecutar operaciones. El control de acceso establece qué usuarios y roles están autorizados para utilizar cada recurso de la base de datos.

## 20. Preguntas de reflexión

### 1. ¿Cuál es la diferencia entre enmascaramiento y seudonimización?

El enmascaramiento oculta parcial o totalmente determinados valores para limitar la información que se muestra. La seudonimización sustituye identificadores directos por tokens u otros valores que pueden relacionarse con la identidad original mediante información adicional protegida.

### 2. ¿Por qué la seudonimización no significa anonimización?

Porque existe un mapa de correspondencia que permite relacionar los tokens con los identificadores originales. Si alguien obtiene acceso a ese mapa, puede recuperar la relación entre los datos y las personas.

### 3. ¿Por qué eliminar `nombre` y `RFC` no garantiza que un conjunto de datos sea anónimo?

Porque otros atributos, como la edad, la ciudad, el código postal o las fechas, pueden combinarse con información externa y permitir identificar a una persona.

### 4. ¿Qué función tienen los cuasi-identificadores?

Son atributos que no identifican necesariamente a una persona por sí solos, pero que, al combinarse con otros datos, pueden ayudar a distinguirla o identificarla. Algunos ejemplos son la edad, la región y determinadas fechas.

### 5. ¿Por qué es importante separar el mapa de seudonimización?

Porque contiene la relación entre los tokens y los identificadores originales. Mantenerlo separado y restringir su acceso disminuye la posibilidad de que una persona pueda identificar a los clientes a partir de los datos analíticos.

### 6. ¿Qué principio de seguridad se aplica al impedir que el analista acceda al mapa?

Se aplica el principio de mínimo privilegio, que establece que cada usuario debe tener únicamente los permisos necesarios para cumplir sus funciones.

### 7. ¿Por qué una vista puede ser preferible a entregar acceso directo a la tabla?

Porque una vista permite mostrar únicamente las columnas y los valores necesarios para una tarea. De esta manera, se reduce la exposición de información y se pueden aplicar permisos específicos sobre los datos mostrados.

### 8. ¿Qué diferencia existe entre proteger un dato para visualización y protegerlo contra acceso no autorizado?

Proteger un dato para visualización significa limitar la información que se muestra, por ejemplo, mediante el enmascaramiento. Protegerlo contra acceso no autorizado implica establecer permisos que impidan consultar o modificar información sin autorización.

### 9. ¿Por qué la retención forma parte de la protección de datos?

Porque conservar información durante más tiempo del necesario aumenta la exposición a accesos indebidos, filtraciones y usos no autorizados. Definir periodos de conservación permite revisar cuándo los datos dejan de ser necesarios y cómo deben eliminarse de manera controlada.

### 10. ¿Qué riesgo existe si una organización conserva información indefinidamente?

Aumenta el riesgo de exposición, pérdida, uso indebido y acceso no autorizado. Además, la organización puede conservar datos que ya no necesita o cuya conservación no está justificada.

## Conclusión general

El laboratorio permitió conocer diferentes técnicas para proteger la información en una base de datos PostgreSQL. La clasificación ayuda a identificar los datos que requieren protección; el enmascaramiento limita la información visible; la seudonimización separa los identificadores de los datos analíticos; la anonimización busca reducir el riesgo de reidentificación, y la retención permite establecer criterios para revisar cuánto tiempo se conserva la información.

Estas técnicas deben complementarse con controles de acceso, permisos adecuados, respaldos y procedimientos documentados. La protección de los datos depende de aplicar medidas acordes con el uso de la información y con los riesgos que pueden presentarse.
