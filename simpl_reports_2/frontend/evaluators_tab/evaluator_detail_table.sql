totals_rollup AS (
    SELECT
        user_id,
        SUM(
            CASE
                WHEN evaluator_detail.assessment_completion_date IS NOT NULL
                THEN 1
                ELSE 0
            END
        ) AS evaluations_completed,
        SUM(
            CASE
                WHEN creator_bool = TRUE
                THEN 1
                ELSE 0
            END
        ) AS evaluations_initiated,
        SUM(
            CASE
                WHEN feedback_bool = TRUE
                THEN 1
                ELSE 0
            END
        ) AS evaluations_with_feedback
    FROM abs_reports.evaluator_detail AS evaluator_detail
    WHERE
        evaluator_detail.program_id = filter_program
        AND evaluator_detail.assessment_creation_date >= filter_cutoff_date
    GROUP BY user_id
)

SELECT
    evaluator_detail.first_name,
    evaluator_detail.last_name,
    totals_rollup.evaluations_completed,
    totals_rollup.evaluations_initiated,
    COUNT(*) AS evaluations_sent,
    1.0 * totals_rollup.evaluations_initiated / COUNT(*) AS completion_rate,
    1.0 * totals_rollup.evaluations_with_feedback / COUNT(*) AS feedback_rate,
    MAX(assessment_completion_date) AS last_assessment_completed,
    email
FROM abs_reports.evaluator_detail AS evaluator_detail
INNER JOIN totals_rollup ON evaluator_detail.user_id = totals_rollup.user_id
WHERE
    evaluator_detail.program_id = filter_program
    AND evaluator_detail.assessment_creation_date >= filter_cutoff_date
GROUP BY
    evaluator_detail.first_name,
    evaluator_detail.last_name,
    totals_rollup.evaluations_completed,
    totals_rollup.evaluations_initiated,
    totals_rollup.evaluations_with_feedback,
    evaluator_detail.email