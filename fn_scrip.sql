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
		SELECT * FROM alumno WHERE nombres LIKE '%'||p_nombres||'%' AND estado != 'ELIMINADO';
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
		SELECT * FROM alumno WHERE nombres LIKE '%'||p_nombres||'%';
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
		SELECT * FROM ambiente WHERE nombre LIKE '%'||p_nombre||'%' AND estado != 'ELIMINADO';
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
		SELECT * FROM ambiente WHERE nombre LIKE '%'||p_nombre||'%';
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
		SELECT * FROM deporte WHERE nombre LIKE '%'||p_nombre||'%' AND estado != 'ELIMINADO';
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
		SELECT * FROM deporte WHERE nombre LIKE '%'||p_nombre||'%';
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
		SELECT * FROM docente WHERE nombres LIKE '%'||p_nombres||'%' AND estado != 'ELIMINADO';
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
		SELECT * FROM docente WHERE nombres LIKE '%'||p_nombres||'%';
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
			WHERE nombre LIKE '%'||p_nombre||'%' AND gh.estado != 'ELIMINADO';
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
			WHERE nombre LIKE '%'||p_nombre||'%';
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
  OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM grupo_horario WHERE nombre = p_nombre))THEN
 		msge:=  'El grupo_horario: '||p_nombre||', ya existe';
	ELSE
		INSERT INTO grupo_horario(nombre, id_deporte, id_docente, f_inicio, f_fin, hora_inicio, hora_fin, estado, id_ambiente) 
		VALUES(p_nombre, p_id_deporte, p_id_docente, p_f_inicio, p_f_fin, p_hora_inicio, p_hora_fin, p_estado, p_id_ambiente);
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
  OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM grupo_horario WHERE nombre=p_nombre AND id<>p_id))THEN
 		msge:=  'El grupo_horario: '||p_nombre||', ya existe';
	ELSE
		UPDATE grupo_horario SET nombre = p_nombre, id_deporte = p_id_deporte, id_docente = p_id_docente, f_inicio = p_f_inicio, 
		f_fin = p_f_fin, hora_inicio = p_hora_inicio, hora_fin = p_hora_fin, estado = p_estado, id_ambiente = p_id_ambiente WHERE id = p_id;
		msge:=  'Actualizado correctamente';
	END IF;
END
$BODY$;



