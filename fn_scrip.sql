DROP FUNCTION IF EXISTS func_login;
DROP FUNCTION IF EXISTS func_listar_usuarios;
DROP FUNCTION IF EXISTS func_buscar_usuario_id;
DROP FUNCTION func_buscar_grupo_horario_fechas;
DROP FUNCTION func_buscar_grupo_horario_fechas_admin;

/* ROLES */
CREATE OR REPLACE FUNCTION func_listar_roles()
RETURNS SETOF roles
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT * FROM roles;
    END;
$BODY$;

CREATE OR REPLACE FUNCTION func_buscar_role
(p_id INT
)
RETURNS SETOF roles
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM roles WHERE id=p_id;
END
$BODY$;

CREATE OR REPLACE FUNCTION func_buscar_role_nombre
(p_nombre VARCHAR(100)
)
RETURNS SETOF roles
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM roles WHERE nombre LIKE '%'||p_nombre||'%';
END
$BODY$;

CREATE OR REPLACE PROCEDURE sp_registrar_role
(p_nombre varchar(50),
p_estado varchar(12),
OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM roles WHERE nombre=p_nombre))THEN
 		msge:=  'El rol: '||p_nombre||', ya existe';
	ELSE
		INSERT INTO roles (nombre,estado) VALUES(p_nombre, p_estado);
		msge:=  'Registrado correctamente';
	END IF;
END
$BODY$;

CREATE OR REPLACE PROCEDURE sp_actualizar_role
(p_id INT,
p_nombre varchar(50),
p_estado varchar(12),
OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM roles WHERE nombre=p_nombre AND id<>p_id))THEN
 		msge:=  'El rol: '||p_nombre||', ya existe';
	ELSE
		UPDATE roles SET nombre=p_nombre,estado=p_estado WHERE id=p_id;
		msge:=  'Actualizado correctamente';
	END IF;
END
$BODY$;


/* USUARIO */

CREATE OR REPLACE FUNCTION func_login
(p_usuario VARCHAR(20),
p_clave VARCHAR(100)
)
RETURNS TABLE(
	id integer,
  id_rol integer, 
  nombres VARCHAR(100), 
  usuario VARCHAR(100),
	clave VARCHAR(100), 
  token char(6), 
  email VARCHAR(100), 
  estado VARCHAR(12), 
  role VARCHAR(50))
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT 
			u.*, 
      	r.nombre as role
		FROM usuario u
			INNER JOIN roles r on r.id=u.id_rol
		WHERE u.usuario=p_usuario AND u.clave=p_clave AND u.estado='ACTIVO';
END
$BODY$;

CREATE OR REPLACE FUNCTION func_listar_usuarios()
RETURNS TABLE(
	id integer, 
	id_rol integer, 
	nombres VARCHAR(100), 
	usuario VARCHAR(100),
	clave VARCHAR(100), 
	token char(6), 
	email VARCHAR(100), 
	estado VARCHAR(12), 
	role VARCHAR(50)
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT
				u.*, r.nombre AS role
			FROM usuario u
				INNER JOIN roles r ON r.id=u.id_rol;
    END;
$BODY$;

CREATE OR REPLACE FUNCTION func_buscar_usuario_id
(p_id INT
)
RETURNS TABLE(
	id integer, 
	id_rol integer, 
	nombres VARCHAR(100), 
	usuario VARCHAR(100),
	clave VARCHAR(100), 
	token char(6), 
	email VARCHAR(100), 
	estado VARCHAR(12), 
	role VARCHAR(50)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT
			u.*, r.nombre AS role
		FROM usuario u
			INNER JOIN roles r ON r.id=u.id_rol
		WHERE u.id=p_id;
END
$BODY$;

CREATE OR REPLACE FUNCTION func_buscar_usuario_nombre
(p_nombres VARCHAR(50)
)
RETURNS SETOF usuario
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM usuario WHERE UPPER(nombres) LIKE '%'||UPPER(p_nombres)||'%';
END
$BODY$;

CREATE OR REPLACE FUNCTION func_buscar_usuario_email
(p_email VARCHAR(100)
)
RETURNS SETOF usuario
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM usuario WHERE email=p_email AND estado='ACTIVO' LIMIT 1;
END
$BODY$;

CREATE OR REPLACE FUNCTION func_buscar_usuario_token
(p_token char(6)
)
RETURNS SETOF usuario
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM usuario WHERE token=p_token AND estado='ACTIVO' LIMIT 1;
END
$BODY$;

CREATE OR REPLACE PROCEDURE sp_registrar_usuario
(p_id_rol INT, 
p_nombres VARCHAR(100), 
p_usuario VARCHAR(20), 
p_clave VARCHAR(100),
p_email VARCHAR(100),
p_estado VARCHAR(12),
OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM usuario WHERE usuario=p_usuario))THEN
 		msge:=  'El usuario: '||p_usuario||', ya existe';
	ELSEIF(p_email IS NULL)THEN
		INSERT INTO usuario (id_rol,nombres,usuario,clave,email,estado) VALUES(p_id_rol,p_nombres,p_usuario,p_clave,p_email,p_estado);
		msge:=  'Registrado correctamente';
	ELSEIF(p_email IS NOT NULL)THEN
		IF(EXISTS(SELECT * FROM usuario WHERE email=p_email))THEN
			msge:=  'El email: '||p_email||', ya existe';
		ELSE
			INSERT INTO usuario (id_rol,nombres,usuario,clave,email,estado) VALUES(p_id_rol,p_nombres,p_usuario,p_clave,p_email,p_estado);
			msge:=  'Registrado correctamente';
		END IF;
	END IF;
END
$BODY$;

CREATE OR REPLACE PROCEDURE sp_actualizar_usuario
(p_id INT,
p_id_rol INT, 
p_nombres VARCHAR(100), 
p_usuario VARCHAR(20), 
p_clave VARCHAR(100),
p_email VARCHAR(100),
p_estado VARCHAR(12),
OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM usuario WHERE usuario=p_usuario AND id<>p_id))THEN
 		msge:=  'El usuario: '||p_descripcion||', ya existe';
	ELSE
		UPDATE usuario SET id_rol=p_id_rol,nombres=p_nombres,usuario=p_usuario,clave=p_clave,email=p_email,estado=p_estado WHERE id=p_id;
		msge:=  'Actualizado correctamente';
	END IF;
END
$BODY$;

CREATE OR REPLACE PROCEDURE sp_actualizar_usuario_token
(p_id INT, 
p_token char(6),
OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	IF(p_token = '')THEN
		p_token := NULL;
	END IF;
 	IF(NOT EXISTS(SELECT * FROM usuario WHERE id=p_id))THEN
 		msge:=  'El usuario no existe';
	ELSE
		UPDATE usuario SET token=p_token WHERE id=p_id;
		msge:=  'Actualizado correctamente';
	END IF;
END
$BODY$;

CREATE OR REPLACE PROCEDURE sp_actualizar_usuario_clave
(p_id INT, 
p_clave VARCHAR(100),
OUT msge VARCHAR(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(NOT EXISTS(SELECT * FROM usuario WHERE id=p_id))THEN
 		msge:=  'El usuario no existe';
	ELSE
		UPDATE usuario SET clave=p_clave,token=NULL WHERE id=p_id;
		msge:=  'Actualizado correctamente';
	END IF;
END
$BODY$;


/* ALUMNO */

CREATE OR REPLACE FUNCTION func_listar_alumno()
RETURNS SETOF alumno
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT * FROM alumno WHERE estado != 'ELIMINADO';
    END;
$BODY$;

CREATE OR REPLACE FUNCTION func_listar_alumno_admin()
RETURNS SETOF alumno
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT * FROM alumno;
    END;
$BODY$;



CREATE OR REPLACE FUNCTION func_buscar_alumno
(p_id INT
)
RETURNS SETOF alumno
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM alumno WHERE id=p_id AND estado != 'ELIMINADO';
END
$BODY$;




CREATE OR REPLACE FUNCTION func_buscar_alumno_admin
(p_id INT
)
RETURNS SETOF alumno
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM alumno WHERE id=p_id;
END
$BODY$;



CREATE OR REPLACE FUNCTION func_buscar_alumno_nombre
(p_nombres VARCHAR(100)
)
RETURNS SETOF alumno
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM alumno WHERE UPPER(nombres) LIKE '%'||UPPER(p_nombres)||'%' AND estado != 'ELIMINADO';
END
$BODY$;


CREATE OR REPLACE FUNCTION func_buscar_alumno_nombre_admin 
(p_nombres VARCHAR(100)
)
RETURNS SETOF alumno
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM alumno WHERE UPPER(nombres) LIKE '%'||UPPER(p_nombres)||'%';
END
$BODY$;


CREATE OR REPLACE PROCEDURE sp_registrar_alumno
(
p_dni char(8),
p_nombres varchar,
p_sexo char(1),
p_estado varchar,
p_direccion varchar,
p_email varchar,
p_telefono char(9),
OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM alumno WHERE nombres=p_nombres))THEN
 		msge:=  'La alumno: '||p_nombres||', ya existe';
	ELSE
		INSERT INTO alumno (dni, nombres, sexo, estado, direccion, email, telefono) VALUES(p_dni, p_nombres, p_sexo, p_estado, p_direccion, p_email, p_telefono);
		msge:=  'Registrado correctamente';
	END IF;
END
$BODY$;

CREATE OR REPLACE PROCEDURE sp_actualizar_alumno
(
p_id INT,
p_dni char(8),
p_nombres varchar,
p_sexo char(1),
p_estado varchar,
p_direccion varchar,
p_email varchar,
p_telefono char(9),
OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM alumno WHERE nombres=p_nombres AND id<>p_id))THEN
 		msge:=  'El alumno: '||p_descripcion||', ya existe';
	ELSE
		UPDATE alumno SET dni = p_dni, nombres = p_nombres, sexo=p_sexo, estado=p_estado, direccion=p_direccion, email=p_email, telefono = p_telefono WHERE id=p_id;
		msge:=  'Actualizado correctamente';
	END IF;
END
$BODY$;


/* AMBIENTE */

CREATE OR REPLACE FUNCTION func_listar_ambiente()
RETURNS SETOF ambiente
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT * FROM ambiente WHERE estado != 'ELIMINADO';
    END;
$BODY$;

CREATE OR REPLACE FUNCTION func_listar_ambiente_admin()
RETURNS SETOF ambiente
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT * FROM ambiente;
    END;
$BODY$;



CREATE OR REPLACE FUNCTION func_buscar_ambiente
(p_id INT
)
RETURNS SETOF ambiente
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM ambiente WHERE id = p_id AND estado != 'ELIMINADO';
END
$BODY$;




CREATE OR REPLACE FUNCTION func_buscar_ambiente_admin
(p_id INT
)
RETURNS SETOF ambiente
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM ambiente WHERE id = p_id;
END
$BODY$;



CREATE OR REPLACE FUNCTION func_buscar_ambiente_nombre
(p_nombre VARCHAR(100)
)
RETURNS SETOF ambiente
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM ambiente WHERE UPPER(nombre) LIKE '%'||UPPER(p_nombre)||'%' AND estado != 'ELIMINADO';
END
$BODY$;


CREATE OR REPLACE FUNCTION func_buscar_ambiente_nombre_admin 
(p_nombre VARCHAR(100)
)
RETURNS SETOF ambiente
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM ambiente WHERE UPPER(nombre) LIKE '%'||UPPER(p_nombre)||'%';
END
$BODY$;


CREATE OR REPLACE PROCEDURE sp_registrar_ambiente
(
p_nombre varchar,
p_descripcion varchar,
p_capacidad int,
p_estado varchar,
OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM ambiente WHERE nombre=p_nombre))THEN
 		msge:=  'El ambiente: '||p_nombre||', ya existe';
	ELSE
		INSERT INTO ambiente (nombre, descripcion, capacidad, estado) VALUES(p_nombre, p_descripcion, p_capacidad, p_estado);
		msge:=  'Registrado correctamente';
	END IF;
END
$BODY$;

CREATE OR REPLACE PROCEDURE sp_actualizar_ambiente
(
p_id INT,
p_nombre varchar,
p_descripcion varchar,
p_capacidad int,
p_estado varchar,
OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM ambiente WHERE nombre=p_nombre AND id<>p_id))THEN
 		msge:=  'El ambiente: '||nombre||', ya existe';
	ELSE
		UPDATE ambiente SET nombre = p_nombre, descripcion = p_descripcion, capacidad = p_capacidad, estado = p_estado WHERE id = p_id;
		msge:=  'Actualizado correctamente';
	END IF;
END
$BODY$;



/* DEPORTE */


CREATE OR REPLACE FUNCTION func_listar_deporte()
RETURNS SETOF deporte
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT * FROM deporte WHERE estado != 'ELIMINADO';
    END;
$BODY$;

CREATE OR REPLACE FUNCTION func_listar_deporte_admin()
RETURNS SETOF deporte
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT * FROM deporte;
    END;
$BODY$;



CREATE OR REPLACE FUNCTION func_buscar_deporte
(p_id INT
)
RETURNS SETOF deporte
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM deporte WHERE id = p_id AND estado != 'ELIMINADO';
END
$BODY$;




CREATE OR REPLACE FUNCTION func_buscar_deporte_admin
(p_id INT
)
RETURNS SETOF deporte
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM deporte WHERE id = p_id;
END
$BODY$;



CREATE OR REPLACE FUNCTION func_buscar_deporte_nombre
(p_nombre VARCHAR(100)
)
RETURNS SETOF deporte
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM deporte WHERE UPPER(nombre) LIKE '%'||UPPER(p_nombre)||'%' AND estado != 'ELIMINADO';
END
$BODY$;


CREATE OR REPLACE FUNCTION func_buscar_deporte_nombre_admin 
(p_nombre VARCHAR(100)
)
RETURNS SETOF deporte
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM deporte WHERE UPPER(nombre) LIKE '%'||UPPER(p_nombre)||'%';
END
$BODY$;


CREATE OR REPLACE PROCEDURE sp_registrar_deporte
(
p_nombre varchar,
p_descripcion varchar,
p_estado varchar,
OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM deporte WHERE nombre=p_nombre))THEN
 		msge:=  'El deporte: '||p_nombre||', ya existe';
	ELSE
		INSERT INTO deporte (nombre, descripcion, estado) VALUES(p_nombre, p_descripcion, p_estado);
		msge:=  'Registrado correctamente';
	END IF;
END
$BODY$;

CREATE OR REPLACE PROCEDURE sp_actualizar_deporte
(
p_id INT,
p_nombre varchar,
p_descripcion varchar,
p_estado varchar,
OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM deporte WHERE nombre=p_nombre AND id<>p_id))THEN
 		msge:=  'El deporte: '||nombre||', ya existe';
	ELSE
		UPDATE deporte SET nombre = p_nombre, descripcion = p_descripcion, estado = p_estado WHERE id = p_id;
		msge:=  'Actualizado correctamente';
	END IF;
END
$BODY$;



/* DOCENTE */

CREATE OR REPLACE FUNCTION func_listar_docente()
RETURNS SETOF docente
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT * FROM docente WHERE estado != 'ELIMINADO';
    END;
$BODY$;

CREATE OR REPLACE FUNCTION func_listar_docente_admin()
RETURNS SETOF docente
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT * FROM docente;
    END;
$BODY$;



CREATE OR REPLACE FUNCTION func_buscar_docente
(p_id INT
)
RETURNS SETOF docente
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM docente WHERE id = p_id AND estado != 'ELIMINADO';
END
$BODY$;




CREATE OR REPLACE FUNCTION func_buscar_docente_admin
(p_id INT
)
RETURNS SETOF docente
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM docente WHERE id = p_id;
END
$BODY$;



CREATE OR REPLACE FUNCTION func_buscar_docente_nombres
(p_nombres VARCHAR(100)
)
RETURNS SETOF docente
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM docente WHERE UPPER(nombres) LIKE '%'||UPPER(p_nombres)||'%' AND estado != 'ELIMINADO';
END
$BODY$;


CREATE OR REPLACE FUNCTION func_buscar_docente_nombres_admin 
(p_nombres VARCHAR(100)
)
RETURNS SETOF docente
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM docente WHERE UPPER(nombres) LIKE '%'||UPPER(p_nombres)||'%';
END
$BODY$;


CREATE OR REPLACE PROCEDURE sp_registrar_docente
(
p_dni char(8),
p_nombres varchar,
p_sexo char(1),
p_estado varchar,
p_direccion varchar,
p_email varchar,
p_telefono char(9),
OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM docente WHERE nombres=p_nombres))THEN
 		msge:=  'El docente: '||p_nombres||', ya existe';
	ELSE
		INSERT INTO docente (dni, nombres, sexo, estado, direccion, email, telefono) VALUES(p_dni, p_nombres, p_sexo, p_estado, p_direccion, p_email, p_telefono);
		msge:=  'Registrado correctamente';
	END IF;
END
$BODY$;

CREATE OR REPLACE PROCEDURE sp_actualizar_docente
(
p_id INT,
p_dni char(8),
p_nombres varchar,
p_sexo char(1),
p_estado varchar,
p_direccion varchar,
p_email varchar,
p_telefono char(9),
OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM docente WHERE nombres=p_nombres AND id<>p_id))THEN
 		msge:=  'El docente: '||p_nombres||', ya existe';
	ELSE
		UPDATE docente SET nombres = p_nombres, sexo = p_sexo, estado = p_estado, direccion = p_direccion, email = p_email, telefono = p_telefono WHERE id = p_id;
		msge:=  'Actualizado correctamente';
	END IF;
END
$BODY$;




/* GRUPO_HORARIO */

CREATE OR REPLACE FUNCTION func_listar_grupo_horario()
RETURNS table(
  id		  int, 
  nombre      varchar(255), 
  id_deporte  int, 
  id_docente  int, 
  f_inicio    date, 
  f_fin       date,
  hora_inicio int,
  hora_fin    int, 
  estado      varchar(12), 
  id_ambiente int,
  costo numeric(8, 2),
  deporte varchar,
  docente varchar,
  ambiente varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT gh.*,
			dep.nombre as deporte,
			d.nombres as docente,
			a.nombre as ambiente
			FROM grupo_horario gh 
			INNER JOIN deporte dep on gh.id_deporte = dep.id
			INNER JOIN docente d on gh.id_docente = d.id
			INNER JOIN ambiente a on gh.id_ambiente = a.id
			WHERE gh.estado != 'ELIMINADO';
    END;
$BODY$;

CREATE OR REPLACE FUNCTION func_listar_grupo_horario_admin()
RETURNS table(
  id		  int, 
  nombre      varchar(255), 
  id_deporte  int, 
  id_docente  int, 
  f_inicio    date, 
  f_fin       date,
  hora_inicio int,
  hora_fin    int, 
  estado      varchar(12), 
  id_ambiente int,
	costo numeric(8, 2),
  deporte varchar,
  docente varchar,
  ambiente varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT gh.*,
			dep.nombre as deporte,
			d.nombres as docente,
			a.nombre as ambiente
			FROM grupo_horario gh 
			INNER JOIN deporte dep on gh.id_deporte = dep.id
			INNER JOIN docente d on gh.id_docente = d.id
			INNER JOIN ambiente a on gh.id_ambiente = a.id;
    END;
$BODY$;


CREATE OR REPLACE FUNCTION func_buscar_grupo_horario
(p_id INT
)
RETURNS table(
  id		  int, 
  nombre      varchar(255), 
  id_deporte  int, 
  id_docente  int, 
  f_inicio    date, 
  f_fin       date,
  hora_inicio int,
  hora_fin    int, 
  estado      varchar(12), 
  id_ambiente int,
  costo numeric(8, 2),
  deporte varchar,
  docente varchar,
  ambiente varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT gh.*,
			dep.nombre as deporte,
			d.nombres as docente,
			a.nombre as ambiente
			FROM grupo_horario gh 
			INNER JOIN deporte dep on gh.id_deporte = dep.id
			INNER JOIN docente d on gh.id_docente = d.id
			INNER JOIN ambiente a on gh.id_ambiente = a.id
			WHERE gh.id = p_id AND gh.estado != 'ELIMINADO';
END
$BODY$;




CREATE OR REPLACE FUNCTION func_buscar_grupo_horario_admin
(p_id INT
)
RETURNS table(
  id		  int, 
  nombre      varchar(255), 
  id_deporte  int, 
  id_docente  int, 
  f_inicio    date, 
  f_fin       date,
  hora_inicio int,
  hora_fin    int, 
  estado      varchar(12), 
  id_ambiente int,
  costo numeric(8, 2),
  deporte varchar,
  docente varchar,
  ambiente varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT gh.*,
			dep.nombre as deporte,
			d.nombres as docente,
			a.nombre as ambiente
			FROM grupo_horario gh 
			INNER JOIN deporte dep on gh.id_deporte = dep.id
			INNER JOIN docente d on gh.id_docente = d.id
			INNER JOIN ambiente a on gh.id_ambiente = a.id
			WHERE gh.id = p_id;
END
$BODY$;


CREATE OR REPLACE FUNCTION func_buscar_grupo_horario_nombres
(p_nombre VARCHAR(100)
)
RETURNS table(
  id		  int, 
  nombre      varchar(255), 
  id_deporte  int, 
  id_docente  int, 
  f_inicio    date, 
  f_fin       date,
  hora_inicio int,
  hora_fin    int, 
  estado      varchar(12),
  id_ambiente int,
  costo numeric(8, 2),
  deporte varchar,
  docente varchar,
  ambiente varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT gh.*,
			dep.nombre as deporte,
			d.nombres as docente,
			a.nombre as ambiente
			FROM grupo_horario gh 
			INNER JOIN deporte dep on gh.id_deporte = dep.id
			INNER JOIN docente d on gh.id_docente = d.id
			INNER JOIN ambiente a on gh.id_ambiente = a.id
			WHERE UPPER(gh.nombre) LIKE '%'||UPPER(p_nombre)||'%' AND gh.estado != 'ELIMINADO';
END
$BODY$;



CREATE OR REPLACE FUNCTION func_buscar_grupo_horario_nombres_admin 
(p_nombre VARCHAR(100)
)
RETURNS table(
  id		  int, 
  nombre      varchar(255), 
  id_deporte  int, 
  id_docente  int, 
  f_inicio    date, 
  f_fin       date,
  hora_inicio int,
  hora_fin    int, 
  estado      varchar(12), 
  id_ambiente int,
	costo numeric(8, 2),
  deporte varchar,
  docente varchar,
  ambiente varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT gh.*,
			dep.nombre as deporte,
			d.nombres as docente,
			a.nombre as ambiente
			FROM grupo_horario gh 
			INNER JOIN deporte dep on gh.id_deporte = dep.id
			INNER JOIN docente d on gh.id_docente = d.id
			INNER JOIN ambiente a on gh.id_ambiente = a.id
			WHERE UPPER(gh.nombre) LIKE '%'||UPPER(p_nombre)||'%';
END
$BODY$;

------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION func_buscar_grupo_horario_fechas
(
	p_fecha1 date,
	p_fecha2 date
)
RETURNS table(
  id		  int, 
  nombre      varchar(255), 
  id_deporte  int, 
  id_docente  int, 
  f_inicio    date, 
  f_fin       date,
  hora_inicio int,
  hora_fin    int, 
  estado      varchar(12), 
  id_ambiente int, 
	costo numeric(8,2),
  deporte varchar,
  docente varchar,
  ambiente varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT gh.*,
			dep.nombre as deporte,
			d.nombres as docente,
			a.nombre as ambiente
			FROM grupo_horario gh 
			INNER JOIN deporte dep on gh.id_deporte = dep.id
			INNER JOIN docente d on gh.id_docente = d.id
			INNER JOIN ambiente a on gh.id_ambiente = a.id
			WHERE (f_inicio>p_fecha1 AND f_fin <p_fecha2) AND gh.estado != 'ELIMINADO';
END
$BODY$;

CREATE OR REPLACE FUNCTION func_buscar_grupo_horario_fechas_admin
(
	p_fecha1 date,
	p_fecha2 date
)
RETURNS table(
  id		  int, 
  nombre      varchar(255), 
  id_deporte  int, 
  id_docente  int, 
  f_inicio    date, 
  f_fin       date,
  hora_inicio int,
  hora_fin    int, 
  estado      varchar(12), 
  id_ambiente int, 
	costo numeric(8,2),
  deporte varchar,
  docente varchar,
  ambiente varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT gh.*,
			dep.nombre as deporte,
			d.nombres as docente,
			a.nombre as ambiente
			FROM grupo_horario gh 
			INNER JOIN deporte dep on gh.id_deporte = dep.id
			INNER JOIN docente d on gh.id_docente = d.id
			INNER JOIN ambiente a on gh.id_ambiente = a.id
			WHERE (f_inicio>p_fecha1 AND f_fin <p_fecha2);
END
$BODY$;


CREATE OR REPLACE PROCEDURE sp_registrar_grupo_horario
(
  p_nombre      varchar(255), 
  p_id_deporte  int, 
  p_id_docente  int, 
  p_f_inicio    date, 
  p_f_fin       date,
  p_hora_inicio int,
  p_hora_fin    int, 
  p_estado      varchar(12), 
  p_id_ambiente int,
  p_costo       numeric(8,2),
  OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM grupo_horario WHERE nombre = p_nombre))THEN
 		msge:=  'El grupo_horario: '||p_nombre||', ya existe';
	ELSE
		INSERT INTO grupo_horario(nombre, id_deporte, id_docente, f_inicio, f_fin, hora_inicio, hora_fin, estado, id_ambiente, costo) 
		VALUES(p_nombre, p_id_deporte, p_id_docente, p_f_inicio, p_f_fin, p_hora_inicio, p_hora_fin, p_estado, p_id_ambiente, p_costo);
		msge:=  'Registrado correctamente';
	END IF;
END
$BODY$;

CREATE OR REPLACE PROCEDURE sp_actualizar_grupo_horario
(
  p_id		    int, 
  p_nombre      varchar(255), 
  p_id_deporte  int, 
  p_id_docente  int, 
  p_f_inicio    date, 
  p_f_fin       date,
  p_hora_inicio int,
  p_hora_fin    int, 
  p_estado      varchar(12), 
  p_id_ambiente int,
  p_costo       numeric(8,2),
  OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM grupo_horario WHERE nombre=p_nombre AND id<>p_id))THEN
 		msge:=  'El grupo_horario: '||p_nombre||', ya existe';
	ELSE
		UPDATE grupo_horario SET nombre = p_nombre, id_deporte = p_id_deporte, id_docente = p_id_docente, f_inicio = p_f_inicio, 
		f_fin = p_f_fin, hora_inicio = p_hora_inicio, hora_fin = p_hora_fin, estado = p_estado, id_ambiente = p_id_ambiente, costo=p_costo WHERE id = p_id;
		msge:=  'Actualizado correctamente';
	END IF;
END
$BODY$;


/* MATRICULA */

CREATE OR REPLACE FUNCTION func_listar_matricula()
RETURNS table(
  id int, 
  id_gh int,
  id_alumno int,
  estado varchar(12),
  f_matricula date,
  grupo_horario varchar,
  alumno varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT
      m.*,
      gh.nombre as grupo_horario,
      al.nombres as alumno
      FROM matricula m
      INNER JOIN alumno al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE m.estado != 'ELIMINADO';
    END;
$BODY$;


CREATE OR REPLACE FUNCTION func_listar_matricula_admin()
RETURNS table(
  id int, 
  id_gh int,
  id_alumno int,
  estado varchar(12),
  f_matricula date,
  grupo_horario varchar,
  alumno varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT
      m.*,
      gh.nombre as grupo_horario,
      al.nombres as alumno
      FROM matricula m
      INNER JOIN alumno al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id;
    END;
$BODY$;



CREATE OR REPLACE FUNCTION func_buscar_matricula
(
  p_id int
)
RETURNS table(
  id int, 
  id_gh int,
  id_alumno int,
  estado varchar(12),
  f_matricula date,
  grupo_horario varchar,
  alumno varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT
      m.*,
      gh.nombre as grupo_horario,
      al.nombres as alumno
      FROM matricula m
      INNER JOIN alumno al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE m.id = p_id AND m.estado != 'ELIMINADO';
END
$BODY$;



CREATE OR REPLACE FUNCTION func_buscar_matricula_admin
(
  p_id int
)
RETURNS table(
  id int, 
  id_gh int,
  id_alumno int,
  estado varchar(12),
  f_matricula date,
  grupo_horario varchar,
  alumno varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT
      m.*,
      gh.nombre as grupo_horario,
      al.nombres as alumno
      FROM matricula m
      INNER JOIN alumno al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE m.id = p_id;
END
$BODY$;



CREATE OR REPLACE FUNCTION func_buscar_matricula_alumno
(
  p_alumno VARCHAR(100)
)
RETURNS table(
  id int, 
  id_gh int,
  id_alumno int,
  estado varchar(12),
  f_matricula date,
  grupo_horario varchar,
  alumno varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT
      m.*,
      gh.nombre as grupo_horario,
      al.nombres as alumno
      FROM matricula m
      INNER JOIN alumno al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE al.nombres LIKE '%'||p_alumno||'%' AND m.estado != 'ELIMINADO';
END
$BODY$;


CREATE OR REPLACE FUNCTION func_buscar_matricula_alumno_admin 
(
  p_alumno VARCHAR(100)
)
RETURNS table(
  id int, 
  id_gh int,
  id_alumno int,
  estado varchar(12),
  f_matricula date,
  grupo_horario varchar,
  alumno varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT
      m.*,
      gh.nombre as grupo_horario,
      al.nombres as alumno
      FROM matricula m
      INNER JOIN alumno al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE al.nombres LIKE '%'||p_alumno||'%';
END
$BODY$;
------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION func_buscar_matricula_docente
(
  p_docente VARCHAR(100)
)
RETURNS table(
  id int, 
  id_gh int,
  id_alumno int,
  estado varchar(12),
  f_matricula date,
  grupo_horario varchar,
  alumno varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT
      m.*,
      gh.nombre as grupo_horario,
      al.nombres as alumno
      FROM matricula m
      INNER JOIN alumno al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
      INNER JOIN docente doc on gh.id_docente = doc.id
			WHERE doc.nombres LIKE '%'||p_docente||'%' AND m.estado != 'ELIMINADO';
END
$BODY$;


CREATE OR REPLACE FUNCTION func_buscar_matricula_docente_admin 
(
  p_docente VARCHAR(100)
)
RETURNS table(
  id int, 
  id_gh int,
  id_alumno int,
  estado varchar(12),
  f_matricula date,
  grupo_horario varchar,
  alumno varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT
      m.*,
      gh.nombre as grupo_horario,
      al.nombres as alumno
      FROM matricula m
      INNER JOIN alumno al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
      INNER JOIN docente doc on gh.id_docente = doc.id
			WHERE doc.nombres LIKE '%'||p_docente||'%';
END
$BODY$;
------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION func_buscar_matricula_fechas
(
	p_fecha1 date,
	p_fecha2 date
)
RETURNS table(
  id int, 
  id_gh int,
  id_alumno int,
  estado varchar(12),
  f_matricula date,
  grupo_horario varchar,
  alumno varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT
      m.*,
      gh.nombre as grupo_horario,
      al.nombres as alumno
      FROM matricula m
      INNER JOIN alumno al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE (m.f_matricula >= p_fecha1 AND m.f_matricula <= p_fecha2) AND m.estado != 'ELIMINADO';
END
$BODY$;


CREATE OR REPLACE FUNCTION func_buscar_matricula_fechas_admin
(
	p_fecha1 date,
	p_fecha2 date
)
RETURNS table(
  id int, 
  id_gh int,
  id_alumno int,
  estado varchar(12),
  f_matricula date,
  grupo_horario varchar,
  alumno varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT
      m.*,
      gh.nombre as grupo_horario,
      al.nombres as alumno
      FROM matricula m
      INNER JOIN alumno al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE (m.f_matricula >= p_fecha1 AND m.f_matricula <= p_fecha2);
END
$BODY$;


CREATE OR REPLACE PROCEDURE sp_registrar_matricula( 
  p_id_gh int,
  p_id_alumno int,
  p_estado varchar(12),
  p_f_matricula date,
  OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
		INSERT INTO matricula(id_gh, id_alumno, estado, f_matricula) VALUES
    (p_id_gh, p_id_alumno, p_estado, p_f_matricula);
		msge:=  'Registrado correctamente';
END
$BODY$;


CREATE OR REPLACE PROCEDURE sp_actualizar_matricula(
  p_id int,
  p_id_gh int,
  p_id_alumno int,
  p_estado varchar(12),
  p_f_matricula date,
  OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
		UPDATE matricula SET id_gh = p_id_gh, estado = p_estado, f_matricula = p_f_matricula WHERE id = p_id AND id_gh = p_id_gh AND id_alumno = p_id_alumno;
		msge:=  'Actualizado correctamente';
END
$BODY$;


/* PAGO */

CREATE OR REPLACE FUNCTION func_listar_pago()
RETURNS table(
  id int, 
  total numeric(8, 2),
  numCuotas int,
  estado varchar,
  MATRICULAid int,
  alumno varchar,
  grupo_horario varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT
      p.*,
      al.nombres as alumno,
      gh.nombre as grupo_horario
      FROM pago p
      INNER JOIN matricula m on p.MATRICULAid = m.id
      INNER JOIN ALUMNO al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE p.estado != 'ELIMINADO';
    END;
$BODY$;


CREATE OR REPLACE FUNCTION func_listar_pago_admin()
RETURNS table(
  id int, 
  total numeric(8, 2),
  numCuotas int,
  estado varchar,
  MATRICULAid int,
  alumno varchar,
  grupo_horario varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT
      p.*,
      al.nombres as alumno,
      gh.nombre as grupo_horario
      FROM pago p
      INNER JOIN matricula m on p.MATRICULAid = m.id
      INNER JOIN ALUMNO al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id;
    END;
$BODY$;



CREATE OR REPLACE FUNCTION func_buscar_pago
(
  p_id int
)
RETURNS table(
  id int, 
  total numeric(8, 2),
  numCuotas int,
  estado varchar,
  MATRICULAid int,
  alumno varchar,
  grupo_horario varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT
      p.*,
      al.nombres as alumno,
      gh.nombre as grupo_horario
      FROM pago p
      INNER JOIN matricula m on p.MATRICULAid = m.id
      INNER JOIN ALUMNO al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE m.id = p_id AND m.estado != 'ELIMINADO';
END
$BODY$;



CREATE OR REPLACE FUNCTION func_buscar_pago_admin
(
  p_id int
)
RETURNS table(
  id int, 
  total numeric(8, 2),
  numCuotas int,
  estado varchar,
  MATRICULAid int,
  alumno varchar,
  grupo_horario varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT
      p.*,
      al.nombres as alumno,
      gh.nombre as grupo_horario
      FROM pago p
      INNER JOIN matricula m on p.MATRICULAid = m.id
      INNER JOIN ALUMNO al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE m.id = p_id;
END
$BODY$;



CREATE OR REPLACE FUNCTION func_buscar_pago_alumno
(
  p_alumno VARCHAR(100)
)
RETURNS table(
  id int, 
  total numeric(8, 2),
  numCuotas int,
  estado varchar,
  MATRICULAid int,
  alumno varchar,
  grupo_horario varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT
      p.*,
      al.nombres as alumno,
      gh.nombre as grupo_horario
      FROM pago p
      INNER JOIN matricula m on p.MATRICULAid = m.id
      INNER JOIN ALUMNO al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE al.nombres LIKE '%'||p_alumno||'%' AND m.estado != 'ELIMINADO';
END
$BODY$;


CREATE OR REPLACE FUNCTION func_buscar_pago_alumno_admin 
(
  p_alumno VARCHAR(100)
)
RETURNS table(
  id int, 
  total numeric(8, 2),
  numCuotas int,
  estado varchar,
  MATRICULAid int,
  alumno varchar,
  grupo_horario varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT
      p.*,
      al.nombres as alumno,
      gh.nombre as grupo_horario
      FROM pago p
      INNER JOIN matricula m on p.MATRICULAid = m.id
      INNER JOIN ALUMNO al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE al.nombres LIKE '%'||p_alumno||'%';
END
$BODY$;


CREATE OR REPLACE PROCEDURE sp_registrar_pago( 
  p_total numeric (8, 2),
  p_numCuotas int,
  p_estado varchar,
  p_MATRICULAid int,
  OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
		INSERT INTO pago(total, numCuotas, estado, MATRICULAid) VALUES
    (p_total, p_numCuotas, p_estado, p_MATRICULAid);
		msge:=  'Registrado correctamente';
END
$BODY$;


CREATE OR REPLACE PROCEDURE sp_actualizar_pago(
  p_id int,
  p_total numeric (8, 2),
  p_numCuotas int,
  p_estado varchar,
  p_MATRICULAid int,
  OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
		UPDATE pago SET total = p_total, numCuotas = p_numCuotas, estado = p_estado, MATRICULAid = p_MATRICULAid WHERE id = p_id;
		msge:=  'Actualizado correctamente';
END
$BODY$;

/* CUOTA */

CREATE OR REPLACE FUNCTION func_listar_cuota()
RETURNS SETOF cuota
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT * FROM cuota
			WHERE estado != 'ELIMINADO';
    END;
$BODY$;


CREATE OR REPLACE FUNCTION func_buscar_cuota
(
  p_id int
)
RETURNS SETOF cuota
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT * FROM cuota
			WHERE id = p_id AND estado != 'ELIMINADO';
    END;
$BODY$;


CREATE OR REPLACE FUNCTION func_buscar_cuota_pago
(
  p_id_pago int
)
RETURNS SETOF cuota
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT * FROM cuota
			WHERE id_pago = p_id_pago AND estado != 'ELIMINADO';
    END;
$BODY$;

CREATE OR REPLACE PROCEDURE sp_registrar_cuota( 
  p_monto numeric(8, 2),
  p_fecha_v date,
  p_fecha_p date,
  p_estado varchar(12),
  p_id_pago int,
  OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    insert into cuota(monto, fecha_v, fecha_p, estado, id_pago) VALUES
    (p_monto, p_fecha_v, p_fecha_p, p_estado, p_id_pago);
		msge:=  'Registrado correctamente';
END
$BODY$;


CREATE OR REPLACE PROCEDURE sp_actualizar_cuota(
  p_id int,
  p_monto numeric(8, 2),
  p_fecha_v date,
  p_fecha_p date,
  p_estado varchar(12),
  p_id_pago int,
  OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
		UPDATE cuota SET monto = p_monto, fecha_v = p_fecha_v, fecha_p = p_fecha_p, estado = p_estado, id_pago = p_id_pago WHERE id = p_id;
		msge:=  'Actualizado correctamente';
END
$BODY$;

--