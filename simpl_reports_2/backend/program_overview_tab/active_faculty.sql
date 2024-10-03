SELECT
    reports_users.user_id,
    reports_users.program_id,
    reports_users.invite_sent AS invite_date,
    reports_users.registered AS registration_date,
    MAX(reports_assessments.assessment_completion_date) AS last_completed_assessment_date
FROM derived_tables.reports_users AS reports_users
INNER JOIN derived_tables.reports_assessments AS reports_assessments ON (
    reports_users.user_id = reports_assessments.attending_id
)
WHERE reports_users.type = 'Attending'
GROUP BY 
    reports_users.user_id,
    reports_users.program_id,
    reports_users.invite_sent,
    reports_users.registered