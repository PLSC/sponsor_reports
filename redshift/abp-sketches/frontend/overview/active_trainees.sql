SELECT
    SUM(
        CASE
            WHEN 
                last_completed_assessment >= ?filter_start_date
                AND last_completed_assessment < ?filter_end_date
            THEN 1
            ELSE 0
        END
    ) AS active_trainees,
    SUM(
        CASE
            WHEN 
                last_completed_assessment < ?filter_start_date
                OR last_completed_assessment >= ?filter_end_date
            THEN 1
            ELSE 0
        END
    ) AS inactive_trainees
FROM abs_reports.active_trainees
WHERE program_id = ?program_id