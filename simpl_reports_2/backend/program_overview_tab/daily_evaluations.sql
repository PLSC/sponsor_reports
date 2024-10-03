SELECT
    reports_users.program_id,
    COUNT(*) AS total_evaluations,
    CAST(reports_assessments.assessment_completion_date AS date) AS dt
FROM derived_tables.reports_assessments AS reports_assessments
INNER JOIN derived_tables.reports_users AS reports_users ON (
    reports_assessments.trainee_id = reports_users.user_id
)
WHERE dt IS NOT NULL
GROUP BY reports_users.program_id, dt
ORDER BY dt DESC