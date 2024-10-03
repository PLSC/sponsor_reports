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
)

-- only attending assessments of trainee
SELECT
    assessmentevent.id AS assessment_event_id,
    assessmentevent.rateruserid AS attending_id,
    assessmentevent.subjectuserid AS trainee_id,
    assessmentevent.activityid AS activity_id,
    activity.title AS activity_name,
    -- case for determining select settings
    CASE
        -- Primary Care Clinic 
        WHEN LOWER(activity.title) LIKE '%(primary care clinic)%'
        THEN 'Primary Care Clinic'
        -- Emergency Department
        WHEN LOWER(activity.title) LIKE '%(ed)%'
        THEN 'Emergency Department'
        -- Hospitalist/Gen Peds Inpt
        WHEN LOWER(activity.title) LIKE '%(hospitalist/gp inpatient)%'
        THEN 'Hospitalist/Gen Peds Inpt'
        -- NICU/PICU/Step Down
        WHEN LOWER(activity.title) LIKE '%(nicu/picu)%'
        THEN 'NICU/PICU/Step Down'
        -- Nursery/Delivery Room
        WHEN LOWER(activity.title) LIKE '%(nursery/delivery)%'
        THEN 'Nursery/Delivery Room'
        -- Other Subspeciality
        ELSE 'Other'
    END AS setting,
    activityevent.creatorid AS creator_id,
    -- assuming record creation date is when activity happened
    activityevent.createdat AS activity_date,
    -- assuming we're only concerned about the attending's completed date here
    -- bc we're only using scores from the attending
    assessmentevent.completiondate AS assessment_completion_date,
    complexity_scores.complexity_score,
    diagnosis_scores.diagnosis_score,
    practice_readiness_scores.practice_readiness_score,
    supervision_scores.supervision_score,
    feedback.feedback_text
FROM simpl2.assessmentevent AS assessmentevent
INNER JOIN simpl2.activity AS activity ON assessmentevent.activityid = activity.id
INNER JOIN simpl2.activityevent AS activityevent ON (
    assessmentevent.activityeventid = activityevent.id
)
-- join in score subclauses
LEFT JOIN complexity_scores ON (
    assessmentevent.id = complexity_scores.assessmenteventid
)
LEFT JOIN diagnosis_scores ON (
    assessmentevent.id = diagnosis_scores.assessmenteventid
)
LEFT JOIN practice_readiness_scores ON (
    assessmentevent.id = practice_readiness_scores.assessmenteventid
)
LEFT JOIN supervision_scores ON (
    assessmentevent.id = supervision_scores.assessmenteventid
)
LEFT JOIN feedback ON (
    assessmentevent.id = feedback.assessmenteventid
)
-- joins for ABP sponsor
INNER JOIN simpl2.networkactivity AS networkactivity ON (
    activity.id = networkactivity.activityid
)
INNER JOIN simpl2.network AS network ON (
    networkactivity.networkid = network.id
)
INNER JOIN simpl2.sponsor AS sponsor ON (
    network.sponsorid = sponsor.id
)
WHERE
    -- if raterid != subjectid, we're looking at the attending's eval
    assessmentevent.rateruserid != assessmentevent.subjectuserid
    -- only ABP evals
    AND sponsor.name = 'ABP'
