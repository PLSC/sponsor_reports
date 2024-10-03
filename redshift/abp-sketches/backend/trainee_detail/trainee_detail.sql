SELECT
    abp_reports_users.first_name,
    abp_reports_users.last_name,
    abp_reports_users.pgy,
    abp_reports_users.trainee_type,
    -- for counting total_assessments
    abp_reports_assessments.assessment_event_id,
    -- need creator stats for initiation_rate
    CASE
        WHEN abp_reports_assessments.creator_id = abp_reports_assessments.trainee_id
        THEN 1
        ELSE 0
    END AS creator_bool,
    -- for counting settings
    abp_reports_assessments.setting,
    -- for title of last assessment
    abp_reports_assessments.activity_name,
    -- dt of last assessment
    abp_reports_assessments.activity_date,
    abp_reports_users.email
FROM abp_reports.abp_reports_assessments AS abp_reports_assessments
INNER JOIN abp_reports.abp_reports_users AS abp_reports_users ON (
    abp_reports_assessments.trainee_id = abp_reports_users.user_id
)
WHERE abp_reports_assessments.assessment_completion_date IS NOT NULL