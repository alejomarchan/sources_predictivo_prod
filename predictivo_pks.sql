--------------------------------------------------------
-- Archivo creado  - jueves-noviembre-01-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PREDICTIVO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "VUC"."PREDICTIVO" AS
	max_cursor	 INTEGER := 30;

	PROCEDURE get_pais(p_pais	 IN	  mc_paises_cv.pac_pais%TYPE
							,p_cant	 IN	  INTEGER
							,p_list		 OUT VARCHAR2);

	PROCEDURE get_dep(
		p_pais		  IN		mc_paises_cv.pac_pais%TYPE
	  ,p_provincia   IN		mc_provincia_teco.prv_provincia%TYPE
	  ,p_depto		  IN		MC_DEPARTAMENTOS_TECO.DEP_DEPARTAMENTO%TYPE
	  ,p_cant		  IN		INTEGER
	  ,p_list			  OUT VARCHAR2
	);

	PROCEDURE get_prov(p_pais			IN 	 mc_paises_cv.pac_pais%TYPE
							,p_provincia	IN 	 mc_provincias_cv.prc_provincia%TYPE
							,p_cant			IN 	 INTEGER
							,p_list				OUT VARCHAR2);

	PROCEDURE get_loc(
		p_pais		  IN		mc_paises_cv.pac_pais%TYPE
	  ,p_provincia   IN		mc_provincia_teco.prv_provincia%TYPE
	  ,p_depto		  IN		MC_DEPARTAMENTOS_TECO.DEP_DEPARTAMENTO%TYPE
	  ,p_localidad   IN		mc_mapeos_localidades.mlo_nombre%TYPE
	  ,p_cant		  IN		INTEGER
	  ,p_list			  OUT VARCHAR2
	);

	PROCEDURE get_street_list(
		p_pais			IN 	 mc_paises_cv.pac_pais%TYPE
	  ,p_provincia 	IN 	 mc_provincia_teco.prv_provincia%TYPE
	  ,p_depto			IN 	 MC_DEPARTAMENTOS_TECO.DEP_DEPARTAMENTO%TYPE
	  ,p_localidad 	IN 	 mc_mapeos_localidades.mlo_nombre%TYPE
	  ,p_str_street	IN 	 mc_mapeos_consolidados.mac_ccv_calle%TYPE
	  ,p_cant			IN 	 INTEGER
	  ,p_list				OUT VARCHAR2
	);
END predictivo; 

/
