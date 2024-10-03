SELECT
    SUM(ics) AS sum_ics,
    SUM(pc) AS sum_pc,
    SUM(pbli) AS sum_pbli,
    SUM(mk) AS sum_mk,
    SUM(prof) AS sum_prof,
    SUM(sbp) AS sum_sbp
FROM abs_reports.epa_by_milestone
WHERE
    program_id = filter_program
    AND assessment_completion_date >= filter_cutoff_date