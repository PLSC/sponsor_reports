SELECT
    activity_date AS date,
    first_name AS rater_first_name,
    last_name AS rater_last_name,
    activity_name AS epa,
    entrustability_score,
    complexity_score,
    feedback_text
FROM abs_reports.score_comparison_evaluations
WHERE
    trainee_id = filter_trainee_id
    AND program_id = filter_program_id
    AND activity_name = filter_activity_name
    AND activity_date > filter_cutoff_date