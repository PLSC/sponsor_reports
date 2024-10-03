SELECT
    AVG(supervision_score) AS avg_supervision
FROM abp_reports.abp_reports_assessments
WHERE
    trainee_id = ?trainee_id
    AND assessment_completion_date >= ?filter_start_date
    AND assessment_completion_date < ?filter_end_date