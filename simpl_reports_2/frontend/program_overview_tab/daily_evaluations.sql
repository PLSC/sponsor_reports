SELECT
    total_evaluations,
    dt
FROM abs_reports.daily_evaluations
WHERE
    program_id = filter_program
    AND dt >= filter_cutoff_date
