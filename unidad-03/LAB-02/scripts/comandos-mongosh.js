
// LAB-02 — Trazabilidad en MongoDB Community

// ACTIVIDAD 1. Consultar versión y módulos disponibles
db.version();
db.adminCommand({ buildInfo: 1 }).modules;


// ACTIVIDAD 2. Consultar registros del profiler antes de activarlo
db.system.profile.countDocuments();


// ACTIVIDAD 3. Activar el profiler para registrar todas las operaciones
db.setProfilingLevel(2);
db.getProfilingStatus();

// Consultar operaciones registradas
db.system.profile.find().sort({ ts: -1 }).limit(10);


// ACTIVIDAD 4. Configurar el profiler para registrar solamente escrituras
db.setProfilingLevel(0);
db.system.profile.drop();

db.setProfilingLevel(1, {
  filter: { op: { $in: ["insert", "update", "remove"] } }
});

db.getProfilingStatus();

// Consultar los registros de escritura
db.system.profile.find().sort({ ts: -1 }).limit(10);


// ACTIVIDAD 5. Consultar intentos fallidos de autenticación
function bitacora() {
  return db.adminCommand({ getLog: "global" }).log.map(l => JSON.parse(l));
}

bitacora()
  .filter(e => e.c === "ACCESS" && e.msg === "Failed to authenticate")
  .map(e => ({
    t: e.t,
    user: e.attr.user,
    client: e.attr.client,
    error: e.attr.error,
    result: e.attr.result
  }));


// ACTIVIDAD 6. Relacionar cambios de configuración con el usuario que los realizó
bitacora()
  .filter(e => e.msg === "Profiler settings changed")
  .map(e => ({
    t: e.t,
    ctx: e.ctx,
    attr: e.attr
  }));

// Consultar autenticación de la misma conexión
bitacora()
  .filter(e => e.ctx === "conn31" && e.msg === "Successfully authenticated")
  .map(e => ({
    t: e.t,
    ctx: e.ctx,
    user: e.attr.user,
    db: e.attr.db,
    client: e.attr.client
  }));


// ACTIVIDAD 7. Guardar una instantánea de los privilegios
db.getSiblingDB("auditoria").instantaneas_privilegios.insertOne({
  momento: new Date(),
  tomada_por: db.runCommand({ connectionStatus: 1 }).authInfo.authenticatedUsers,
  usuarios: db.getUsers().users.map(u => ({
    user: u.user,
    db: u.db,
    roles: u.roles
  }))
});

// Consultar permisos asignados al usuario de aplicación
db.getUser("app_ventas");

// Otorgar privilegio adicional para comprobar cambios
db.grantRolesToUser("app_ventas", [
  { role: "dbAdmin", db: "comercial" }
]);

// Comprobar si el cambio aparece en los registros disponibles
db.system.profile.countDocuments({
  "command.grantRolesToUser": { $exists: true }
});

bitacora().filter(e => JSON.stringify(e).includes("grantRoles")).length;

// Guardar una segunda instantánea
db.getSiblingDB("auditoria").instantaneas_privilegios.insertOne({
  momento: new Date(),
  tomada_por: db.runCommand({ connectionStatus: 1 }).authInfo.authenticatedUsers,
  usuarios: db.getUsers().users.map(u => ({
    user: u.user,
    db: u.db,
    roles: u.roles
  }))
});

// Comparar las instantáneas
db.getSiblingDB("auditoria").instantaneas_privilegios
  .find({}, { _id: 0 })
  .sort({ momento: 1 });

// Retirar el privilegio adicional y restaurar el nivel de profiling
db.revokeRolesFromUser("app_ventas", [
  { role: "dbAdmin", db: "comercial" }
]);

db.setProfilingLevel(1, {
  filter: { op: { $in: ["insert", "update", "remove"] } }
});

// Verificar los permisos finales
db.getUser("app_ventas");
db.getProfilingStatus();


// ACTIVIDAD 8. Consultar y exportar los registros
db.system.profile.find().sort({ ts: -1 });

db.adminCommand({ getLog: "global" });


// ACTIVIDAD 9. Consultas de apoyo para comparar los mecanismos de trazabilidad
db.system.profile.find(
  {},
  { op: 1, ns: 1, command: 1, ts: 1, client: 1, appName: 1, user: 1 }
).sort({ ts: -1 });


// ACTIVIDAD 10. Consultar los registros disponibles para responder a la dirección
db.system.profile.find({
  "command.update": { $exists: true }
}).sort({ ts: -1 });

bitacora().filter(e =>
  e.msg === "Successfully authenticated" ||
  e.msg === "Failed to authenticate"
);
