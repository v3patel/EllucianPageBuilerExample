SET FEEDBACK ON
SET ECHO ON
VAR ONLINE_FEE_ASSESSMENT CHAR(1);
VAR REFUND_BY_CRN CHAR(1);
VAR REFUND_BY_TOTAL CHAR(1);
VAR TERM_CODE CHAR(6);

EXEC :ONLINE_FEE_ASSESSMENT := 'N';
EXEC :REFUND_BY_CRN := 'Y';
EXEC :REFUND_BY_TOTAL  := NULL;
EXEC :TERM_CODE := '202120';

BEGIN
    sb_term.p_update(p_term_code              => :TERM_CODE,
                     p_fee_assessment         => :ONLINE_FEE_ASSESSMENT,
                     p_refund_ind             => :REFUND_BY_TOTAL,
                     p_bycrn_ind              => :REFUND_BY_CRN);
  
  END;
EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20000,
                            'This part is only visible in the logs and for users with a debug role. @USERMESSAGE:' ||
                            SQLERRM);
END;
/
