SELECT
    first_name,
    last_name,
    1.0 * COUNT(assessment_completion_date) / COUNT(assessment_id) AS response_rate,
    1.0 * COUNT(feedback_bool) / COUNT(assessment_completion_date) AS feedback_rate,
    COUNT(assessment_completion_date) AS evlautions
FROM abs_reports.faculty_overview
WHERE
    program_id = filter_program
    AND assessment_completion_date >= filter_cutoff_date
GROUP BY user_id, first_name, last_name
ORDER BY evaluations DESC