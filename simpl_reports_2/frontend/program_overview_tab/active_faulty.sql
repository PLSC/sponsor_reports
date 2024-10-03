SELECT
    SUM(
        CASE
            WHEN registration_date IS NULL
            THEN 1
            ELSE 0
        END
    ) AS unregistered,
    SUM(
        CASE
            WHEN registration_date IS NOT NULL
            THEN 1
            ELSE 0
        END
    ) AS registered,
    SUM(
        CASE
            WHEN last_assessment_completion_date IS NOT NULL
            THEN 1
            ELSE 0
        END
    ) AS active
FROM abs_reports.active_faculty
WHERE
    program_id = filter_program
    AND last_assessment_date >= filter_cutoff_date
    AND invite_date >= filter_cutoff_date