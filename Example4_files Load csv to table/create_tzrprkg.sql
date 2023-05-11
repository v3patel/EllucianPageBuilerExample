CONNECT taismgr/&&taismgr_password

PROMPT
PROMPT * Creating table: TZRPRKG
PROMPT
PROMPT NOTE: Values for applymod are DOMOD and NOMOD
PROMPT

REM
SET SERVEROUTPUT ON SIZE 1000000
REM
WHENEVER SQLERROR EXIT 99 ROLLBACK
DECLARE
  lv_sql        VARCHAR2(32000);
  lv_audit_only VARCHAR2(1);
BEGIN
  IF UPPER(NVL('&&applymod',
               'DOMOD')) = 'NOMOD' THEN
    lv_audit_only := 'Y';
  ELSE
    lv_audit_only := 'N';
  END IF;
  lv_sql := 'CREATE TABLE TZRPRKG
(
  TZRPRKG_BANNER_ID        VARCHAR2(9)   NOT NULL,
  TZRPRKG_FEE              NUMBER(12,2)  NOT NULL,
  TZRPRKG_FEE_DATE         DATE          NOT NULL,
  TZRPRKG_DESC             VARCHAR2(30)  NOT NULL,
  TZRPRKG_CSV_FILE_NAME    VARCHAR2(200) NOT NULL,
  TZRPRKG_PIDM             NUMBER(8),
  TZRPRKG_ACCD_TRAN_NUMBER NUMBER(8),
  TZRPRKG_ERROR_MESSAGE    VARCHAR2(4000),
  TZRPRKG_ACTIVITY_DATE    DATE          NOT NULL,
  TZRPRKG_USER_ID          VARCHAR2(30)  NOT NULL,
  TZRPRKG_SURROGATE_ID     NUMBER(19),
  TZRPRKG_VERSION          NUMBER(19),
  TZRPRKG_DATA_ORIGIN      VARCHAR2(30),
  TZRPRKG_VPDI_CODE        VARCHAR2(6)
)';


  gokdsql.p_create_table(p_sql                   => lv_sql,
                          p_table_owner           => 'TAISMGR',
                          p_table_name            => 'TZRPRKG',
                          p_size_like_table_owner => 'TAISMGR',
                          p_size_like_table       => 'TBRMISD',
                          p_audit_only            => lv_audit_only);

  -- dump any messages created by package
  gokdsql.p_dump_status_messages;

  --  Create primary key
  lv_sql := 'ALTER TABLE TZRPRKG
  ADD CONSTRAINT PK_TZRPRKG PRIMARY KEY
    (TZRPRKG_BANNER_ID,
     TZRPRKG_FEE,
     TZRPRKG_FEE_DATE,
     TZRPRKG_DESC,
     TZRPRKG_CSV_FILE_NAME
    )';

  gokdsql.p_create_pk_uk_constraint(p_sql => lv_sql,
                                     p_table_owner => 'TAISMGR',
                                     p_table_name => 'TZRPRKG',
                                     p_constraint_name => 'PK_TZRPRKG',
                                     p_constraint_type => 'P',
                                     p_size_like_index_owner => 'TAISMGR',
                                     p_size_like_index => 'PK_TBRDEPO',
                                     p_audit_only => lv_audit_only,
                                     p_drop_constraint => 'Y',
                                     p_reset_messages => 'Y');

  -- dump any messages created by package
  gokdsql.p_dump_status_messages;

END;
/
REM
PROMPT * Adding Table and Column Comments
COMMENT ON TABLE TZRPRKG IS
  'Elive 2021 Example 4. Table to process parking fees';
REM
COMMENT ON COLUMN TZRPRKG.TZRPRKG_BANNER_ID IS 'Banner ID from CSV file';
COMMENT ON COLUMN TZRPRKG.TZRPRKG_FEE       IS 'Amount of parking fee from CSV file';
COMMENT ON COLUMN TZRPRKG.TZRPRKG_FEE_DATE  IS 'Date of parking fee from CSV File';
COMMENT ON COLUMN TZRPRKG.TZRPRKG_DESC      IS 'Description of Parking Fee from CSV file';
COMMENT ON COLUMN TZRPRKG.TZRPRKG_CSV_FILE_NAME IS 'Name of CSV file uploaded';
COMMENT ON COLUMN TZRPRKG.TZRPRKG_PIDM        IS 'Pidm associated with Banner ID';
COMMENT ON COLUMN TZRPRKG.TZRPRKG_ACCD_TRAN_NUMBER IS 'Transaction number from TBRACCD after fee applied to student account';
COMMENT ON COLUMN TZRPRKG.TZRPRKG_ERROR_MESSAGE   IS 'Error message from trying to apply parking fee to student account';
COMMENT ON COLUMN TZRPRKG.TZRPRKG_ACTIVITY_DATE IS 'ACTIVITY DATE: Date of last activity (insert or update) on the record.';
COMMENT ON COLUMN TZRPRKG.TZRPRKG_USER_ID IS  'USER ID: The Oracle ID of the user who changed the record.';
REM
PROMPT * Grants for table
PROMPT
GRANT SELECT,INSERT,UPDATE,DELETE, REFERENCES ON TZRPRKG TO BANINST1;

PROMPT
PROMPT * Creating synonym for TZRPRKG.
REM
REM
connect baninst1/&&baninst1_password
CREATE OR REPLACE PUBLIC SYNONYM TZRPRKG for TAISMGR.TZRPRKG;
REM
