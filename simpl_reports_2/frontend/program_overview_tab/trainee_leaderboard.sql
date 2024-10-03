SELECT
    first_name,
    last_name,
    pgy,
    COUNT(*) AS evaluations,
    COUNT(
        CASE
            WHEN reports_assessments.phase = 'Preoperative'
            THEN 1
            ELSE 0
        END
    ) AS pre,
    COUNT(
        CASE
            WHEN reports_assessments.phase = 'Intraoperative'
            THEN 1
            ELSE 0
        END
    ) AS intra,
    COUNT(
        CASE
            WHEN reports_assessments.phase = 'Postoperative'
            THEN 1
            ELSE 0
        END
    ) AS post,
    COUNT(
        CASE
            WHEN reports_assessments.phase = 'Other'
            THEN 1
            ELSE 0
        END
    ) AS other,
FROM abs_reports.trainee_overview
WHERE
    program_id = filter_program
    AND assessment_completion_date >= filter_cutoff_date
GROUP BY user_id, first_name, last_name, pgy
ORDER BY evaluations DESC