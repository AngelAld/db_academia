/* PAGO */

CREATE OR REPLACE FUNCTION func_listar_pago()
RETURNS table(
  id int, 
  id_gh int,
  id_alumno int,
  total numeric(8, 2),
  estado varchar(12),
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
      FROM pago m
      INNER JOIN alumno al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE m.estado != 'ELIMINADO';
    END;
$BODY$;


CREATE OR REPLACE FUNCTION func_listar_pago_admin()
RETURNS table(
  id int, 
  id_gh int,
  id_alumno int,
  estado varchar(12),
  f_pago date,
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
      FROM pago m
      INNER JOIN alumno al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id;
    END;
$BODY$;



CREATE OR REPLACE FUNCTION func_buscar_pago
(
  p_id int
)
RETURNS table(
  id int, 
  id_gh int,
  id_alumno int,
  estado varchar(12),
  f_pago date,
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
      FROM pago m
      INNER JOIN alumno al on m.id_alumno = al.id
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
  id_gh int,
  id_alumno int,
  estado varchar(12),
  f_pago date,
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
      FROM pago m
      INNER JOIN alumno al on m.id_alumno = al.id
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
  id_gh int,
  id_alumno int,
  estado varchar(12),
  f_pago date,
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
      FROM pago m
      INNER JOIN alumno al on m.id_alumno = al.id
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
  id_gh int,
  id_alumno int,
  estado varchar(12),
  f_pago date,
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
      FROM pago m
      INNER JOIN alumno al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE al.nombres LIKE '%'||p_alumno||'%';
END
$BODY$;
------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION func_buscar_pago_docente
(
  p_docente VARCHAR(100)
)
RETURNS table(
  id int, 
  id_gh int,
  id_alumno int,
  estado varchar(12),
  f_pago date,
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
      FROM pago m
      INNER JOIN alumno al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
      INNER JOIN docente doc on gh.id_docente = doc.id
			WHERE doc.nombres LIKE '%'||p_docente||'%' AND m.estado != 'ELIMINADO';
END
$BODY$;


CREATE OR REPLACE FUNCTION func_buscar_pago_docente_admin 
(
  p_docente VARCHAR(100)
)
RETURNS table(
  id int, 
  id_gh int,
  id_alumno int,
  estado varchar(12),
  f_pago date,
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
      FROM pago m
      INNER JOIN alumno al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
      INNER JOIN docente doc on gh.id_docente = doc.id
			WHERE doc.nombres LIKE '%'||p_docente||'%';
END
$BODY$;
------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION func_buscar_pago_fechas
(
	p_fecha1 date,
	p_fecha2 date
)
RETURNS table(
  id int, 
  id_gh int,
  id_alumno int,
  estado varchar(12),
  f_pago date,
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
      FROM pago m
      INNER JOIN alumno al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE (m.f_pago >= p_fecha1 AND m.f_pago <= p_fecha2) AND m.estado != 'ELIMINADO';
END
$BODY$;


CREATE OR REPLACE FUNCTION func_buscar_pago_fechas_admin
(
	p_fecha1 date,
	p_fecha2 date
)
RETURNS table(
  id int, 
  id_gh int,
  id_alumno int,
  estado varchar(12),
  f_pago date,
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
      FROM pago m
      INNER JOIN alumno al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE (m.f_pago >= p_fecha1 AND m.f_pago <= p_fecha2);
END
$BODY$;


CREATE OR REPLACE PROCEDURE sp_registrar_pago( 
  p_id_gh int,
  p_id_alumno int,
  p_estado varchar(12),
  p_f_pago date,
  OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
		INSERT INTO pago(id_gh, id_alumno, estado, f_pago) VALUES
    (p_id_gh, p_id_alumno, p_estado, p_f_pago);
		msge:=  'Registrado correctamente';
END
$BODY$;


CREATE OR REPLACE PROCEDURE sp_actualizar_pago(
  p_id int,
  p_id_gh int,
  p_id_alumno int,
  p_estado varchar(12),
  p_f_pago date,
  OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
		UPDATE pago SET id_gh = p_id_gh, estado = p_estado, f_pago = p_f_pago WHERE id = p_id AND id_gh = p_id_gh AND id_alumno = p_id_alumno;
		msge:=  'Actualizado correctamente';
END
$BODY$;

