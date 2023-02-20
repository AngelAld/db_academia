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
