# Actividad 5 - Accesos en la bitácora de mongod

**Materia:** DBA  
**Alumna:** Carmen Ariana Salazar Bojórquez

## 1. Intentos de autenticación fallidos

Se realizaron dos intentos de conexión utilizando credenciales incorrectas:

1. Usuario `app_ventas` con una contraseña incorrecta.
2. Usuario `usuario_inexistente`, que no está registrado en MongoDB.

En ambos casos, el servidor devolvió el mensaje:

```text
MongoServerError: Authentication failed.
```

## 2. Consulta de la bitácora

Desde la sesión del DBA se utilizó la función auxiliar `bitacora()` para filtrar los eventos de acceso fallido:

```javascript
bitacora()
  .filter(e => e.c === "ACCESS" && e.msg === "Failed to authenticate")
  .map(e => ({
    t: e.t,
    id: e.id,
    ctx: e.ctx,
    user: e.attr.user,
    client: e.attr.client,
    error: e.attr.error,
    result: e.attr.result,
    app: e.attr.doc.application.name
  }))
```

La bitácora permitió identificar los siguientes errores:

| Intento | Usuario | Error interno | Código |
|---|---|---|---:|
| Contraseña incorrecta | app_ventas | AuthenticationFailed | 18 |
| Usuario inexistente | usuario_inexistente | UserNotFound | 11 |

También se consultó el último acceso exitoso del usuario `app_ventas`, identificando el evento `Successfully authenticated`, cuyo código de resultado fue `0`.

## 3. Preguntas

**¿Qué campo distingue un acceso fallido de uno exitoso?**

El campo `msg` permite distinguirlos. Un acceso fallido muestra `Failed to authenticate`, mientras que uno exitoso muestra `Successfully authenticated`. También se puede revisar el campo `result`: los accesos exitosos tienen valor `0` y los fallidos presentan códigos de error.

**¿Qué diferencia hay entre el error de contraseña incorrecta y el de usuario inexistente? ¿Por qué el cliente recibe el mismo mensaje en ambos casos?**

Cuando la contraseña es incorrecta, MongoDB registra `AuthenticationFailed`, con código `18`. Cuando el usuario no existe, registra `UserNotFound`, con código `11`.

Aunque internamente son errores diferentes, el cliente recibe el mismo mensaje `Authentication failed`. Esto evita revelar si un nombre de usuario existe o no, lo que ayuda a proteger la información de las cuentas.

**¿Por qué el nombre de la aplicación del intento fallido es `mongosh 2.10.0` y no `app-ventas-web`?**

Porque en los comandos de los intentos fallidos no se especificó el parámetro `appName=app-ventas-web` en la cadena de conexión. Por eso MongoDB identifica al cliente con el nombre y la versión de MongoDB Shell: `mongosh 2.10.0`.

En cambio, el acceso exitoso de la aplicación sí utiliza `appName=app-ventas-web`, por lo que aparece identificado con ese nombre.

## 4. Consideración sobre los eventos

Un mismo intento fallido puede generar varias líneas en la bitácora debido a los procesos de autenticación, como la autenticación especulativa (`isSpeculative`). Por esta razón, no se debe contar cada línea como un intento independiente.

## Conclusión

Esta actividad permitió identificar cómo MongoDB registra los accesos exitosos y fallidos. Aunque el cliente recibe el mismo mensaje cuando las credenciales son incorrectas o el usuario no existe, la bitácora permite distinguir ambos casos mediante los errores internos y sus códigos. Esto resulta útil para investigar problemas de autenticación y detectar posibles intentos de acceso no autorizado.
