SELECT
    first_name,
    last_name,
    pgy AS trainee_pgy,
    COUNT(*) AS total_assessments,
    SUM(creator_bool) * 1.0 / COUNT(*) AS initiation_rate,
    COUNT(DISTINCT setting) AS unique_settings
FROM abp_reports.trainee_table
WHERE 
    program_id = ?programid
    AND assessment_completion_date >= ?filter_start_date
    AND assessment_completion_date < ?filter_end_date
GROUP BY
    user_id,
    first_name,
    last_name,
    pgy
