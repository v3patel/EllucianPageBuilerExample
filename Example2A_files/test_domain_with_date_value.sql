SET SERVEROUTPUT ON
SET FEEDBACK ON
SET ECHO ON
VAR ONLINE_FEE_ASSESSMENT CHAR(1);
VAR REFUND_BY_CRN CHAR(1);
VAR REFUND_BY_TOTAL CHAR(1);
VAR TERM_CODE CHAR(6);
VAR ID CHAR(50);
VAR ONLINE_ASSESS_EFF_DATE CHAR(50);

EXEC :ONLINE_FEE_ASSESSMENT := 'N';
EXEC :REFUND_BY_CRN := 'Y';
EXEC :REFUND_BY_TOTAL  := NULL;
EXEC :TERM_CODE := '202120';
REM EXEC :ONLINE_ASSESS_EFF_DATE := '2021-03-31T06:00:00.000Z';
EXEC :ONLINE_ASSESS_EFF_DATE := '30-MAR-21 02.00.00.000000000 AM';

BEGIN
  DECLARE
    timestamp_format VARCHAR2(100);
  
  BEGIN
    select VALUE
      INTO timestamp_format
      from NLS_SESSION_PARAMETERS
     where PARAMETER = 'NLS_TIMESTAMP_FORMAT';
  
    sb_term.p_update(p_term_code              => :TERM_CODE,
                     p_fee_assessment         => :ONLINE_FEE_ASSESSMENT,
                     p_fee_assessmnt_eff_date => TO_TIMESTAMP(:ONLINE_ASSESS_EFF_DATE,
                                                              timestamp_format),
                     p_refund_ind             => :REFUND_BY_TOTAL,
                     p_bycrn_ind              => :REFUND_BY_CRN
                     );
  
  END;
EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20000,
                            '1 This part is only visible in the logs and for users with a debug role. @USERMESSAGE:' || ' Error on Put/update' ||
                            SQLERRM);
END;
/
BEGIN
  DECLARE
    timestamp_format VARCHAR2(100);
  
  BEGIN
    select VALUE
      INTO timestamp_format
      from NLS_SESSION_PARAMETERS
     where PARAMETER = 'NLS_TIMESTAMP_FORMAT';
  
    sb_term.p_update(p_term_code              => :TERM_CODE,
                     p_fee_assessment         => :ONLINE_FEE_ASSESSMENT,
                     p_fee_assessmnt_eff_date => TO_TIMESTAMP(:ONLINE_ASSESS_EFF_DATE,
                                                              timestamp_format),
                     p_refund_ind             => :REFUND_BY_TOTAL,
                     p_bycrn_ind              => :REFUND_BY_CRN);
  
  END;
EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20000,
                            '2 This part is only visible in the logs and for users with a debug role. @USERMESSAGE:' ||
                            SQLERRM);
END;
/

select sobterm_term_code, to_char(sobterm_fee_assessmnt_eff_date,'DD-MON-YYYY')
From sobterm where sobterm_term_code like '2021%';

ROLLBACK;
