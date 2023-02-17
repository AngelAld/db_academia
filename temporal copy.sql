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
  total numeric (8, 2),
  numCuotas int,
  estado varchar,
  MATRICULAid int,
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
  total numeric (8, 2),
  numCuotas int,
  estado varchar,
  MATRICULAid int,
  OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
		UPDATE pago SET id_gh = p_id_gh, estado = p_estado, f_pago = p_f_pago WHERE id = p_id AND id_gh = p_id_gh AND id_alumno = p_id_alumno;
		msge:=  'Actualizado correctamente';
END
$BODY$;

