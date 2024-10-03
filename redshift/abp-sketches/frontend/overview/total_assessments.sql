SELECT
    COUNT(*),
    DATE_TRUNC('week', assessment_completion_date)
FROM abp_reports.abp_reports_assessments AS abp_reports_assessments
INNER JOIN abp_reports.abp_reports_users AS abp_reports_users ON (
    abp_reports_assessments.trainee_id = abp_reports_users.user_id
)
WHERE 
    abp_reports_users.program_id = ?programid
    AND assessment_completion_date >= ?filter_start_date
    AND assessment_completion_date < ?filter_end_date
GROUP BY DATE_TRUNC('week', assessment_completion_date)
ORDER BY DATE_TRUNC('week', assessment_completion_date) DESC