SELECT
    reports_assessments.assessment_event_id,
    reports_assessments.milestone,
    CASE
        WHEN LOWER(reports_assessments.milestone) LIKE '%ics%'
        THEN 1
        ELSE 0
    END AS ics,
    CASE
        WHEN LOWER(reports_assessments.milestone) LIKE '%pc%'
        THEN 1
        ELSE 0
    END AS pc,
    CASE
        WHEN LOWER(reports_assessments.milestone) LIKE '%pbli%'
        THEN 1
        ELSE 0
    END AS pbli,
    CASE
        WHEN LOWER(reports_assessments.milestone) LIKE '%mk%'
        THEN 1
        ELSE 0
    END AS mk,
    CASE
        WHEN LOWER(reports_assessments.milestone) LIKE '%prof%'
        THEN 1
        ELSE 0
    END AS prof,
    CASE
        WHEN LOWER(reports_assessments.milestone) LIKE '%sbp%'
        THEN 1
        ELSE 0
    END AS sbp,
    reports_assessments.assessment_completion_date,
    reports_users.program_id
FROM derived_tables.reports_assessments AS reports_assessments
INNER JOIN derived_tables.reports_users AS reports_users ON (
    reports_assessments.trainee_id = reports_users.user_id
)