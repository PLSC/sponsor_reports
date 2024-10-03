SELECT
    last_activity_event_date AS "date",
    assessment_title AS epa,
    complexity_score AS complexity,
    entrustability_score AS entrustability,
    weight_of_evidence AS weight_of_epa, 
    CASE GREATEST(l1, l2, l3, l4, l5)
        WHEN l1 THEN 'L1'
        WHEN l2 THEN 'L2'
        WHEN l3 THEN 'L3'
        WHEN l4 THEN 'L4'
        WHEN l5 THEN 'L5'
    END AS suggested_level,
    GREATEST(l1, l2, l3, l4, l5) AS suggestion_confidence
FROM abs_reports.milestone_detail AS milestone_detail