SELECT
    reports_assessments.assessment_id AS assessment_event_id,
    reports_assessments.trainee_id AS user_id,
    reports_users.first_name,
    reports_users.last_name,
    reports_users.pgy,
    reports_assessments.phase,
    -- fields for filtering
    reports_users.program_id,
    reports_assessments.assessment_completion_date
FROM derived_tables.reports_assessments AS reports_assessments
INNER JOIN derived_tables.reports_users AS reports_users ON (
    reports_assessments.trainee_id = reports_users.user_id
)
