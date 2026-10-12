-------------------------------------------------------------------
///////////////////////////////////////////////////////////////////
-------------------------------------------------------------------
---ALUMNA: CARMEN ARIANA SALAZAR BOJÓRQUEZ-------------------------
---ACTIVIDAD 1-PROTECCIÓN DE CREDENCIALES--------------------------

--7.1------CREAR LA TABLA usuarios_insegura---------------------------
CREATE TABLE usuarios_insegura (
id BIGSERIAL PRIMARY KEY,
usuario VARCHAR (50) NOT NULL,
password VARCHAR(100) NOT NULL
);

-------INSERTAMOS USUARIOS A LA TABLA usuarios_insegura------------
INSERT INTO usuarios_insegura(usuario,password)
VALUES ('juan','Password123');

-------CONSULTAMOS LA INSERCCIÓN DE LOS DATOS
SELECT * FROM usuarios_insegura;

--7.3--------GENERAR UNA REPRESENTACIÓN NO REVERSIBLE-------------------------------------------------
SELECT crypt(
    'Password123',
    gen_salt('bf')
);
----EJECUTAR NUEVAMENTE-------------------------------------------------
SELECT crypt(
    'Password123',
    gen_salt('bf')
);
--7.4----------CREAR UNA TABLA PARA CREDENCIALES PROTEGIDAS------------------
CREATE TABLE usuarios_segura (
    id BIGSERIAL PRIMARY KEY,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL
);
---------------INSERTAR USUARIO-------------------------------------------

INSERT INTO usuarios_segura (usuario, password_hash)
VALUES (
    'juan',
    crypt('Password123', gen_salt('bf'))
);
------------CONSULTA------------------------------------------------------
SELECT *
FROM usuarios_segura;
--7.5 VERIFICAR UNA CONTRASEÑA---------------------------------------------
SELECT
    usuario,
    password_hash = crypt('Password123', password_hash)
        AS contraseña_correcta
FROM usuarios_segura
WHERE usuario = 'juan';
-----------PROBAR CON UNA CONTRASEÑA INCORRECTA------------------------------

SELECT
    usuario,
    password_hash = crypt('OtraPassword', password_hash)
        AS contraseña_correcta
FROM usuarios_segura
WHERE usuario = 'juan';


