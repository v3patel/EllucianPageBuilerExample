create or replace FUNCTION                   base64encode(p_blob IN BLOB)
  RETURN CLOB
IS
  /******************************************************************************
     NAME:      base64encode
     PURPOSE:   Encode blob to clob base64

     REVISIONS:
     Ver        Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     8.0        06/15/2019  Rogelio Vargas   Initial Creation.

  ******************************************************************************/
  l_clob CLOB := NULL;
  l_step PLS_INTEGER := 12000; -- make sure you set a multiple of 3 not higher than 24573
BEGIN
    IF p_blob IS NOT NULL THEN
        FOR i IN 0 .. TRUNC((DBMS_LOB.getlength(p_blob) - 1 )/l_step) LOOP
        l_clob := l_clob || translate( UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(DBMS_LOB.substr(p_blob, l_step, i * l_step + 1))), chr(10)||chr(13), '  ');
        END LOOP;
    END IF;
    RETURN l_clob;
END;