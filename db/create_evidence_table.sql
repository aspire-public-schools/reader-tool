DROP TABLE all_evidence CASCADE;

CREATE TABLE all_evidence
(
  Observation_Group_ID integer,
  employee_ID_observer character varying(50),
  observer_name character varying(100),
  employee_id_learner character varying(50),
  evidence_id integer,
  evidence text,
  Indicator_Code character varying(20)
)
WITH (
  OIDS=FALSE
);
