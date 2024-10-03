SELECT
    score_comparison.date,
    rater_first_name,
    rater_last_name,
    setting,
    attending_supervision_score,
    attending_practice_readiness_score,
    attending_complexity_score,
    attending_feedback
FROM abp_reports.score_comparison AS score_comparison
WHERE
    trainee_id = ?trainee_id
    AND activity_name = ?filter_activity_name
    AND score_comparison.date >= ?filter_start_date
    AND score_comparison.date < ?filter_end_date