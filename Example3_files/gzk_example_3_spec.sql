SET FEEDBACK ON
CREATE OR REPLACE PACKAGE gzk_example_3 AS
 
  -- FILE NAME..: gzk_example_3_spec.sql
  -- RELEASE....: MC:1.0
  -- OBJECT NAME: gzk_example_3
  -- PRODUCT....: GENERAL
  -- COPYRIGHT..: Copyright (c) Ellucian 2021. All rights reserved.
  --
  --data type to be returned by the query 
  TYPE parking_charge_data_rec IS RECORD(
    banner_id  SPRIDEN.SPRIDEN_ID%TYPE,
    pidm       SPRIDEN.SPRIDEN_PIDM%TYPE,
    transaction_number TBRACCD.TBRACCD_TRAN_NUMBER%TYPE,
    transaction_date   TBRACCD.TBRACCD_ENTRY_DATE%TYPE,
    transaction_amount TBRACCD.TBRACCD_AMOUNT%TYPE,
    amount_remaining   TBRACCD.TBRACCD_BALANCE%TYPE,
    is_paid            VARCHAR2(1),
    date_paid          DATE);
 
  TYPE parking_charge_data_t IS TABLE OF parking_charge_data_rec;
 
  FUNCTION f_get_parking_charge_data(p_banner_id IN VARCHAR2) RETURN parking_charge_data_t
    PIPELINED;
 
END gzk_example_3;
/
SHOW ERRORS
