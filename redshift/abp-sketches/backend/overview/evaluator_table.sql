SELECT
    abp_reports_users.first_name,
    abp_reports_users.last_name,
    CASE
        WHEN abp_reports_assessments.creator_id = abp_reports_assessments.attending_id 
        THEN 1
        ELSE 0
    END AS creator_bool,
    -- for filtering
    abp_reports_users.program_id,
    abp_reports_assessments.assessment_completion_date
FROM abp_reports.abp_reports_assessments AS abp_reports_assessments
INNER JOIN abp_reports.abp_reports_users AS abp_reports_users ON (
    abp_reports_assessments.attending_id = abp_reports_users.user_id
)