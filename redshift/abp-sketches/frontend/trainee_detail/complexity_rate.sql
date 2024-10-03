SELECT
    SUM(
        CASE
            WHEN complexity_score = 3
            THEN 1
            ELSE 0
        END
    ) * 1.0 / COUNT(*) AS complexity_rate
FROM abp_reports.abp_reports_assessments
WHERE
    trainee_id = ?trainee_id
    AND assessment_completion_date >= ?filter_start_date
    AND assessment_completion_date < ?filter_end_date