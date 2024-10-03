SELECT
    reports_assessments.assessment_event_id,
    reports_assessments.trainee_id AS user_id,
    reports_users.first_name,
    reports_users.last_name,
    reports_assessments.attending_id,
    reports_assessments.activity_name,
    reports_assessments.phase,
    reports_assessments.entrustability_score,
    reports_assessments.assessment_completion_date,
    -- for filtering
    reports_users.program_id
FROM derived_tables.reports_assessments AS reports_assessments
INNER JOIN derived_tables.reports_users AS reports_users ON (
    reports_assessments.trainee_id = reports_users.user_id
)
WHERE
    -- we should only get completed evals
    -- also need to filter out string vals for calculating on INT later
    reports_assessments.assessment_completion_date IS NOT NULL
    AND reports_assessments.entrustability_score != 'None'
    AND reports_assessments.entrustability_score != ''