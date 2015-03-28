-- SELECT DISTINCT all_evidence.observation_group_id,
--   all_evidence.employee_id_observer,
--   all_evidence.employee_id_learner
--  FROM all_evidence;
   
/* Insert observation_read records for Reader 1a.  Evenly distribute reads among readers who have been designated as 1a */
INSERT INTO observation_reads (observation_group_id,employee_id_observer,employee_id_learner,reader_number,reader_id,document_quality,document_alignment,observation_status)
SELECT observation_group_id, employee_id_observer, employee_id_learner, reader_number, readers.id AS reader_id, 1 AS document_quality, 1 AS document_alignment,2 AS observation_status
	FROM (
		SELECT DISTINCT observation_group_id, employee_id_observer, employee_id_learner, '1a' AS reader_number
		, ROW_NUMBER() OVER(ORDER BY observation_group_id) -1  AS obs_num 
		FROM vw_all_observations obs
			WHERE 1=1
			AND observation_group_id NOT IN (  --This is error checking code to prevent creating duplicate observation_reads
				SELECT DISTINCT observation_group_id FROM observation_reads WHERE reader_number = '1a'
			)
			AND (SELECT COUNT(*) FROM all_evidence evd WHERE evd.observation_group_id = obs.observation_group_id) > 10 --If the observer tagged less than 10 pieces of evidence it's probably bad data and shouldn't be read
			
	) obs
	LEFT JOIN (SELECT *
		, ROW_NUMBER() OVER(ORDER BY employee_number) -1 AS reader_num
		FROM readers
		WHERE is_reader1a = '1'
	) readers	--This uses the modulo operator to equitably distribute the reads
		ON obs.obs_num % (SELECT CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END FROM readers WHERE is_reader1a = '1') = readers.reader_num;

/* Assign Reader 1b - this code is duplicated from above except that it filters on 1b instead of 1a */	
INSERT INTO observation_reads (observation_group_id,employee_id_observer,employee_id_learner,reader_number,reader_id,document_quality,document_alignment,observation_status)
SELECT observation_group_id, employee_id_observer, employee_id_learner, reader_number, readers.id AS reader_id, 1 AS document_quality, 1 AS document_alignment,2 AS observation_status
	FROM (
		SELECT DISTINCT observation_group_id, employee_id_observer, employee_id_learner, '1b' AS reader_number
		, ROW_NUMBER() OVER(ORDER BY observation_group_id) -1  AS obs_num 
		FROM vw_all_observations obs
			WHERE 1=1
			AND observation_group_id NOT IN ( 
			SELECT DISTINCT observation_group_id FROM observation_reads WHERE reader_number = '1b'
			)
			AND (SELECT CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END FROM all_evidence evd WHERE evd.observation_group_id = obs.observation_group_id) > 10
			--AND Employee_ID_Coach NOT IN (SELECT EmployeeNumber FROM RTStaged.dbo.observer_exemptions)
	) obs
	LEFT JOIN (SELECT *
		, ROW_NUMBER() OVER(ORDER BY employee_number) -1  AS reader_num
		FROM readers
		WHERE is_reader1b = '1'
	) readers
		ON obs.obs_num % (SELECT CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END  FROM readers WHERE is_reader1b = '1') = readers.reader_num;

/* Assign Reader 2 */	
INSERT INTO observation_reads (observation_group_id,employee_id_observer,employee_id_learner,reader_number,reader_id,document_quality,document_alignment,observation_status)
SELECT observation_group_id, employee_id_observer, employee_id_learner, reader_number, readers.id AS reader_id, 1 AS document_quality, 1 AS document_alignment,1 AS observation_status
	FROM (
		SELECT DISTINCT observation_group_id, employee_id_observer, employee_id_learner, '2' AS reader_number
		, ROW_NUMBER() OVER(ORDER BY observation_group_id) -1  AS obs_num 
		FROM vw_all_observations obs
			WHERE 1=1
			AND observation_group_id NOT IN ( 
			SELECT DISTINCT observation_group_id FROM observation_reads WHERE reader_number = '2'
			)
			AND (SELECT COUNT(*) FROM all_evidence evd WHERE evd.observation_group_id = obs.observation_group_id) > 10
			--AND Employee_ID_Coach NOT IN (SELECT EmployeeNumber FROM RTStaged.dbo.observer_exemptions)
	) obs
	LEFT JOIN (SELECT *
		, ROW_NUMBER() OVER(ORDER BY employee_number) -1  AS reader_num
		FROM readers
		WHERE is_reader2 = '1'
	) readers
		ON obs.obs_num % (SELECT COUNT(*) FROM readers WHERE is_reader2 = '1') = readers.reader_num; 

/* POPULATE DOMAIN SCORES - Currently not using domain 5 in the reader tool.  Only create domain_scores for the
appropriate 1a/1b/2 reader */

INSERT INTO domain_scores (observation_read_id,domain_id)

SELECT obs.id AS observation_read_id, dom.id AS domain_id
FROM observation_reads obs
CROSS JOIN domains dom
LEFT JOIN domain_scores domcheck
	ON obs.id = domcheck.observation_read_id AND dom.id = domcheck.domain_id
WHERE obs.reader_number = '1a'
	AND dom.id IN('1', '4') --1a only reads doms 1 & 4
	AND domcheck.id IS NULL

		
UNION 

SELECT obs.id AS observation_reads_id, dom.id AS domain_id
FROM observation_reads obs
CROSS JOIN domains dom
LEFT JOIN domain_scores domcheck
	ON obs.id = domcheck.observation_read_id AND dom.id = domcheck.domain_id
WHERE obs.reader_number = '1b'
	AND dom.id  IN('2', '3') --1b only reads doms 2 & 3
	AND domcheck.id IS NULL

UNION

SELECT  obs.id AS observation_reads_id, dom.id AS domain_id
FROM observation_reads obs
CROSS JOIN domains dom
LEFT JOIN domain_scores domcheck
	ON obs.id = domcheck.observation_read_id AND dom.id = domcheck.domain_id
WHERE obs.reader_number = '2'
	AND dom.id <> '5'
	AND domcheck.id IS NULL;

/* POPULATE INDICATOR SCORES - Currently not using domain 5 and only 4.1A and 4.1B from dom 4 */
	INSERT INTO indicator_scores (domain_score_id, indicator_id, alignment_score,comments)
	SELECT doms.id AS domain_score_id, ind.id AS indicator_id, NULL as alignment_score, null as comments
	FROM Observation_Reads obs
	LEFT JOIN domain_scores doms
		ON doms.observation_read_id = obs.id
	INNER JOIN domains dom
		ON doms.domain_id = dom.id
	INNER JOIN indicators ind
		ON ind.domain_id = dom.id
	LEFT JOIN indicator_scores indcheck
		ON doms.id = indcheck.domain_score_id AND ind.id = indcheck.indicator_id
	WHERE ind.domain_id <> '5'
		AND (ind.domain_id <> '4' OR ind.Code in('4.1A', '4.1B')) 
		AND indcheck.id IS NULL;

/* Generate evidence scores.  Join to other tables to ensure the correct id is inserted */
INSERT INTO evidence_scores(evidence_id,indicator_score_id,description,quality,alignment)
SELECT evid.evidence_id AS evidence_id, inds.id AS indicator_score_id, evid.evidence AS description, '1' AS quality, '1' AS alignment
FROM Observation_Reads obs
LEFT JOIN domain_scores dom
	ON dom.observation_read_id = obs.id
LEFT JOIN indicator_scores inds
	ON inds.domain_score_id = dom.id
LEFT JOIN indicators ind
	ON inds.indicator_id = ind.id
INNER JOIN all_evidence evid
	ON obs.observation_group_id = evid.observation_group_id AND LEFT(evid.indicator_code,3) || RIGHT(evid.indicator_code,1) = ind.Code --Bloomboard uses two dots while we use one (1.1.A vs 1.1A)
LEFT JOIN evidence_scores evdcheck
	ON inds.id = evdcheck.indicator_score_id AND evid.evidence_id = evdcheck.evidence_id
WHERE  evdcheck.id IS NULL
