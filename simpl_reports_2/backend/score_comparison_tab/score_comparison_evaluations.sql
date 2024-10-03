SELECT
    -- for pk
    reports_assessments.assessment_event_id,
    reports_assessments.activity_date,
    reports_users.first_name AS rater_first_name,
    reports_users.last_name AS rater_last_name,
    reports_assessments.activity_name,
    reports_assessments.entrustability_score,
    reports_assessments.complexity_score,
    reports_assessments.feedback_text,
    -- for filtering
    reports_assessments.trainee_id,
    reports_users.program_id
FROM derived_tables.reports_assessments AS reports_assessments
INNER JOIN derived_tables.reports_users ON (
    reports_assessments.attending_id = reports_users.user_id
)
-- only get scored assessments
WHERE reports_assessments.assessment_completion_date IS NOT NULL
ORDER BY reports_assessments.activity_date
