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

CREATE OR REPLACE PROCEDURE grupo_lleno(
 	p_id_gh int,
	OUT i int
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	IF ((select count(id_gh) from matricula) > (select a.capacidad from grupo_horario gh inner join ambiente a on gh.id_ambiente = a.id WHERE gh.id = p_id_gh)) THEN
	i = 1;
	ELSE
	i = -1;
	END IF;
END
$BODY$;
