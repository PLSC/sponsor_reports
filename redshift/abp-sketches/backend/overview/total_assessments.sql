-- note here that we can just run a count(*) for this
-- ie, not counting the trainee + attending scoring as separate events
SELECT
    -- for counting
    abp_reports_assessments.assessment_event_id,
    -- for bucketing
    abp_reports_assessments.assessment_completion_date,
    -- for filtering
    abp_reports_users.program_id
FROM abp_reports.abp_reports_assessments AS abp_reports_assessments
-- assuming the program of an assessment should be determined by trainee
INNER JOIN abp_reports.abp_reports_users AS abp_reports_users ON (
    abp_reports_assessments.trainee_id = abp_reports_users.user_id
)
WHERE assessment_completion_date IS NOT NULL