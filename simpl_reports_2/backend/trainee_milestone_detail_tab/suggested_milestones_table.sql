SELECT
    reports_assessments.trainee_id,
    suggested_milestones.pc1,
    suggested_milestones.pc2,
    suggested_milestones.pc3,
    suggested_milestones.pc4,
    suggested_milestones.mk1,
    suggested_milestones.mk2,
    suggested_milestones.sbp1,
    suggested_milestones.sbp2,
    suggested_milestones.sbp3,
    suggested_milestones.pbli1,
    suggested_milestones.pbli2,
    suggested_milestones.ics1,
    suggested_milestones.ics2,
    suggested_milestones.prof1,
    suggested_milestones.prof2
    SUM(
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%pc1%'
            THEN 1
            ELSE 0
        END
    ) AS pc1_assessments,
    COUNT( DISTINCT
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%pc1%'
            THEN reports_assessments.attending_id
            ELSE NULL
        END
    ) AS pc1_raters,
    SUM(
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%pc2%'
            THEN 1
            ELSE 0
        END
    ) AS pc2_assessments,
    COUNT( DISTINCT
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%pc2%'
            THEN reports_assessments.attending_id
            ELSE NULL
        END
    ) AS pc2_raters,
    SUM(
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%pc3%'
            THEN 1
            ELSE 0
        END
    ) AS pc3_assessments,
    COUNT( DISTINCT
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%pc3%'
            THEN reports_assessments.attending_id
            ELSE NULL
        END
    ) AS pc3_raters,
    SUM(
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%pc4%'
            THEN 1
            ELSE 0
        END
    ) AS pc4_assessments,
    COUNT( DISTINCT
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%pc4%'
            THEN reports_assessments.attending_id
            ELSE NULL
        END
    ) AS pc4_raters,
    SUM(
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%mk1%'
            THEN 1
            ELSE 0
        END
    ) AS mk1_assessments,
    COUNT( DISTINCT
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%mk1%'
            THEN reports_assessments.attending_id
            ELSE NULL
        END
    ) AS mk1_raters,
    SUM(
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%mk2%'
            THEN 1
            ELSE 0
        END
    ) AS mk2_assessments,
    COUNT( DISTINCT
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%mk2%'
            THEN reports_assessments.attending_id
            ELSE NULL
        END
    ) AS mk2_raters,
    SUM(
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%sbp1%'
            THEN 1
            ELSE 0
        END
    ) AS sbp1_assessments,
    COUNT( DISTINCT
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%sbp1%'
            THEN reports_assessments.attending_id
            ELSE NULL
        END
    ) AS sbp1_raters,
    SUM(
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%sbp2%'
            THEN 1
            ELSE 0
        END
    ) AS sbp2_assessments,
    COUNT( DISTINCT
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%sbp2%'
            THEN reports_assessments.attending_id
            ELSE NULL
        END
    ) AS sbp2_raters,
    SUM(
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%sbp3%'
            THEN 1
            ELSE 0
        END
    ) AS sbp3_assessments,
    COUNT( DISTINCT
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%sbp3%'
            THEN reports_assessments.attending_id
            ELSE NULL
        END
    ) AS sbp3_raters,
    SUM(
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%pbli1%'
            THEN 1
            ELSE 0
        END
    ) AS pbli1_assessments,
    COUNT( DISTINCT
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%pbli1%'
            THEN reports_assessments.attending_id
            ELSE NULL
        END
    ) AS pbli1_raters,
    SUM(
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%pbli2%'
            THEN 1
            ELSE 0
        END
    ) AS pbli2_assessments,
    COUNT( DISTINCT
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%pbli2%'
            THEN reports_assessments.attending_id
            ELSE NULL
        END
    ) AS pbli2_raters,
    SUM(
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%ics1%'
            THEN 1
            ELSE 0
        END
    ) AS ics1_assessments,
    COUNT( DISTINCT
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%ics1%'
            THEN reports_assessments.attending_id
            ELSE NULL
        END
    ) AS ics1_raters,
    SUM(
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%ics2%'
            THEN 1
            ELSE 0
        END
    ) AS ics2_assessments,
    COUNT( DISTINCT
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%ics2%'
            THEN reports_assessments.attending_id
            ELSE NULL
        END
    ) AS ics2_raters,
    SUM(
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%prof1%'
            THEN 1
            ELSE 0
        END
    ) AS prof1_assessments,
    COUNT( DISTINCT
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%prof1%'
            THEN reports_assessments.attending_id
            ELSE NULL
        END
    ) AS prof1_raters,
    SUM(
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%prof2%'
            THEN 1
            ELSE 0
        END
    ) AS prof2_assessments,
    COUNT( DISTINCT
        CASE
            WHEN LOWER(reports_assessments.milestone) LIKE '%prof2%'
            THEN reports_assessments.attending_id
            ELSE NULL
        END
    ) AS prof2_raters
FROM derived_tables.reports_assessments AS reports_assessments
GROUP BY reports_assessments.trainee_id
