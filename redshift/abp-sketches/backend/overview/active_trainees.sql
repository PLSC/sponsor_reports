SELECT
    abp_reports_users.user_id,
    abp_reports_users.program_id,
    abp_reports_users.invite_sent AS invite_date,
    abp_reports_users.registered AS registration_date,
    MAX(abp_reports_assessments.assessment_completion_date) AS last_completed_assessment_date
FROM abp_reports.abp_reports_users AS abp_reports_users
INNER JOIN abp_reports.abp_reports_assessments AS abp_reports_assessments ON (
    abp_reports_users.user_id = abp_reports_assessments.trainee_id
)
WHERE abp_reports_users.type = 'Trainee'
GROUP BY 
    abp_reports_users.user_id,
    abp_reports_users.program_id,
    abp_reports_users.invite_sent,
    abp_reports_users.registered