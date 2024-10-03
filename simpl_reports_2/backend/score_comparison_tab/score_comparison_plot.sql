WITH attending_evaluations AS (
    SELECT
        reports_assessments.activity_date,
        -- we need to roll up to one observation per timestamp
        -- trainees can have multiple raters per activity
        AVG(reports_assessments.entrustability_score) AS entrustability_score,
        -- for filtering
        reports_assessments.trainee_id,
        reports_assessments.activity_name,
        reports_assessments.phase,
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
    GROUP BY
        reports_assessments.activity_date,
        reports_assessments.trainee_id,
        reports_assessments.activity_name,
        reports_assessments.phase,
        reports_users.program_id
    ORDER BY reports_assessments.activity_date
),

self_evaluations AS (
    SELECT
        reports_self_assessments.activity_date,
        -- we need to roll up to one observation per timestamp
        -- this should be very uncommon for a trainee
        AVG(reports_self_assessments.entrustability_score) AS entrustability_score,
        -- for filtering
        reports_self_assessments.trainee_id,
        reports_self_assessments.activity_name,
        reports_self_assessments.phase,
        reports_users.program_id
    FROM derived_tables.reports_self_assessments AS reports_self_assessments
    INNER JOIN derived_tables.reports_users AS reports_users ON (
        reports_self_assessments.trainee_id = reports_users.user_id
    )
    WHERE
        -- we should only get completed evals
        -- also need to filter out string vals for calculating on INT later
        reports_self_assessments.assessment_completion_date IS NOT NULL
        AND reports_self_assessments.entrustability_score != 'None'
        AND reports_self_assessments.entrustability_score != ''
        AND reports_self_assessments.entrustability_score != 'Indirect Supervision'
    GROUP BY
        reports_self_assessments.activity_date,
        reports_self_assessments.trainee_id,
        reports_self_assessments.activity_name,
        reports_self_assessments.phase,
        reports_users.program_id
)

-- includes only paired scores
-- this simplifies the query, and the point of the display is to compare scores given
SELECT
    attending_evaluations.activity_date AS dt,
    attending_evaluations.entrustability_score AS attending_entrustability_score,
    self_evaluations.entrustability_score AS self_entrustability_score,
    -- for filtering
    attending_evaluations.trainee_id,
    attending_evaluations.activity_name,
    attending_evaluations.phase,
    attending_evaluations.program_id
FROM attending_evaluations
INNER JOIN self_evaluations ON (
    attending_evaluations.activity_date = self_evaluations.activity_date
    AND attending_evaluations.activity_name = self_evaluations.activity_name
)

