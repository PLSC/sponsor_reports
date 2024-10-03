-- breaking out the scoring results by question type
WITH complexity_scores AS (
    SELECT
        answerevent.assessmenteventid,
        answerevent.value AS complexity_score
    FROM simpl2.answerevent AS answerevent
    INNER JOIN simpl2.question AS question ON answerevent.questionid = question.id
    WHERE
        question.title = 'Complexity Score'
),

entrustability_scores AS (
    SELECT
        answerevent.assessmenteventid,
        answerevent.value AS entrustability_score
    FROM simpl2.answerevent AS answerevent
    INNER JOIN simpl2.question AS question ON answerevent.questionid = question.id
    WHERE
        question.title = 'Entrustability Score'
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

-- get unique mapping of milestones and activities
milestone_activity AS (
    SELECT
        LISTAGG(DISTINCT milestone.shortname, ', ') AS shortnames,
        milestonenetworkrating.activityid
    FROM simpl2.milestonenetworkrating AS milestonenetworkrating
    INNER JOIN simpl2.milestone AS milestone ON (
        milestonenetworkrating.milestoneid = milestone.id
    )
    GROUP BY 
        milestonenetworkrating.activityid
)

-- only attending assessments of trainee
SELECT
    assessmentevent.id AS assessment_event_id,
    assessmentevent.rateruserid AS attending_id,
    assessmentevent.subjectuserid AS trainee_id,
    assessmentevent.activityid AS activity_id,
    activity.title AS activity_name,
    milestone_activity.shortnames AS milestones,
    -- case for determining select phases
    CASE
        -- pre
        WHEN LOWER(title) LIKE '%preoperative'
        THEN 'Preoperative'
        WHEN LOWER(title) LIKE '%nonoperative\/preoperative'
        THEN 'Preoperative'
        -- there is one procedure with a trailing space
        WHEN LOWER(title) LIKE '%nonoperative\/preoperative '
        THEN 'Preoperative'
        WHEN LOWER(title) LIKE '%preprocedure'
        THEN 'Preoperative'
        -- intra
        WHEN LOWER(title) LIKE '%intraoperative'
        THEN 'Intraoperative'
        WHEN LOWER(title) LIKE '%intraprocedure'
        THEN 'Intraoperative'
        WHEN LOWER(title) LIKE '%intraoperative endovascular'
        THEN 'Intraoperative'
        WHEN LOWER(title) LIKE '%intraoperative open'
        THEN 'Intraoperative'
        -- post
        WHEN LOWER(title) LIKE '%postoperative'
        THEN 'Postoperative'
        WHEN LOWER(title) LIKE '%-postprocedure'
        THEN 'Postoperative'
        -- other phases exist, but abs is only asking for pre/intra/post/other
        ELSE 'Other'
    END AS phase,
    activityevent.creatorid AS creator_id,
    -- assuming record creation date is when activity happened
    activityevent.createdat AS activity_date,
    -- assuming we're only concerned about the attending's completed date here
    -- bc we're only using scores from the attending
    assessmentevent.completiondate AS assessment_completion_date,
    entrustability_scores.entrustability_score,
    complexity_scores.complexity_score,
    CASE
        WHEN LENGTH(feedback.feedback_text) > 0
        THEN 1
        ELSE 0
    END AS feedback_bool,
    feedback.feedback_text
FROM simpl2.assessmentevent AS assessmentevent
INNER JOIN simpl2.activity AS activity ON assessmentevent.activityid = activity.id
INNER JOIN simpl2.activityevent AS activityevent ON (
    assessmentevent.activityeventid = activityevent.id
)
LEFT JOIN complexity_scores ON (
    assessmentevent.id = complexity_scores.assessmenteventid
)
LEFT JOIN entrustability_scores ON (
    assessmentevent.id = entrustability_scores.assessmenteventid
)
LEFT JOIN feedback ON (
    assessmentevent.id = feedback.assessmenteventid
)
INNER JOIN milestone_activity ON (
    assessmentevent.activityid = milestone_activity.activityid
)
WHERE
    -- if raterid = subjectid, we're looking at the trainee's self eval
    assessmentevent.rateruserid = assessmentevent.subjectuserid