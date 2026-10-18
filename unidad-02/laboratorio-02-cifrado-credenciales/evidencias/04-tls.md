# ACTIVIDAD 4. Protección de datos durante la comunicación

## Objetivo

Comprender la importancia de proteger la información durante la comunicación entre un cliente y PostgreSQL mediante TLS (Transport Layer Security), para reducir el riesgo de que personas no autorizadas puedan interceptar o leer los datos transmitidos.

## Comando o procedimiento

Se analizó el riesgo de ejecutar consultas SQL, como `SELECT * FROM clientes;`, cuando la conexión entre el cliente y el servidor PostgreSQL no está protegida.

Se identificó TLS como un mecanismo que permite proteger la comunicación mediante cifrado y, cuando está correctamente configurado y verificado, ayuda a autenticar el servidor. Para comprobar la protección de una conexión real, es necesario revisar la configuración de TLS y verificar que la sesión utiliza una conexión cifrada.

##Imagen 
![Evidencia](../imagenes/EVIDENCIAS%20ACTIVIDAD%204.jpg)
## Resultado obtenido

Se identificó que los datos almacenados en una base de datos no son la única información que necesita protección. También es necesario proteger los datos que se transmiten entre el cliente y PostgreSQL. Una conexión sin cifrado puede exponer información a personas que tengan la capacidad de observar el tráfico de red.

## Análisis

La protección de los datos almacenados no garantiza por sí sola la seguridad de la comunicación. Si la conexión no utiliza cifrado, la información transmitida podría quedar expuesta. TLS ayuda a proteger la confidencialidad e integridad de los datos durante el tránsito y permite verificar la identidad del servidor cuando se configura correctamente la validación de certificados.

Sin embargo, utilizar TLS no sustituye otras medidas de seguridad, como el control de permisos, la autenticación segura y la protección de las credenciales.

## Conclusión

La actividad permitió comprender que la seguridad de una base de datos debe abarcar tanto la información almacenada como la que se transmite por la red. La configuración y verificación de TLS son importantes para reducir el riesgo de interceptación de datos y fortalecer la seguridad de las conexiones entre los clientes y PostgreSQL.
