WITH max_evaluation AS (
    SELECT
        trainee_id,
        MAX(assessment_completion_date)
    FROM derived_tables.reports_assessments
)

SELECT
    reports_assessments.trainee_id,
    reports_assessments.attending_id,
    reports_assessments.assessment_event_id,
    reports_assessments.milestone,
    suggested_level,
    evaluations,
    last_evaluation_date,
    last_evaluation_name
FROM derived_tables.reports_assessments AS reports_assessments