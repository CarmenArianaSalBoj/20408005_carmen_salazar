//////////////////////////////////////////////////////////////////////////
--- ACTIVIDAD  8 REVISAR USUARIOS Y PRIVILEGIOS

SELECT
    rolname,
    rolsuper,
    rolinherit,
    rolcreaterole,
    rolcreatedb,
    rolcanlogin
FROM pg_roles
ORDER BY rolname;
