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

evaluations AS (
    -- just getting the correct evals for now - can do windowing and scoring later
    SELECT
        -- program
        institution.name AS institution_name,
        program.name AS program_name,
        -- programID
        program.id AS program_id,
        -- caseID
        activityevent.id AS activityevent_id,
        -- procID
        assessmentevent.assessmentid AS assessment_id,
        -- evaluationID
        assessmentevent.id AS assessmentevent_id,
        -- raterID
        assessmentevent.rateruserid AS rater_user_id,
        -- subjectID
        assessmentevent.subjectuserid AS subject_user_id,
        -- subjectRole
        activityparticipant.currentrole AS current_role,
        -- subjectCurrentPGY
        activityparticipant.currentpgy AS current_pgy,
        -- traineeType
        programmembership.traineetype AS trainee_type,
        -- complexity, supervision
        complexity_scores.complexity_score,
        entrustability_scores.entrustability_score,
        CASE
            WHEN complexity_scores.complexity_score = 1
            THEN 'Straightforward'
            WHEN complexity_scores.complexity_score = 2
            THEN 'Moderate'
            WHEN complexity_scores.complexity_score = 3
            THEN 'Complex'
            ELSE NULL
        END AS complexity_readable,
        CASE
            WHEN entrustability_scores.entrustability_score = 1
            THEN 'Limited Participation'
            WHEN entrustability_scores.entrustability_score = 2
            THEN 'Direct Supervision'
            WHEN entrustability_scores.entrustability_score = 3
            THEN 'Indirect Supervision'
            WHEN entrustability_scores.entrustability_score = 4
            THEN 'Practice Ready'
            ELSE NULL
        END AS entrustability_readable,
        -- hasDictation
        feedback.feedback_text,
        -- procName
        assessment.title AS assessment_title,
        -- procStartTime
        activityevent.activityeventdate AS activityevent_date,
        -- evalCompleted
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
    -- for filtering by sponsor
    INNER JOIN simpl2.networkprogram AS networkprogram ON program.id = networkprogram.programid
    INNER JOIN simpl2.network AS network ON networkprogram.networkid = network.id
    INNER JOIN simpl2.sponsor AS sponsor ON network.sponsorid = sponsor.id
    -- gets assessment responses / scores from subclauses
    LEFT JOIN complexity_scores ON assessmentevent.id = complexity_scores.assessmenteventid
    LEFT JOIN entrustability_scores ON assessmentevent.id = entrustability_scores.assessmenteventid
    LEFT JOIN feedback ON assessmentevent.id = feedback.assessmenteventid
    -- gets trainee type - attending / admin will be blank
    LEFT JOIN simpl2.programmembership AS programmembership ON (
        assessmentevent.subjectuserid = programmembership.programmemberid
        AND program.id = programmembership.programid
    )
    WHERE sponsor.name = 'ABS'
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