SELECT
    score_comparison.date,
    attending_practice_readiness_score,
    trainee_practice_readiness_score
FROM abp_reports.score_comparison AS score_comparison
WHERE
    trainee_id = ?trainee_id
    AND activity_name = ?filter_activity_name
    AND score_comparison.date >= ?filter_start_date
    AND score_comparison.date < ?filter_end_date