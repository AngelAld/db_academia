# FILES




| **Files**             | **Description**                            |
| ---                   | ---                                        | 
| **create_script**     | create script for tables                   |
| **fn_script**         | script of the functions and procedures     |
| **insert_script**     | insert script for sample and default data  |
| **temporal_***        | temporal scripts for writing functions     |


### CREATE_SCRIPT

#### TABLES:

```
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
CREATE TABLE ESTADOS (
  id          SERIAL NOT NULL, 
  descripcion varchar(255) NOT NULL, 
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
  PRIMARY KEY (id, 
  id_gh, 
  id_alumno));
CREATE TABLE PAGO (
  id          SERIAL NOT NULL, 
  id_gh       int4 NOT NULL, 
  id_alumno   int4 NOT NULL, 
  total       numeric(8, 2) NOT NULL, 
  numCuotas   int4 NOT NULL, 
  estado      varchar(12) NOT NULL, 
  MATRICULAid int4 NOT NULL, 
  PRIMARY KEY (id, 
  id_gh, 
  id_alumno, 
  MATRICULAid));
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
  estado  varchar(12) NOT NULL, 
  email   varchar(255) NOT NULL, 
  token   char(6), 
  PRIMARY KEY (id));
```