-- FUNCIONES Y PROCEDIMIENTOS
create or replace function func_login
(p_usuario varchar(20),
p_clave varchar(100)
)
returns table(
idusuario integer,nombres varchar(100), usuario varchar(100),
clave varchar(100), estado varchar(12))
language 'plpgsql'
as $body$
begin
return query
select
u.*
from usuario u
where u.usuario = p_usuario and u.clave = p_clave and u.estado='activo';
end
$body$;

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

CREATE OR REPLACE PROCEDURE sp_registrar_deporte
(p_nombre varchar(100),
p_descripcion varchar(12),
p_estado varchar,
OUT msge varchar(100)
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

CREATE OR REPLACE PROCEDURE sp_actualizar_deporte
(
	p_id INT,
	p_nombre varchar,
	p_descripcion varchar,
	p_estado varchar,
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

CREATE OR REPLACE FUNCTION func_buscar_usuario_token
(p_token VARCHAR(50)
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
(p_idrole INT, 
p_nombres VARCHAR(100), 
p_usuario VARCHAR(20), 
p_clave VARCHAR(100),
p_correo VARCHAR(100),
p_estado VARCHAR(12),
OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM usuario WHERE usuario=p_usuario))THEN
 		msge:=  'El usuario: '||p_usuario||', ya existe';
	ELSEIF(p_correo IS NULL)THEN
		INSERT INTO usuario (idrole,nombres,usuario,clave,correo,estado) VALUES(p_idrole,p_nombres,p_usuario,p_clave,p_correo,p_estado);
		msge:=  'Registrado correctamente';
	ELSEIF(p_correo IS NOT NULL)THEN
		IF(EXISTS(SELECT * FROM usuario WHERE correo=p_correo))THEN
			msge:=  'El correo: '||p_correo||', ya existe';
		ELSE
			INSERT INTO usuario (idrole,nombres,usuario,clave,correo,estado) VALUES(p_idrole,p_nombres,p_usuario,p_clave,p_correo,p_estado);
			msge:=  'Registrado correctamente';
		END IF;
	END IF;
END
$BODY$;


CREATE OR REPLACE PROCEDURE sp_actualizar_usuario_token
(p_id INT, 
p_token VARCHAR(50),
OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	IF(p_token = '')THEN
		p_token := NULL;
	END IF;
 	IF(EXISTS(SELECT * FROM usuario WHERE id=p_id))THEN
 		msge:=  'El usuario no existe';
	ELSE
		UPDATE usuario SET token=p_token WHERE id=p_id;
		msge:=  'Actualizado correctamente';
	END IF;
END
$BODY$;

CREATE OR REPLACE FUNCTION fn_listar_estados()
RETURNS SETOF estados
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
RETURN QUERY
SELECT * FROM estados;
END;
$BODY$;
