SELECT
    CAST(assessment_completion_date AS date) AS dt,
    COUNT(*)
FROM abs_reports.trainee_epa_detail
WHERE
    user_id = filter_user
    AND program_id = filter_program
    AND assessment_completion_date >= filter_cutoff_date
GROUP BY dt
ORDER BY dt DESC