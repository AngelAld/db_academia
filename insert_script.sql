INSERT INTO TIPO_DOC_ID(id, desc_larga, desc_corta) VALUES
('01', 'LIBRETA ELECTORAL O DNI', 'L.E / DNI'),
('04' ,'CARNET DE EXTRANJERIA', 'CARNET EXT.'),
('06' ,'REG. UNICO DE CONTRIBUYENTES', 'RUC'),
('07' ,'PASAPORTE', 'PASAPORTE'),
('11' ,'PART. DE NACIMIENTO-IDENTIDAD', 'P. NAC.'),
('00' ,'OTROS', 'OTROS');



INSERT INTO ROL(nombre, estado) VALUES
('Administrador', 'ACTIVO'), 
('Docente', 'ACTIVO');


INSERT INTO USUARIO(id_rol, nombres, usuario, clave, estado, email) VALUES
(1, 'Juan Perez', 'admin', '5oUg4+minc8HLyFK9FShRg==','ACTIVO', 'juanperez@gmail.com');
INSERT INTO USUARIO(id_rol, nombres, usuario, clave, estado, email) VALUES
(1, 'Angel Aldana', 'admin2', '5oUg4+minc8HLyFK9FShRg==','ACTIVO', 'aaaldana50@gmail.com');
INSERT INTO USUARIO(id_rol, nombres, usuario, clave, estado, email) VALUES
(1, 'Ivan Galvez', 'admin3', '5oUg4+minc8HLyFK9FShRg==','ACTIVO', 'sample@gmail.com');


call sp_registrar_deporte('Futbol', 'Deporte futbol', 'ACTIVO', '');

call sp_registrar_deporte('Voley', 'Deporte voleyball','ACTIVO', '');

call sp_registrar_docente('71448693', 'Angel Aldana', 'M', 'ACTIVO', 'E. G. & G. 1102', 'aaaldana50@gmail.com', '999999999', '');

call sp_registrar_ambiente('CANCHA A1', 'Cancha de futbol de concreto en la zona A1', 30, 'ACTIVO', '');

call sp_registrar_grupo_horario('GH 1 FUTBOL', 1, 1, '2023-2-10', '2023-3-10', 17, 19, 'ACTIVO', 1, '');

call sp_registrar_alumno('1234567', 'Ivan Galvez', 'M', 'ACTIVO', 'Jaen 403', 'ivgalvez@gmail.com', '987654321', '');

call sp_registrar_matricula(1, 1, 'ACTIVO', CURRENT_DATE, '');

call sp_registrar_pago(200.00, 1, 'PENDIENTE', 1, '');

call sp_registrar_cuota(200.00, CURRENT_DATE, CURRENT_DATE, 'PAGADO', 1, '');