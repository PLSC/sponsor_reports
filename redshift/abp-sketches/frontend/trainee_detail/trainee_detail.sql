SELECT
    first_name,
    last_name,
    pgy AS trainee_pgy,
    trainee_type,
    COUNT(*) AS total_assessments,
    SUM(creator_bool) * 1.0 / COUNT(*) AS initiation_rate,
    COUNT(DISTINCT setting) AS unique_settings,
    MAX(assessment_completion_date) AS last_assessment_submitted,
    MAX(activity_date) AS date_last_assessment,
    email
FROM abp_reports.trainee_detail
WHERE
    program_id = ?programid
    AND assessment_completion_date >= ?filter_start_date
    AND assessment_completion_date < ?filter_end_date
GROUP BY
    trainee_id,
    first_name,
    last_name,
    pgy,
    trainee_type,
    email