CREATE TABLE IF NOT EXISTS all_evidence 
(
  observation_group_id integer,
  employee_id_observer character varying(50),
  observer_name character varying(100),
  employee_id_learner character varying(50),
  evidence_id integer,
  evidence text,
  indicator_code character varying(20)
)
WITH (
  OIDS=FALSE
);

CREATE OR REPLACE VIEW vw_all_observations AS 
SELECT DISTINCT all_evidence.observation_group_id,
   all_evidence.employee_id_observer,
   all_evidence.employee_id_learner
  FROM all_evidence;
