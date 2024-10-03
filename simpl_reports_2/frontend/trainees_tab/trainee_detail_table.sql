SELECT
    first_name,
    last_name,
    pgy,
    trainee_type,
    COUNT(*) AS total_evaluations,
    1.0 * COUNT(creator_bool) / COUNT(*) AS intition_rate,
    MAX(assessment_completion_date) AS latest_completed_assessment,
    email
FROM abs_reports.trainee_detail
WHERE
    program_id = filter_program
    AND assessment_creaion_date >= filter_cutoff_date
GROUP BY
    user_id,
    first_name,
    last_name,
    pgy,
    trainee_type
ORDER BY last_name DESC