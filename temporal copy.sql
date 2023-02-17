/* CUOTA */

CREATE OR REPLACE FUNCTION func_listar_cuota()
RETURNS table(
  id int, 
  monto numeric(8, 2),
  fecha_v date,
  fecha_p date,
  estado varchar
)
LANGUAGE 'plpgsql'
AS $BODY$
	BEGIN
		RETURN QUERY
			SELECT
      p.*,
      al.nombres as alumno,
      gh.nombre as grupo_horario
      FROM cuota p
      INNER JOIN matricula m on p.MATRICULAid = m.id
      INNER JOIN ALUMNO al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE p.estado != 'ELIMINADO';
    END;
$BODY$;


CREATE OR REPLACE FUNCTION func_listar_cuota_admin()
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
      FROM cuota p
      INNER JOIN matricula m on p.MATRICULAid = m.id
      INNER JOIN ALUMNO al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id;
    END;
$BODY$;



CREATE OR REPLACE FUNCTION func_buscar_cuota
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
      FROM cuota p
      INNER JOIN matricula m on p.MATRICULAid = m.id
      INNER JOIN ALUMNO al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE m.id = p_id AND m.estado != 'ELIMINADO';
END
$BODY$;



CREATE OR REPLACE FUNCTION func_buscar_cuota_admin
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
      FROM cuota p
      INNER JOIN matricula m on p.MATRICULAid = m.id
      INNER JOIN ALUMNO al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE m.id = p_id;
END
$BODY$;



CREATE OR REPLACE FUNCTION func_buscar_cuota_alumno
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
      FROM cuota p
      INNER JOIN matricula m on p.MATRICULAid = m.id
      INNER JOIN ALUMNO al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE al.nombres LIKE '%'||p_alumno||'%' AND m.estado != 'ELIMINADO';
END
$BODY$;


CREATE OR REPLACE FUNCTION func_buscar_cuota_alumno_admin 
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
      FROM cuota p
      INNER JOIN matricula m on p.MATRICULAid = m.id
      INNER JOIN ALUMNO al on m.id_alumno = al.id
      INNER JOIN grupo_horario gh on m.id_gh = gh.id
			WHERE al.nombres LIKE '%'||p_alumno||'%';
END
$BODY$;


CREATE OR REPLACE PROCEDURE sp_registrar_cuota( 
  p_total numeric (8, 2),
  p_numCuotas int,
  p_estado varchar,
  p_MATRICULAid int,
  OUT msge varchar(100)
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
		INSERT INTO cuota(total, numCuotas, estado, MATRICULAid) VALUES
    (p_total, p_numCuotas, p_estado, p_MATRICULAid);
		msge:=  'Registrado correctamente';
END
$BODY$;


CREATE OR REPLACE PROCEDURE sp_actualizar_cuota(
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
		UPDATE cuota SET total = p_total, numCuotas = p_numCuotas, estado = p_estado, MATRICULAid = p_MATRICULAid WHERE id = p_id;
		msge:=  'Actualizado correctamente';
END
$BODY$;
