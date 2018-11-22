--------------------------------------------------------
-- Archivo creado  - jueves-noviembre-01-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body PREDICTIVO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "VUC"."PREDICTIVO" AS
	PROCEDURE get_pais(p_pais	 IN	  mc_paises_cv.pac_pais%TYPE
							,p_cant	 IN	  INTEGER
							,p_list		 OUT VARCHAR2) AS
		v_str_pais	  mc_paises_cv.pac_pais%TYPE;
		str_jsoni	  VARCHAR2(100);
		str_jsonf	  VARCHAR2(100);
		resultado	  VARCHAR2(4000);
		v_recordset   VARCHAR2(100);
		n				  INTEGER;

		CURSOR p_recordset IS
			SELECT str_jsoni || pac_pais || str_jsonf AS pais
			  FROM mc_paises_cv
			 WHERE pac_pais LIKE v_str_pais
					 AND ROWNUM <= n;
	BEGIN
		IF p_cant > max_cursor THEN
			n := max_cursor;
		ELSE
			n := p_cant;
		END IF;

		v_str_pais := '%' || UPPER(p_pais) || '%';
		str_jsoni := '{"pais":"';
		str_jsonf := '"}';

		OPEN p_recordset;

		resultado := '{"list_pais": [ ';

		LOOP
			FETCH p_recordset INTO v_recordset;

			EXIT WHEN p_recordset%NOTFOUND;
			resultado := resultado || v_recordset || ',';
		END LOOP;

		n := LENGTH(resultado);
		resultado := SUBSTR(resultado, 1, n - 1) || '] }';
		p_list := resultado;
	END get_pais;

	PROCEDURE get_prov(p_pais			IN 	 mc_paises_cv.pac_pais%TYPE
							,p_provincia	IN 	 mc_provincias_cv.prc_provincia%TYPE
							,p_cant			IN 	 INTEGER
							,p_list				OUT VARCHAR2) AS
		v_str_prov	  mc_provincias_cv.prc_provincia%TYPE;
		str_jsoni	  VARCHAR2(100);
		str_jsonf	  VARCHAR2(100);
		resultado	  VARCHAR2(4000);
		v_recordset   VARCHAR2(100);
		n				  NUMBER;

		CURSOR p_recordset IS
			SELECT str_jsoni || PRc_PROVINCIA || str_jsonf AS provincia
			  FROM MC_PROVINCIAs_CV a, mc_paises_cv b
			 WHERE	  A.PRC_PAC_ID = B.PAC_ID
					 AND B.PAC_PAIS = UPPER(p_pais)
					 AND PRc_PROVINCIA LIKE v_str_prov
					 AND ROWNUM <= n;
	BEGIN
		IF p_cant > max_cursor THEN
			n := max_cursor;
		ELSE
			n := p_cant;
		END IF;

		v_str_prov := '%' || UPPER(p_provincia) || '%';
		str_jsoni := '{"provincia":"';
		str_jsonf := '"}';

		OPEN p_recordset;

		resultado := '{"list_provincia": [ ';

		LOOP
			FETCH p_recordset INTO v_recordset;

			EXIT WHEN p_recordset%NOTFOUND;
			resultado := resultado || v_recordset || ',';
		END LOOP;

		n := LENGTH(resultado);
		resultado := SUBSTR(resultado, 1, n - 1) || '] }';
		p_list := resultado;
	END get_prov;

	PROCEDURE get_dep(
		p_pais		  IN		mc_paises_cv.pac_pais%TYPE
	  ,p_provincia   IN		mc_provincia_teco.prv_provincia%TYPE
	  ,p_depto		  IN		MC_DEPARTAMENTOS_TECO.DEP_DEPARTAMENTO%TYPE
	  ,p_cant		  IN		INTEGER
	  ,p_list			  OUT VARCHAR2
	) AS
		v_str_depto   MC_DEPARTAMENTOS_TECO.DEP_DEPARTAMENTO%TYPE;
		str_jsoni	  VARCHAR2(100);
		str_jsonf	  VARCHAR2(100);
		resultado	  VARCHAR2(4000);
		v_recordset   VARCHAR2(100);
		n				  NUMBER;

		CURSOR p_recordset IS
			SELECT *
			  FROM (SELECT str_jsoni || city || str_jsonf AS city
						 FROM (SELECT DEP_DEPARTAMENTO AS city
									FROM mc_pais_teco a
										 ,mc_provincia_teco p
										 ,MC_DEPARTAMENTOS_TECO l
								  WHERE		SUBSTR(l.DEP_ID, 1, 1) = p.prv_id
										  AND A.PAI_PAIS = UPPER(p_pais)
										  AND p.prv_provincia = UPPER(p_provincia)
										  AND(l.DEP_DEPARTAMENTO LIKE UPPER(v_str_depto))
								 UNION
								 SELECT DEC_DEPARTAMENTO AS city
									FROM mc_paises_cv a
										 ,MC_PROVINCIAS_CV p
										 ,MC_DEPARTAMENTOS_CV l
								  WHERE		PAC_PAIS = UPPER(p_pais)
										  AND pac_id = PRC_PAC_ID
										  AND PRC_PROVINCIA = UPPER(p_provincia)
										  AND prc_id = DEC_PRC_ID
										  AND DEC_DEPARTAMENTO LIKE UPPER(v_str_depto)))
			 WHERE ROWNUM <= n;
	BEGIN
		IF p_cant > max_cursor THEN
			n := max_cursor;
		ELSE
			n := p_cant;
		END IF;

		v_str_depto := '%' || UPPER(p_depto) || '%';
		str_jsoni := '{"city":"';
		str_jsonf := '"}';

		OPEN p_recordset;

		resultado := '{"list_city": [ ';

		LOOP
			FETCH p_recordset INTO v_recordset;

			EXIT WHEN p_recordset%NOTFOUND;
			resultado := resultado || v_recordset || ',';
		END LOOP;

		n := LENGTH(resultado);
		resultado := SUBSTR(resultado, 1, n - 1) || '] }';
		p_list := resultado;
	END get_dep;

	PROCEDURE get_loc(
		p_pais		  IN		mc_paises_cv.pac_pais%TYPE
	  ,p_provincia   IN		mc_provincia_teco.prv_provincia%TYPE
	  ,p_depto		  IN		MC_DEPARTAMENTOS_TECO.DEP_DEPARTAMENTO%TYPE
	  ,p_localidad   IN		mc_mapeos_localidades.mlo_nombre%TYPE
	  ,p_cant		  IN		INTEGER
	  ,p_list			  OUT VARCHAR2
	) AS
		v_str_loc	  mc_mapeos_localidades.mlo_nombre%TYPE;
		str_jsoni	  VARCHAR2(100);
		str_jsonf	  VARCHAR2(100);
		resultado	  VARCHAR2(4000);
		v_recordset   VARCHAR2(100);
		n				  NUMBER;
		max_cursor	  INTEGER := 30;

		CURSOR p_recordset IS
			SELECT *
			  FROM (SELECT str_jsoni || localidad || str_jsonf AS localidad
						 FROM (SELECT l.ilt_localidad AS localidad
									FROM mc_pais_teco a
										 ,mc_provincia_teco p
										 ,MC_DEPARTAMENTOS_TECO d
										 ,MC_IMPORT_LOCALIDADES_TECO l
								  WHERE		SUBSTR(l.ILT_LOCALIDAD_ID, 1, 1) = p.prv_id
										  AND A.PAI_PAIS = UPPER(p_pais)
										  AND p.prv_provincia = UPPER(p_provincia)
										  AND d.DEP_DEPARTAMENTO = UPPER(p_depto)
										  AND ilt_pro_id = (SELECT MAX(pro_id)
																	 FROM mc_procesos
																	WHERE pro_codigo_retorno = 0
																			AND pro_tipo = 'PROCESO')
										  AND ILT_DEPARTAMENTO_ID = DEP_ID
										  AND l.ilt_localidad LIKE UPPER(v_str_loc)
								 UNION
								 SELECT l.ilc_localidad AS localidad
									FROM mc_paises_cv a
										 ,MC_PROVINCIAS_CV p
										 ,MC_DEPARTAMENTOS_CV d
										 ,MC_IMPORT_LOCALIDADES_CV l
								  WHERE		PAC_PAIS = UPPER(p_pais)
										  AND pac_id = PRC_PAC_ID
										  AND PRC_PROVINCIA = UPPER(p_provincia)
										  AND prc_id = DEC_PRC_ID
										  AND DEC_DEPARTAMENTO = UPPER(p_depto)
										  AND ILC_DEC_ID = DEC_ID
										  AND ilC_pro_id = (SELECT MAX(pro_id)
																	 FROM mc_procesos
																	WHERE pro_codigo_retorno = 0
																			AND pro_tipo = 'PROCESO')
										  AND l.ilC_localidad LIKE UPPER(v_str_loc)))
			 WHERE ROWNUM <= n;
	BEGIN
		IF p_cant > max_cursor THEN
			n := max_cursor;
		ELSE
			n := p_cant;
		END IF;

		v_str_loc := '%' || UPPER(p_localidad) || '%';
		str_jsoni := '{"localidad":"';
		str_jsonf := '"}';

		OPEN p_recordset;

		resultado := '{"list_localidad": [ ';

		LOOP
			FETCH p_recordset INTO v_recordset;

			EXIT WHEN p_recordset%NOTFOUND;
			resultado := resultado || v_recordset || ',';
		END LOOP;

		n := LENGTH(resultado);
		resultado := SUBSTR(resultado, 1, n - 1) || '] }';
		p_list := resultado;
	END get_loc;

	PROCEDURE get_street_list(
		p_pais			IN 	 mc_paises_cv.pac_pais%TYPE
	  ,p_provincia 	IN 	 mc_provincia_teco.prv_provincia%TYPE
	  ,p_depto			IN 	 MC_DEPARTAMENTOS_TECO.DEP_DEPARTAMENTO%TYPE
	  ,p_localidad 	IN 	 mc_mapeos_localidades.mlo_nombre%TYPE
	  ,p_str_street	IN 	 mc_mapeos_consolidados.mac_ccv_calle%TYPE
	  ,p_cant			IN 	 INTEGER
	  ,p_list				OUT VARCHAR2
	) AS
		v_str_street	mc_mapeos_consolidados.mac_ccv_calle%TYPE;
		v_street 		VARCHAR2(100);
		str_json1		VARCHAR2(100);
		str_json2		VARCHAR2(100);
		str_json3		VARCHAR2(100);
		str_json4		VARCHAR2(100);
		resultado		VARCHAR2(4000);
		cant_reg 		NUMBER;
		n					NUMBER := 0;

		CURSOR c_streets IS
			SELECT	 *
			  FROM (SELECT 	/*+ ORDERED */ str_json1
								|| mac_cte_calle_id
								|| str_json2
								|| mac_ccv_calle_id
								|| str_json3
								|| DECODE(mac_cte_calle,
											 NULL, mac_ccv_calle,
											 mac_cte_calle)
								|| str_json4
									AS calles
						 FROM (SELECT *
									FROM mc_mapeos_consolidados
								  WHERE mac_pro_id = (SELECT MAX(pro_id)
																FROM mc_procesos
															  WHERE pro_codigo_retorno = 0
																	  AND pro_tipo = 'PROCESO')) m
							  ,mc_provincia_teco p
							  ,mc_mapeos_localidades l
						WHERE 	 SUBSTR(m.mac_cte_localidad_id, 1, 1) = p.prv_id
								AND m.mac_cte_localidad_id = l.mlo_id_teco
								AND p.prv_provincia = UPPER(p_provincia)
								AND l.mlo_nombre LIKE UPPER(p_localidad)
								AND m.MAC_CTE_ESTADO = 'H'
								AND m.mac_cte_calle LIKE v_str_street
					  UNION
					  SELECT /*+ ORDERED */	str_json1
								|| mac_cte_calle_id
								|| str_json2
								|| mac_ccv_calle_id
								|| str_json3
								|| DECODE(mac_ccv_calle,
											 NULL, mac_cte_calle,
											 mac_ccv_calle)
								|| str_json4
									AS calles
						 FROM (SELECT *
									FROM mc_mapeos_consolidados
								  WHERE mac_pro_id = (SELECT MAX(pro_id)
																FROM mc_procesos
															  WHERE pro_codigo_retorno = 0
																	  AND pro_tipo = 'PROCESO')) m
							  ,mc_provincia_teco p
							  ,mc_mapeos_localidades l
						WHERE 	 SUBSTR(m.mac_cte_localidad_id, 1, 1) = p.prv_id
								AND m.mac_cte_localidad_id = l.mlo_id_teco
								AND p.prv_provincia = UPPER(p_provincia)
								AND l.mlo_nombre LIKE UPPER(p_localidad)
								AND m.mac_CCV_calle LIKE v_str_street)
			 WHERE ROWNUM <= n;
	BEGIN
		IF p_cant > max_cursor THEN
			n := max_cursor;
		ELSE
			n := p_cant;
		END IF;

		v_str_street := '%' || UPPER(p_str_street) || '%';
		str_json1 := '{"id_teco":"';
		str_json2 := '","id_cv":"';
		str_json3 := '","calle":"';
		str_json4 := '"}';

		OPEN c_streets;

		resultado := '{"list_street": [ ';

		LOOP
			FETCH c_streets INTO v_street;

			EXIT WHEN c_streets%NOTFOUND;
			resultado := resultado || v_street || ',';
		END LOOP;

		n := LENGTH(resultado);
		resultado := SUBSTR(resultado, 1, n - 1) || '] }';
		p_list := resultado;
		DBMS_OUTPUT.Put_Line('P_LIST = ' || LENGTH(p_list));
	END get_street_list;

	PROCEDURE get_street_list_sep(
		p_pais			IN 	 mc_paises_cv.pac_pais%TYPE
	  ,p_provincia 	IN 	 mc_provincia_teco.prv_provincia%TYPE
	  ,p_depto			IN 	 MC_DEPARTAMENTOS_TECO.DEP_DEPARTAMENTO%TYPE
	  ,p_localidad 	IN 	 mc_mapeos_localidades.mlo_nombre%TYPE
	  ,p_str_street	IN 	 mc_mapeos_consolidados.mac_ccv_calle%TYPE
	  ,p_cant			IN 	 INTEGER
	  ,p_list				OUT VARCHAR2
	) AS
		v_str_street	 mc_mapeos_consolidados.mac_ccv_calle%TYPE;
		v_street_teco	 VARCHAR2(100);
		v_street_cv 	 VARCHAR2(100);
		str_json1		 VARCHAR2(100);
		str_json2		 VARCHAR2(100);
		str_json3		 VARCHAR2(100);
		str_json4		 VARCHAR2(100);
		resultado		 VARCHAR2(4000);
		cant_reg 		 NUMBER;
		n					 NUMBER := 0;

		CURSOR c_streets_teco IS
			SELECT *
			  FROM (SELECT 	str_json1
								|| mac_cte_calle_id
								|| str_json2
								|| mac_ccv_calle_id
								|| str_json3
								|| DECODE(mac_cte_calle,
											 NULL, mac_ccv_calle,
											 mac_cte_calle)
								|| str_json4
									AS calles
						 FROM (SELECT *
									FROM mc_mapeos_consolidados
								  WHERE mac_pro_id = (SELECT MAX(pro_id)
																FROM mc_procesos
															  WHERE pro_codigo_retorno = 0
																	  AND pro_tipo = 'PROCESO')) m
							  ,mc_provincia_teco p
							  ,mc_mapeos_localidades l
						WHERE 	 SUBSTR(m.mac_cte_localidad_id, 1, 1) = p.prv_id
								AND m.mac_cte_localidad_id = l.mlo_id_teco
								AND p.prv_provincia = UPPER(p_provincia)
								AND l.mlo_nombre LIKE UPPER(p_localidad)
								AND m.MAC_CTE_ESTADO = 'H'
								AND m.mac_cte_calle LIKE v_str_street
								AND ROWNUM <= 10);

		CURSOR c_streets_cv IS
			SELECT *
			  FROM (SELECT 	str_json1
								|| mac_cte_calle_id
								|| str_json2
								|| mac_ccv_calle_id
								|| str_json3
								|| DECODE(mac_ccv_calle,
											 NULL, mac_cte_calle,
											 mac_ccv_calle)
								|| str_json4
									AS calles
						 FROM (SELECT *
									FROM mc_mapeos_consolidados
								  WHERE mac_pro_id = (SELECT MAX(pro_id)
																FROM mc_procesos
															  WHERE pro_codigo_retorno = 0
																	  AND pro_tipo = 'PROCESO')) m
							  ,mc_provincia_teco p
							  ,mc_mapeos_localidades l
						WHERE 	 SUBSTR(m.mac_cte_localidad_id, 1, 1) = p.prv_id
								AND m.mac_cte_localidad_id = l.mlo_id_teco
								AND p.prv_provincia = UPPER(p_provincia)
								AND l.mlo_nombre LIKE UPPER(p_localidad)
								AND m.mac_CCV_calle LIKE v_str_street
								AND ROWNUM <= 10);
	BEGIN
		IF p_cant > max_cursor THEN
			n := max_cursor;
		ELSE
			n := p_cant;
		END IF;

		v_str_street := '%' || UPPER(p_str_street) || '%';
		str_json1 := '{"id_teco":"';
		str_json2 := '","id_cv":"';
		str_json3 := '","calle":"';
		str_json4 := '"}';

		OPEN c_streets_teco;

		resultado := '{"list_street": [ ';
		cant_reg := 0;

		LOOP
			FETCH c_streets_teco INTO v_street_teco;

			EXIT WHEN c_streets_teco%NOTFOUND;
			cant_reg := cant_reg + 1;
			resultado := resultado || v_street_teco || ',';
		END LOOP;

       DBMS_OUTPUT.Put_Line('1_cursor = ' || cant_reg);

        close c_streets_teco ; 

		IF cant_reg < 10 THEN
			OPEN c_streets_cv;

			LOOP
				FETCH c_streets_cv INTO v_street_cv;
                EXIT WHEN cant_reg >= 10 or c_streets_cv%NOTFOUND;
				cant_reg := cant_reg + 1;
				resultado := resultado || v_street_cv || ',';
                
			END LOOP;
            DBMS_OUTPUT.Put_Line('2_cursor = ' || cant_reg);
            close c_streets_CV ; 
            

		END IF;



		n := LENGTH(resultado);
		resultado := SUBSTR(resultado, 1, n - 1) || '] }';
		p_list := resultado;
		DBMS_OUTPUT.Put_Line('P_LIST = ' || LENGTH(p_list));
	END get_street_list_sep;
END predictivo; 

/
