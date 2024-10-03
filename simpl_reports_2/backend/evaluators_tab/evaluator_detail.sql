SELECT
    reports_assessments.assessment_event_id,
    reports_assessments.attending_id AS user_id,
    reports_users.first_name,
    reports_users.last_name,
    CASE
        WHEN reports_assessments.creator_id = reports_assessments.attending_id
        THEN 1
        ELSE 0
    END AS creator_bool,
    reports_assessments.feedback_bool,
    reports_assessments.assessment_completion_date,
    reports_users.email,
    -- fields for filtering
    reports_users.program_id,
    reports_assessments.activity_date AS assessment_creation_date
FROM derived_tables.reports_assessments AS reports_assessments
INNER JOIN derived_tables.reports_users AS reports_users ON (
    reports_assessments.attending_id = reports_users.user_id
)
WHERE reports_users.type = 'Attending'