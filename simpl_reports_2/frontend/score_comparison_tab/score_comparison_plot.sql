SELECT
    dt,
    attending_entrustability_score,
    self_entrustability_score
FROM abs_reports.score_comparison_plot
WHERE
    dt > filter_cutoff_date
    AND trainee_id = filter_trainee_id
    AND activity_name = filter_activity_name
    AND phase = filter_phase
    AND program_id = filter_program_id