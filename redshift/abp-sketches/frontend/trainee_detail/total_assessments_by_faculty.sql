SELECT
    COUNT(*) AS assessments_count,
    DATE_TRUNC('week', assessment_completion_date) AS "week"
FROM abp_reports.abp_reports_assessments
WHERE
    assessment_completion_date IS NOT NULL
    AND trainee_id = ?trainee_id
    AND assessment_completion_date >= ?filter_start_date
    AND assessment_completion_date < ?filter_end_date
GROUP BY DATE_TRUNC('week', assessment_completion_date)
ORDER BY DATE_TRUNC('week', assessment_completion_date) DESC
