SELECT
    SUM(
        CASE
            WHEN 
                last_completed_assessment >= ?filter_start_date
                AND last_completed_assessment < ?filter_end_date
            THEN 1
            ELSE 0
        END
    ) AS active_evaluators,
    SUM(
        CASE
            WHEN 
                last_completed_assessment < ?filter_start_date
                OR last_completed_assessment >= ?filter_end_date
            THEN 1
            ELSE 0
        END
    ) AS inactive_evaluators
FROM abs_reports.active_evaluators
WHERE 
    program_id = ?program_id