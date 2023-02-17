--ROLES
--USUARIOS
--DEPORTES


CREATE OR REPLACE FUNCTION fn_listar_grupos()
RETURNS table (
    id_gh int ,
    id_deporte int,
    deporte varchar,
    id_docente int ,
    docente varchar,
    id_ambiente int,
    ambiente varchar,
    hora_inicio int,
    hora_fin int,
    estado varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
RETURN QUERY

SELECT
gh.id_gh,
gh.id_deporte,
deporte.nombre as deporte,
gh.id_docente,
docente.nombres as docente,
gh.id_ambiente,
ambiente.nombre as ambiente,
gh.hora_inicio,
gh.hora_fin,
gh.estado
FROM grupo_horario gh  
LEFT OUTER JOIN deporte on deporte.id_deporte = gh.id_deporte
LEFT OUTER JOIN docente on docente.id_docente = gh.id_docente
LEFT OUTER JOIN ambiente on ambiente.id_ambiente = gh.id_ambiente
where gh.estado = 'ACTIVO';
END;
$BODY$;



CREATE OR REPLACE FUNCTION fn_buscar_grupo_id(p_id int)
RETURNS table (
    id_gh int ,
    id_deporte int,
    deporte varchar,
    id_docente int ,
    docente varchar,
    id_ambiente int,
    ambiente varchar,
    hora_inicio int,
    hora_fin int,
    estado varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
RETURN QUERY

SELECT
gh.id_gh,
gh.id_deporte,
deporte.nombre as deporte,
gh.id_docente,
docente.nombres as docente,
gh.id_ambiente,
ambiente.nombre as ambiente,
gh.hora_inicio,
gh.hora_fin,
gh.estado
FROM grupo_horario gh  
LEFT OUTER JOIN deporte on deporte.id_deporte = gh.id_deporte
LEFT OUTER JOIN docente on docente.id_docente = gh.id_docente
LEFT OUTER JOIN ambiente on ambiente.id_ambiente = gh.id_ambiente
where gh.estado = 'ACTIVO' AND gh.id_gh = p_id;
END;
$BODY$;


CREATE OR REPLACE FUNCTION fn_buscar_grupo_nombre(p_nombre varchar)
RETURNS table (
    id_gh int ,
    id_deporte int,
    deporte varchar,
    id_docente int ,
    docente varchar,
    id_ambiente int,
    ambiente varchar,
    hora_inicio int,
    hora_fin int,
    estado varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
RETURN QUERY

SELECT
gh.id_gh,
gh.id_deporte,
deporte.nombre as deporte,
gh.id_docente,
docente.nombres as docente,
gh.id_ambiente,
ambiente.nombre as ambiente,
gh.hora_inicio,
gh.hora_fin,
gh.estado
FROM grupo_horario gh  
LEFT OUTER JOIN deporte on deporte.id_deporte = gh.id_deporte
LEFT OUTER JOIN docente on docente.id_docente = gh.id_docente
LEFT OUTER JOIN ambiente on ambiente.id_ambiente = gh.id_ambiente
where gh.estado = 'ACTIVO'
AND gh.nombre LIKE '%'||p_nombre||'%'order by gh.nombre asc;
END;
$BODY$;
--------------------------
select * from fn_buscar_grupo_nombre('Angel');
--------------------------

CREATE OR REPLACE FUNCTION fn_listar_deportes()
RETURNS SETOF deporte
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
RETURN QUERY
SELECT * FROM deporte WHERE estado = 'ACTIVO' order by id_deporte asc;
END;
$BODY$;

CREATE OR REPLACE FUNCTION fn_buscar_deporte_id(p_id INT)
RETURNS SETOF deporte
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
RETURN QUERY
SELECT * FROM deporte WHERE estado = 'ACTIVO' AND id_deporte = p_id order by id_deporte asc;
END
$BODY$;

CREATE OR REPLACE FUNCTION fn_buscar_deporte_nombre(p_nombre varchar)
RETURNS SETOF deporte
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
RETURN QUERY
SELECT * FROM deporte WHERE estado = 'ACTIVO' AND 
nombre LIKE '%'||p_nombre||'%'order by nombre asc;
END
$BODY$;

CREATE OR REPLACE PROCEDURE sp_registrar_alumno
(p_nombre varchar(100),
    dni char(8),
    nombres varchar,
    sexo char(1),
    estado varchar,
    direccion varchar,
    email varchar,
    telefono char(9),
	OUT msge varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM deporte WHERE nombre=p_nombre))THEN
 		msge:=  'El deporte: '||p_nombre||', ya existe';
	ELSE
		INSERT INTO deporte (nombre,descripcion,estado) VALUES(p_nombre, p_descripcion, p_estado);
		msge:=  'Registrado correctamente';
	END IF;
END
$BODY$;

CREATE OR REPLACE PROCEDURE sp_actualizar_alumno
(
	p_id INT,
	dni char(8),
    nombres varchar,
    sexo char(1),
    estado varchar,
    direccion varchar,
    email varchar,
    telefono char(9),
	OUT msge varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
IF(EXISTS(SELECT * FROM deporte WHERE nombre=p_nombre AND id_deporte<>p_id))THEN
 		msge:=  'El deporte: '||p_nombre||', ya existe';
	ELSE
		UPDATE deporte SET nombre=p_nombre, descripcion=p_descripcion, estado=p_estado WHERE id_deporte=p_id;
		msge:=  'Actualizado correctamente';
	END IF;
END
$BODY$;

CREATE OR REPLACE PROCEDURE sp_eliminar_deporte
(
	p_id INT,
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
IF(NOT EXISTS(SELECT * FROM  WHERE id_deporte=p_id))THEN
 		msge:=  'El deporte: '||p_nombre||', no existe';
	ELSE
		UPDATE deporte SET estado='ELIMINADO' WHERE id_deporte=p_id;
		msge:=  'Eliminado correctamente';
	END IF;
END
$BODY$;