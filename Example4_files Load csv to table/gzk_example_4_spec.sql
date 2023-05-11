SET FEEDBACK ON
CREATE OR REPLACE PACKAGE gzk_example_4 AS

  -- FILE NAME..: gzk_example_4_spec.sql
  -- RELEASE....: MC:1.0
  -- OBJECT NAME: gzk_example_4
  -- PRODUCT....: GENERAL
  -- COPYRIGHT..: Copyright (c) Ellucian 2021. All rights reserved.
  --

  -- query v$session_longops to get progress number processes vs total to process
  -- query v$session action to get status text
  TYPE update_stu_acct_progress IS RECORD(
    status_text VARCHAR2(200),
    so_far     NUMBER,
    total_work NUMBER,
    units      VARCHAR2(50));

  TYPE update_stu_acct_progress_t IS TABLE OF update_stu_acct_progress;

  FUNCTION f_get_update_stu_acct_progress RETURN update_stu_acct_progress_t
    PIPELINED;

  -- make sure we always return the same value for the module name when using DBMS_SCHEDULER
  FUNCTION f_get_parking_fees_module RETURN VARCHAR2;

  -- DBMS_SCHEDULER job to update accounts
  PROCEDURE p_update_student_accounts_job(p_csv_file_name VARCHAR2);

  PROCEDURE p_update_student_accounts(p_csv_file_name VARCHAR2);

END gzk_example_4;
/
SHOW ERRORS
