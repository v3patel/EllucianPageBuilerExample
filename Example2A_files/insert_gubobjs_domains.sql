/*
gubobjs.gubobjsUiVersion="A"=All (Banner8 & Banner9)
gubobjs.gubobjsUiVersion="B"=Banner8 Only
gubobjs.gubobjsUiVersion="C"=Banner9 Only
gubobjs.gubobjsUiVersion="D"=Unified Menu All (Ban8&Ban9)
gubobjs.gubobjsUiVersion="E"=Unified Menu Ban9 Only
*/


connect general/&&general_password


INSERT INTO GUBOBJS
(GUBOBJS_NAME,
GUBOBJS_DESC, 
GUBOBJS_OBJT_CODE,
GUBOBJS_SYSI_CODE, 
GUBOBJS_USER_ID,
GUBOBJS_ACTIVITY_DATE,
GUBOBJS_HELP_IND, 
GUBOBJS_EXTRACT_ENABLED_IND, 
GUBOBJS_UI_VERSION)
SELECT 
'ELIVE_EXAMPLE2A_TERM_BASE_LIST',
'ELIVE Example 2 base term w date',
'FORM',
'G',
USER,
SYSDATE,
'N',
'N',
'D'
FROM DUAL
WHERE NOT EXISTS
(SELECT NULL FROM GUBOBJS WHERE GUBOBJS_NAME = 'ELIVE_EXAMPLE2A_TERM_BASE_LIST');

PROMPT add grants to tables used by domain
GRANT SELECT,UPDATE on SOBTERM TO BAN_DEFAULT_PAGEBUILDER_M; 

PROMPT add grants to pl/sql API  used by domain
GRANT EXECUTE  on SB_TERM TO BAN_DEFAULT_PAGEBUILDER_M; 

PROMPT

COMMIT;
