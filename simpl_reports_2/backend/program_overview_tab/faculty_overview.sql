SELECT
    -- user details
    reports_assessments.attending_id AS user_id,
    reports_users.first_name,
    reports_users.last_name,
    -- fields for calculating stats
    reports_assessments.assessment_event_id,
    reports_assessments.feedback_bool,
    reports_assessments.assessment_completion_date,
    -- fields for filtering
    reports_users.program_id
FROM derived_tables.reports_assessments AS reports_assessments
INNER JOIN derived_tables.reports_users AS reports_users ON (
    reports_assessments.attending_id = reports_users.user_id
)