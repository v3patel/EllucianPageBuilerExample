CREATE OR REPLACE PACKAGE BODY gzk_example_3 AS

  -- FILE NAME..: gzk_example_3_body.sql
  -- RELEASE....: MC:1.0
  -- OBJECT NAME: gzk_example_3
  -- PRODUCT....: GENERAL
  -- COPYRIGHT..: Copyright (c) Ellucian 2021. All rights reserved.
  --

  FUNCTION f_find_date_paid(p_pidm     TBRAPPL.TBRAPPL_PIDM%TYPE,
                            p_tran_nbr TBRACCD.TBRACCD_TRAN_NUMBER%TYPE)
    RETURN DATE IS
    lv_date DATE;
    CURSOR appl_c(pidm_in NUMBER, chg_tran_in NUMBER) IS
      SELECT tbraccd_entry_date
        FROM tbrappl
        LEFT JOIN tbraccd
          on (tbrappl_pidm = tbraccd_pidm and
             tbrappl_pay_tran_number = tbraccd_tran_number)
       WHERE tbrappl_pidm = pidm_in
         AND tbrappl_chg_tran_number = chg_tran_in;
  
  BEGIN
    lv_date := NULL;
  
    OPEN appl_c(p_pidm, p_tran_nbr);
    FETCH appl_c
      INTO lv_date;
    CLOSE appl_c;
    RETURN lv_date;
  
  END f_find_date_paid;
  --
  FUNCTION f_get_parking_charge_data(p_banner_id IN VARCHAR2)
    RETURN parking_charge_data_t
    PIPELINED IS
    lv_park_chg_data parking_charge_data_rec;
    lv_row_count     NUMBER := 0;
    lv_is_paid       VARCHAR2(1);
    CURSOR charges_c(id_in SPRIDEN.SPRIDEN_ID%TYPE) IS
      SELECT spriden_pidm,
             tbraccd_tran_number,
             tbraccd_amount,
             tbraccd_balance,
             tbraccd_entry_date
        FROM spriden t
        LEFT JOIN tbraccd t
          ON (spriden_pidm = tbraccd_pidm)
       WHERE spriden_id = id_in
         AND spriden_change_ind IS NULL
         AND tbraccd_detail_code = 'PARK';
  
    charges_rec charges_c%ROWTYPE;
  BEGIN
    OPEN charges_c(p_banner_id);
    LOOP
      FETCH charges_c
        INTO charges_rec;
      EXIT WHEN charges_c%NOTFOUND;
      lv_row_count                        := lv_row_count + 1;
      lv_park_chg_data.banner_id          := p_banner_id;
      lv_park_chg_data.pidm               := charges_rec.spriden_pidm;
      lv_park_chg_data.transaction_number := charges_rec.tbraccd_tran_number;
      lv_park_chg_data.transaction_amount := charges_rec.tbraccd_amount;
      lv_park_chg_data.transaction_date   := charges_rec.tbraccd_entry_date;
      lv_park_chg_data.amount_remaining   := charges_rec.tbraccd_balance;
      IF NVL(charges_rec.tbraccd_balance,0) <= 0 THEN
        lv_is_paid := 'Y';
      ELSE
        lv_is_paid := 'N';
      END IF;
      lv_park_chg_data.is_paid            := lv_is_paid;
      lv_park_chg_data.date_paid          := f_find_date_paid(charges_rec.spriden_pidm,
                                                              charges_rec.tbraccd_tran_number);
    
      PIPE ROW(lv_park_chg_data);
    END LOOP;
    CLOSE charges_c;
    RETURN;
  END f_get_parking_charge_data;

END gzk_example_3;
/
SHOW ERRORS
