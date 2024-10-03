SELECT
    activity_name,
    phase,
    assessment_completion_date,
    entrustability_score
FROM abs_reports.trainee_epa_detail
WHERE
    user_id = filter_user
    AND activity_name = activity_name_filter
    AND program_id = filter_program
    AND assessment_completion_date >= filter_cutoff_date
ORDER BY assessment_completion_date