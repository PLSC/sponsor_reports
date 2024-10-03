WITH epa_by_trainee AS (
    SELECT
        trainee_id,
        activity_name AS epa,
        AVG(supervision_score) AS avg_supervision,
        SUM(
            CASE 
                WHEN practice_readiness_score = 0
                THEN 1
                ELSE 0
            END
        ) AS r0,
        SUM(
            CASE 
                WHEN practice_readiness_score = 1
                THEN 1
                ELSE 0
            END
        ) AS r1,
        SUM(
            CASE 
                WHEN practice_readiness_score = 2
                THEN 1
                ELSE 0
            END
        ) AS r2,
        SUM(
            CASE 
                WHEN practice_readiness_score = 3
                THEN 1
                ELSE 0
            END
        ) AS r3,
        SUM(
            CASE 
                WHEN complexity_score = 3 
                THEN 1
                ELSE 0
            END
        ) AS complexity_count,
        COUNT(*) AS total_assessments,
        COUNT(DISTINCT attending_id) AS unique_raters
    FROM abp_reports.abp_reports_assessments
    GROUP BY
        activity_name,
        trainee_id
)

SELECT
    trainee_id,
    epa,
    avg_supervision,
    CASE GREATEST(r0, r1, r2, r3)
        WHEN r0 THEN '0'
        WHEN r1 THEN '1'
        WHEN r2 THEN '2'
        WHEN r3 THEN '3'
    END AS mode_readiness,
    complexity_count * 1.0 / total_assessments AS complexity_rate,
    total_assessments,
    unique_raters
FROM epa_by_trainee
ORDER BY
    trainee_id ASC,
    epa ASC