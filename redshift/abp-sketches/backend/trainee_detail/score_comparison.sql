-- THIS TABLE RETURNS EMPTY BC THERE AREN'T SELF EVALS IN THE DB YET
WITH attending_evaluations AS (
    SELECT
        -- to uniquely join self + attending evals we need
            -- attending_id
            -- trainee_id
            -- activity_date
            -- activity_name
        abp_reports_assessments.attending_id,
        abp_reports_users.first_name AS rater_first_name,
        abp_reports_users.last_name AS rater_last_name,
        abp_reports_assessments.trainee_id,
        abp_reports_assessments.activity_date,
        abp_reports_assessments.supervision_score AS supervision_score,
        abp_reports_assessments.practice_readiness_score AS practice_readiness_score,
        abp_reports_assessments.complexity_score AS complexity_score,
        abp_reports_assessments.feedback_text AS feedback,
        abp_reports_assessments.setting,
        -- for filtering (only one activity + trainee will be chosen in the UI)
        abp_reports_assessments.activity_name
    FROM abp_reports.abp_reports_assessments AS abp_reports_assessments
    INNER JOIN abp_reports.abp_reports_users AS abp_reports_users ON (
        abp_reports_assessments.attending_id = abp_reports_users.user_id
    )
    WHERE
        -- we should only get completed evals
        abp_reports_assessments.assessment_completion_date IS NOT NULL
    ORDER BY abp_reports_assessments.activity_date
),

self_evaluations AS (
    SELECT
        -- same as above, but we only comp for supervision + readiness
        abp_reports_self_assessments.attending_id,
        abp_reports_self_assessments.trainee_id,
        abp_reports_self_assessments.activity_date,
        abp_reports_self_assessments.supervision_score AS supervision_score,
        abp_reports_self_assessments.practice_readiness_score AS practice_readiness_score,
        -- for join to attending evals
        abp_reports_self_assessments.activity_name
    FROM abp_reports.abp_reports_self_assessments AS abp_reports_self_assessments
    WHERE
        -- we should only get completed evals
        abp_reports_self_assessments.assessment_completion_date IS NOT NULL
    ORDER BY abp_reports_self_assessments.activity_date
)

-- includes only paired scores
-- this simplifies the query, and the point of the display is to compare scores given
SELECT
    attending_evaluations.activity_date AS "date",
    attending_evaluations.rater_first_name,
    attending_evaluations.rater_last_name,
    attending_evaluations.setting,
    attending_evaluations.supervision_score AS attending_supervision_score,
    attending_evaluations.practice_readiness_score AS attending_practice_readiness_score,
    attending_evaluations.complexity_score AS attending_complexity_score,
    attending_evaluations.feedback AS attending_feedback,
    self_evaluations.supervision_score AS trainee_supervision_score,
    self_evaluations.practice_readiness_score AS trainee_practice_readiness_score
FROM attending_evaluations
INNER JOIN self_evaluations ON (
    attending_evaluations.activity_date = self_evaluations.activity_date
    AND attending_evaluations.activity_name = self_evaluations.activity_name
    AND attending_evaluations.trainee_id = self_evaluations.trainee_id
    AND attending_evaluations.attending_id = self_evaluations.attending_id
)
