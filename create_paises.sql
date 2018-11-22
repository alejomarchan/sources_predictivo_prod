--------------------------------------------------------
-- Archivo creado  - jueves-noviembre-01-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table MC_PAISES_CV
--------------------------------------------------------

  CREATE TABLE "VUC"."MC_PAISES_CV" 
   (	"PAC_ID" NUMBER, 
	"PAC_PAIS" VARCHAR2(255 BYTE), 
	"PAC_LAST_UPDATE" DATE DEFAULT sysdate
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "VUC_DATA" ;
--------------------------------------------------------
--  DDL for Index PK_MC_PAISES_CV
--------------------------------------------------------

  CREATE UNIQUE INDEX "VUC"."PK_MC_PAISES_CV" ON "VUC"."MC_PAISES_CV" ("PAC_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "VUC_I" ;
--------------------------------------------------------
--  Constraints for Table MC_PAISES_CV
--------------------------------------------------------

  ALTER TABLE "VUC"."MC_PAISES_CV" ADD CONSTRAINT "PK_MC_PAISES_CV" PRIMARY KEY ("PAC_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "VUC_I"  ENABLE;
  ALTER TABLE "VUC"."MC_PAISES_CV" MODIFY ("PAC_ID" NOT NULL ENABLE);
