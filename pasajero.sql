DROP TABLE PASAJERO CASCADE;
DROP TABLE USUARIO CASCADE;


CREATE TABLE PASAJERO(
	id SERIAL,
	nombre varchar not null,
	dni char(8) not null,
	brevete varchar not null,
	sexo varchar not null,
	est_civ varchar not null,
	fecha_nac date,
	primary key(id)
);

CREATE TABLE USUARIO(
id SERIAL,
usuario varchar not null,
email varchar not null,
token char(6)
);

insert into usuario(usuario, email) values ('admin', 'aaaldana50@gmail.com');

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

CREATE OR REPLACE FUNCTION func_listar_pasajeros()
RETURNS SETOF pasajero
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT * FROM pasajero;
    END;
$BODY$;

CREATE OR REPLACE FUNCTION func_buscar_pasajero
(p_id INT
)
RETURNS SETOF pasajero
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM pasajero WHERE id=p_id;
END
$BODY$;


CREATE OR REPLACE FUNCTION func_buscar_pasajero_nombre
(p_nombre VARCHAR(100)
)
RETURNS SETOF pasajero
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM pasajero WHERE nombre LIKE '%'||p_nombre||'%';
END
$BODY$;


CREATE OR REPLACE PROCEDURE sp_registrar_pasajero
(
	p_nombre varchar,
	p_dni char(8) ,
	p_brevete varchar ,
	p_sexo varchar ,
	p_est_civ varchar,
	p_fecha_nac date,
    OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM pasajero WHERE nombre=p_nombre))THEN
 		msge:=  'El pasajero: '||p_nombre||', ya existe';
	ELSE
		INSERT INTO pasajero (nombre, dni, brevete, sexo, est_civ, fecha_nac) 
        VALUES(p_nombre, p_dni, p_brevete, p_sexo, p_est_civ, p_fecha_nac);
		msge:=  'Registrado correctamente';
	END IF;
END
$BODY$;


CREATE OR REPLACE PROCEDURE sp_actualizar_pasajero
(
    p_id int,
	p_nombre varchar,
	p_dni char(8) ,
	p_brevete varchar ,
	p_sexo varchar ,
	p_est_civ varchar,
	p_fecha_nac date,
    OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
 	IF(EXISTS(SELECT * FROM pasajero WHERE nombre=p_nombre AND id<>p_id))THEN
 		msge:=  'El pasajero: '||p_nombre||', ya existe';
	ELSE
		UPDATE pasajero SET nombre = p_nombre, dni=p_dni, brevete=p_brevete, sexo=p_sexo, est_civ=p_est_civ, fecha_nac=p_fecha_nac WHERE id=p_id;
		msge:=  'Actualizado correctamente';
	END IF;
END
$BODY$;

CREATE OR REPLACE PROCEDURE sp_actualizar_token
(
    p_token varchar,
    OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    IF(p_token='') THEN
    p_token:= NULL;
    END IF;

    UPDATE usuario set token=p_token;
    msge:= 'ACTUALIZADO CORRECTAMENTE';
END
$BODY$;

CREATE OR REPLACE FUNCTION func_listar_usuarios()
RETURNS SETOF usuario
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RETURN QUERY
		SELECT * FROM usuario;
END
$BODY$;