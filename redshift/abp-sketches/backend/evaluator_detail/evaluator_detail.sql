WITH evaluator_counts AS (
    SELECT
        abp_reports_users.user_id,
        abp_reports_users.first_name,
        abp_reports_users.last_name,
        COUNT(*) AS total_assessments,
        SUM(
            CASE
                WHEN abp_reports_assessments.creator_id = abp_reports_assessments.attending_id
                THEN 1
                ELSE 0
            END
        ) AS initiated_count,
        SUM(
            CASE
                WHEN abp_reports_assessments.assessment_completion_date IS NOT NULL
                THEN 1
                ELSE 0
            END
        ) AS response_count,
        MAX(abp_reports_assessments.assessment_completion_date) AS last_assessment_date,
        abp_reports_users.email
    FROM abp_reports.abp_reports_users AS abp_reports_users
    INNER JOIN abp_reports.abp_reports_assessments AS abp_reports_assessments ON (
        abp_reports_users.user_id = abp_reports_assessments.attending_id
    )
    GROUP BY
        abp_reports_users.user_id,
        abp_reports_users.first_name,
        abp_reports_users.last_name,
        abp_reports_users.email
)

SELECT
    user_id AS attending_id,
    first_name,
    last_name,
    total_assessments,
    initiated_count * 1.0 / total_assessments AS intitiation_rate,
    response_count * 1.0 / total_assessments AS response_rate,
    last_assessment_date,
    email
FROM evaluator_counts
ORDER BY
    last_name ASC,
    first_name ASC