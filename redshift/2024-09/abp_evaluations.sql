-- breaking out the scoring results by question type
WITH complexity_scores AS (
    SELECT
        answerevent.assessmenteventid,
        answerevent.value AS complexity_score
    FROM simpl2.answerevent AS answerevent
    INNER JOIN simpl2.question AS question ON answerevent.questionid = question.id
    WHERE
        question.title = 'Complexity'
        AND answerevent.value ~ '^[0-9]{1}'
),

supervision_scores AS (
    SELECT
        answerevent.assessmenteventid,
        answerevent.value AS supervision_score
    FROM simpl2.answerevent AS answerevent
    INNER JOIN simpl2.question AS question ON answerevent.questionid = question.id
    WHERE
        question.title = 'Supervision'
        AND answerevent.value ~ '^[0-9]{1}'
),

practice_readiness_scores AS (
    SELECT
        answerevent.assessmenteventid,
        answerevent.value AS practice_readiness_score
    FROM simpl2.answerevent AS answerevent
    INNER JOIN simpl2.question AS question ON answerevent.questionid = question.id
    WHERE
        question.title = 'Practice Readiness'
        AND answerevent.value ~ '^[0-9]{1}'
),

diagnosis_scores AS (
    SELECT
        answerevent.assessmenteventid,
        answerevent.value AS diagnosis_score
    FROM simpl2.answerevent AS answerevent
    INNER JOIN simpl2.question AS question ON answerevent.questionid = question.id
    WHERE
        question.title = 'Diagnosis'
        -- AND answerevent.value ~ '^[0-9]{1}'
),

feedback AS (
    SELECT
        answerevent.assessmenteventid,
        answerevent.value AS feedback_text
    FROM simpl2.answerevent AS answerevent
    INNER JOIN simpl2.question AS question ON answerevent.questionid = question.id
    WHERE
        question.title = 'Feedback'
),

evaluations AS (
    -- just getting the correct evals for now - can do windowing and scoring later
    SELECT
        institution.name AS institution_name,
        program.name AS program_name,
        program.id AS program_id,
        activityevent.id AS activityevent_id,
        assessmentevent.assessmentid AS assessment_id,
        assessmentevent.id AS assessmentevent_id,
        assessmentevent.rateruserid AS rater_user_id,
        assessmentevent.subjectuserid AS subject_user_id,
        activityparticipant.currentrole AS current_role,
        activityparticipant.currentpgy AS current_pgy,
        programmembership.traineetype AS trainee_type,
        complexity_scores.complexity_score,
        supervision_scores.supervision_score,
        practice_readiness_scores.practice_readiness_score,
        diagnosis_scores.diagnosis_score,
        CASE
            WHEN feedback.feedback_text != ''
            THEN '"' || feedback.feedback_text || '"'
            ELSE ''
        END AS feedback_text,
        assessment.title AS assessment_title,
        activityevent.activityeventdate AS activityevent_date,
        assessmentevent.completiondate AS completion_date,
        -- status
        -- if not complete, checking for expiration as status
        (
            CURRENT_TIMESTAMP > assessmentevent.expirationdate
            AND assessmentevent.completiondate IS null
        ) AS expired
    FROM simpl2.assessmentevent AS assessmentevent
    -- gets program details
    INNER JOIN simpl2.activityevent AS activityevent ON assessmentevent.activityeventid = activityevent.id
    INNER JOIN simpl2.program AS program ON activityevent.programid = program.id
    INNER JOIN simpl2.institution AS institution ON program.institutionid = institution.id
    -- gets assessment / epa details
    INNER JOIN simpl2.assessment AS assessment ON assessmentevent.assessmentid = assessment.id
    -- gets roles and pgy
    INNER JOIN simpl2.activityparticipant AS activityparticipant ON (
        activityevent.id = activityparticipant.activityeventid
        AND assessmentevent.subjectuserid = activityparticipant.userid
    )
    -- for filtering to abs general surgery
    INNER JOIN simpl2.networkactivity AS networkactivity ON assessmentevent.activityid = networkactivity.activityid
    INNER JOIN simpl2.network AS network ON networkactivity.networkid = network.id
    INNER JOIN simpl2.sponsor AS sponsor ON network.sponsorid = sponsor.id
    -- gets assessment responses / scores from subclauses
    LEFT JOIN complexity_scores ON assessmentevent.id = complexity_scores.assessmenteventid
    LEFT JOIN supervision_scores ON assessmentevent.id = supervision_scores.assessmenteventid
    LEFT JOIN practice_readiness_scores ON assessmentevent.id = practice_readiness_scores.assessmenteventid
    LEFT JOIN diagnosis_scores ON assessmentevent.id = diagnosis_scores.assessmenteventid
    LEFT JOIN feedback ON assessmentevent.id = feedback.assessmenteventid
    -- gets trainee type - attending / admin will be blank
    LEFT JOIN simpl2.programmembership AS programmembership ON (
        assessmentevent.subjectuserid = programmembership.programmemberid
        AND program.id = programmembership.programid
    )
    WHERE 
        network.name = 'Pediatrics'
        AND sponsor.name = 'ABP'
        AND LOWER(institution.name) NOT LIKE '%test%'
        AND LOWER(program.name) NOT LIKE '%test%'
),

-- paired status by rolling up on activityevent_id
paired_evaluations AS (
    SELECT
        evaluations.activityevent_id,
        COUNT(*) AS n_assessments,
        COUNT(evaluations.completion_date) AS n_completed
    FROM evaluations
    -- activityevents comprise all related assessments
    GROUP BY evaluations.activityevent_id
)

SELECT
    -- evetything from evals table
    evaluations.*,
    -- if every eval in an activity is completed, they're all paired
    CASE
        WHEN paired_evaluations.n_assessments = paired_evaluations.n_completed
        THEN 1
        ELSE 0
    END AS paired_status
FROM evaluations
INNER JOIN paired_evaluations ON evaluations.activityevent_id = paired_evaluations.activityevent_id
GROUP BY 
    evaluations.institution_name,
    evaluations.program_name,
    evaluations.program_id,
    evaluations.activityevent_id,
    evaluations.assessment_id,
    evaluations.assessmentevent_id,
    evaluations.rater_user_id,
    evaluations.subject_user_id,
    evaluations.current_role,
    evaluations.current_pgy,
    evaluations.trainee_type,
    evaluations.complexity_score,
    evaluations.supervision_score,
    evaluations.practice_readiness_score,
    evaluations.diagnosis_score,
    evaluations.feedback_text,
    evaluations.assessment_title,
    evaluations.activityevent_date,
    evaluations.completion_date,
    evaluations.expired,
    paired_status