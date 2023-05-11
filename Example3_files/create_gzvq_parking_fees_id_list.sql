connect baninst1/&&baninst1_password
CREATE OR REPLACE VIEW GZVQ_PARKING_FEES_ID_LIST 
(BANNER_ID, BANNER_PIDM, FIRST_NAME, LAST_NAME)
AS
select spriden_id, spriden_pidm, spriden_first_name, spriden_last_name
  from spriden
 where spriden_change_ind is null
   and exists (select null
          from tbraccd
         where tbraccd_pidm = spriden_pidm
           and tbraccd_detail_code = 'PARK');

CREATE OR REPLACE PUBLIC SYNONYM GZVQ_PARKING_FEES_ID_LIST FOR BANINST1.GZVQ_PARKING_FEES_ID_LIST;