DROP TABLE IF EXISTS ALUMNO CASCADE;
DROP TABLE IF EXISTS AMBIENTE CASCADE;
DROP TABLE IF EXISTS BOLETA CASCADE;
DROP TABLE IF EXISTS CUOTA CASCADE;
DROP TABLE IF EXISTS DEPORTE CASCADE;
DROP TABLE IF EXISTS DOCENTE CASCADE;
DROP TABLE IF EXISTS ESTADOS CASCADE;
DROP TABLE IF EXISTS FACTURA CASCADE;
DROP TABLE IF EXISTS GRUPO_HORARIO CASCADE;
DROP TABLE IF EXISTS MATRICULA CASCADE;
DROP TABLE IF EXISTS PAGO CASCADE;
DROP TABLE IF EXISTS ROL CASCADE;
DROP TABLE IF EXISTS TICKET CASCADE;
DROP TABLE IF EXISTS TIPO_DOC_ID CASCADE;
DROP TABLE IF EXISTS USUARIO CASCADE;



CREATE TABLE ALUMNO (
  id        SERIAL NOT NULL, 
  dni       char(8) NOT NULL UNIQUE, 
  nombres   varchar(255) NOT NULL, 
  sexo      char(1) NOT NULL, 
  estado    varchar(12) NOT NULL, 
  direccion varchar(255) NOT NULL, 
  email     varchar(255) NOT NULL, 
  telefono  char(9) NOT NULL, 
  PRIMARY KEY (id));
CREATE TABLE AMBIENTE (
  id          SERIAL NOT NULL, 
  nombre      varchar(100) NOT NULL, 
  descripcion varchar(250) NOT NULL, 
  capacidad   int4 NOT NULL, 
  estado      varchar(12) NOT NULL, 
  PRIMARY KEY (id));
CREATE TABLE BOLETA (
  id          SERIAL NOT NULL, 
  f_emision   date DEFAULT CURRENT_DATE NOT NULL, 
  ruc         char(11) NOT NULL, 
  serie       char(4) DEFAULT 'B001' NOT NULL, 
  correlativo char(8) NOT NULL, 
  doc_id      varchar(12), 
  nombres     varchar(200) NOT NULL, 
  monto       numeric(8, 2) NOT NULL, 
  igv         numeric(8, 2) DEFAULT 0.18 NOT NULL, 
  t_doc_id    char(2) NOT NULL, 
  id_cuota    int4 NOT NULL, 
  PRIMARY KEY (id));
CREATE TABLE CUOTA (
  id              SERIAL NOT NULL, 
  monto           numeric(8, 2) NOT NULL, 
  fecha_v         date NOT NULL, 
  fecha_p         date NOT NULL, 
  estado          varchar(12) NOT NULL, 
  id_pago         int4 NOT NULL, 
  id_gh           int4 NOT NULL, 
  id_alumno       int4 NOT NULL, 
  PAGOMATRICULAid int4, 
  PRIMARY KEY (id));
CREATE TABLE DEPORTE (
  id          SERIAL NOT NULL, 
  nombre      varchar(25) NOT NULL UNIQUE, 
  descripcion varchar(255) NOT NULL, 
  estado      varchar(12) NOT NULL, 
  PRIMARY KEY (id));
CREATE TABLE DOCENTE (
  id        SERIAL NOT NULL, 
  dni       char(8) NOT NULL UNIQUE, 
  nombres   varchar(255) NOT NULL, 
  sexo      char(1) NOT NULL, 
  estado    varchar(12) NOT NULL, 
  direccion varchar(255) NOT NULL, 
  email     varchar(255) NOT NULL, 
  telefono  char(9) NOT NULL, 
  PRIMARY KEY (id));
CREATE TABLE FACTURA (
  id          SERIAL NOT NULL, 
  f_emision   date DEFAULT CURRENT_DATE NOT NULL, 
  ruc         char(11) NOT NULL, 
  serie       char(4) DEFAULT 'F001' NOT NULL, 
  correlativo char(8) NOT NULL, 
  t_doc_id    char(2) DEFAULT '06' NOT NULL, 
  doc_id      varchar(12) NOT NULL, 
  rs_usu      varchar(200) NOT NULL, 
  id_cuota    int4 NOT NULL, 
  monto       numeric(8, 2) NOT NULL, 
  igv         numeric(8, 2) DEFAULT 0.18 NOT NULL, 
  PRIMARY KEY (id));
CREATE TABLE GRUPO_HORARIO (
  id          SERIAL NOT NULL, 
  nombre      varchar(255) NOT NULL, 
  id_deporte  int4 NOT NULL, 
  id_docente  int4 NOT NULL, 
  f_inicio    date NOT NULL, 
  f_fin       date NOT NULL, 
  hora_inicio int4 NOT NULL, 
  hora_fin    int4 NOT NULL, 
  estado      varchar(12) NOT NULL, 
  id_ambiente int4 NOT NULL, 
  PRIMARY KEY (id));
CREATE TABLE MATRICULA (
  id          SERIAL NOT NULL, 
  id_gh       int4 NOT NULL, 
  id_alumno   int4 NOT NULL, 
  estado      varchar(12) NOT NULL, 
  f_matricula date NOT NULL, 
  PRIMARY KEY (id));
CREATE TABLE PAGO (
  id          SERIAL NOT NULL, 
  total       numeric(8, 2) NOT NULL, 
  numCuotas   int4 NOT NULL, 
  estado      varchar(12) NOT NULL, 
  MATRICULAid int4 NOT NULL, 
  PRIMARY KEY (id));
CREATE TABLE ROL (
  id     SERIAL NOT NULL, 
  nombre varchar(255) NOT NULL UNIQUE, 
  estado varchar(12) NOT NULL, 
  PRIMARY KEY (id));
CREATE TABLE TICKET (
  id          SERIAL NOT NULL, 
  fh_emision  timestamp NOT NULL, 
  ruc         char(11) NOT NULL, 
  serie       int4 NOT NULL, 
  correlativo char(8) NOT NULL, 
  doc_id      int4 NOT NULL, 
  direccion   varchar(255) NOT NULL, 
  monto       numeric(8, 2) NOT NULL, 
  igv         numeric(8, 2) NOT NULL, 
  t_doc_id    char(2) NOT NULL, 
  id_cuota    int4 NOT NULL, 
  PRIMARY KEY (id));
CREATE TABLE TIPO_DOC_ID (
  id         char(2) NOT NULL, 
  desc_larga varchar(255) NOT NULL, 
  desc_corta varchar(255) NOT NULL, 
  PRIMARY KEY (id));
CREATE TABLE USUARIO (
  id      SERIAL NOT NULL, 
  id_rol  int4 NOT NULL, 
  nombres varchar(255) NOT NULL UNIQUE, 
  usuario varchar(255) NOT NULL UNIQUE, 
  clave   varchar(255) NOT NULL, 
  token   char(6), 
  email   varchar(255) NOT NULL, 
  estado  varchar(12) NOT NULL, 
  PRIMARY KEY (id));
ALTER TABLE GRUPO_HORARIO ADD CONSTRAINT FKGRUPO_HORA389472 FOREIGN KEY (id_deporte) REFERENCES DEPORTE (id);
ALTER TABLE GRUPO_HORARIO ADD CONSTRAINT FKGRUPO_HORA420958 FOREIGN KEY (id_docente) REFERENCES DOCENTE (id);
ALTER TABLE GRUPO_HORARIO ADD CONSTRAINT FKGRUPO_HORA749933 FOREIGN KEY (id_ambiente) REFERENCES AMBIENTE (id);
ALTER TABLE MATRICULA ADD CONSTRAINT FKMATRICULA844437 FOREIGN KEY (id_gh) REFERENCES GRUPO_HORARIO (id);
ALTER TABLE MATRICULA ADD CONSTRAINT FKMATRICULA244216 FOREIGN KEY (id_alumno) REFERENCES ALUMNO (id);
ALTER TABLE PAGO ADD CONSTRAINT FKPAGO591107 FOREIGN KEY (MATRICULAid) REFERENCES MATRICULA (id);
ALTER TABLE CUOTA ADD CONSTRAINT FKCUOTA628530 FOREIGN KEY (id_pago) REFERENCES PAGO (id);
ALTER TABLE USUARIO ADD CONSTRAINT FKUSUARIO389085 FOREIGN KEY (id_rol) REFERENCES ROL (id);
ALTER TABLE FACTURA ADD CONSTRAINT FKFACTURA64688 FOREIGN KEY (id_cuota) REFERENCES CUOTA (id);
ALTER TABLE FACTURA ADD CONSTRAINT FKFACTURA905065 FOREIGN KEY (t_doc_id) REFERENCES TIPO_DOC_ID (id);
ALTER TABLE BOLETA ADD CONSTRAINT FKBOLETA354655 FOREIGN KEY (t_doc_id) REFERENCES TIPO_DOC_ID (id);
ALTER TABLE BOLETA ADD CONSTRAINT FKBOLETA647181 FOREIGN KEY (id_cuota) REFERENCES CUOTA (id);
ALTER TABLE TICKET ADD CONSTRAINT FKTICKET833352 FOREIGN KEY (t_doc_id) REFERENCES TIPO_DOC_ID (id);
ALTER TABLE TICKET ADD CONSTRAINT FKTICKET803106 FOREIGN KEY (id_cuota) REFERENCES CUOTA (id);
