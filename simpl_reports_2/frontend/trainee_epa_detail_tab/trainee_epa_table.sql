SELECT
    activity_name AS epa,
    phase,
    AVG(entrustability_score) AS entrustability_rating,
    COUNT(*) AS evaluations,
    COUNT(DISTINCT attending_id) AS raters
FROM abs_reports.trainee_epa_detail
WHERE
    user_id = filter_user
    AND program_id = filter_program
    AND assessment_completion_date >= filter_date
GROUP BY activity_name, phase
ORDER BY activity_name DESC