WITH last_score_dates AS (
    SELECT
        subject_user_id,
        MAX(created_time) AS last_score_date
    FROM epa_scoring.epa_scores_all
    GROUP BY subject_user_id
)

SELECT
    epa_scores_all.subject_user_id,
    CASE GREATEST(epa_scores_all.pc1_l1, epa_scores_all.pc1_l2, epa_scores_all.pc1_l3, epa_scores_all.pc1_l4, epa_scores_all.pc1_l5)
        WHEN epa_scores_all.pc1_l1 THEN 'L1'
        WHEN epa_scores_all.pc1_l2 THEN 'L2'
        WHEN epa_scores_all.pc1_l3 THEN 'L3'
        WHEN epa_scores_all.pc1_l4 THEN 'L4'
        WHEN epa_scores_all.pc1_l5 THEN 'L5'
    END AS pc1,
    CASE GREATEST(epa_scores_all.pc2_l1, epa_scores_all.pc2_l2, epa_scores_all.pc2_l3, epa_scores_all.pc2_l4, epa_scores_all.pc2_l5)
        WHEN epa_scores_all.pc2_l1 THEN 'L1'
        WHEN epa_scores_all.pc2_l2 THEN 'L2'
        WHEN epa_scores_all.pc2_l3 THEN 'L3'
        WHEN epa_scores_all.pc2_l4 THEN 'L4'
        WHEN epa_scores_all.pc2_l5 THEN 'L5'
    END AS pc2,
    CASE GREATEST(epa_scores_all.pc3_l1, epa_scores_all.pc3_l2, epa_scores_all.pc3_l3, epa_scores_all.pc3_l4, epa_scores_all.pc3_l5)
        WHEN epa_scores_all.pc3_l1 THEN 'L1'
        WHEN epa_scores_all.pc3_l2 THEN 'L2'
        WHEN epa_scores_all.pc3_l3 THEN 'L3'
        WHEN epa_scores_all.pc3_l4 THEN 'L4'
        WHEN epa_scores_all.pc3_l5 THEN 'L5'
    END AS pc3,
    CASE GREATEST(epa_scores_all.pc4_l1, epa_scores_all.pc4_l2, epa_scores_all.pc4_l3, epa_scores_all.pc4_l4, epa_scores_all.pc4_l5)
        WHEN epa_scores_all.pc4_l1 THEN 'L1'
        WHEN epa_scores_all.pc4_l2 THEN 'L2'
        WHEN epa_scores_all.pc4_l3 THEN 'L3'
        WHEN epa_scores_all.pc4_l4 THEN 'L4'
        WHEN epa_scores_all.pc4_l5 THEN 'L5'
    END AS pc4,
    CASE GREATEST(epa_scores_all.mk1_l1, epa_scores_all.mk1_l2, epa_scores_all.mk1_l3, epa_scores_all.mk1_l4, epa_scores_all.mk1_l5)
        WHEN epa_scores_all.mk1_l1 THEN 'L1'
        WHEN epa_scores_all.mk1_l2 THEN 'L2'
        WHEN epa_scores_all.mk1_l3 THEN 'L3'
        WHEN epa_scores_all.mk1_l4 THEN 'L4'
        WHEN epa_scores_all.mk1_l5 THEN 'L5'
    END AS mk1,
    CASE GREATEST(epa_scores_all.mk2_l1, epa_scores_all.mk2_l2, epa_scores_all.mk2_l3, epa_scores_all.mk2_l4, epa_scores_all.mk2_l5)
        WHEN epa_scores_all.mk2_l1 THEN 'L1'
        WHEN epa_scores_all.mk2_l2 THEN 'L2'
        WHEN epa_scores_all.mk2_l3 THEN 'L3'
        WHEN epa_scores_all.mk2_l4 THEN 'L4'
        WHEN epa_scores_all.mk2_l5 THEN 'L5'
    END AS mk2,
    CASE GREATEST(epa_scores_all.sbp1_l1, epa_scores_all.sbp1_l2, epa_scores_all.sbp1_l3, epa_scores_all.sbp1_l4, epa_scores_all.sbp1_l5)
        WHEN epa_scores_all.sbp1_l1 THEN 'L1'
        WHEN epa_scores_all.sbp1_l2 THEN 'L2'
        WHEN epa_scores_all.sbp1_l3 THEN 'L3'
        WHEN epa_scores_all.sbp1_l4 THEN 'L4'
        WHEN epa_scores_all.sbp1_l5 THEN 'L5'
    END AS sbp1,
    CASE GREATEST(epa_scores_all.sbp2_l1, epa_scores_all.sbp2_l2, epa_scores_all.sbp2_l3, epa_scores_all.sbp2_l4, epa_scores_all.sbp2_l5)
        WHEN epa_scores_all.sbp2_l1 THEN 'L1'
        WHEN epa_scores_all.sbp2_l2 THEN 'L2'
        WHEN epa_scores_all.sbp2_l3 THEN 'L3'
        WHEN epa_scores_all.sbp2_l4 THEN 'L4'
        WHEN epa_scores_all.sbp2_l5 THEN 'L5'
    END AS sbp2,
    CASE GREATEST(epa_scores_all.sbp3_l1, epa_scores_all.sbp3_l2, epa_scores_all.sbp3_l3, epa_scores_all.sbp3_l4, epa_scores_all.sbp3_l5)
        WHEN epa_scores_all.sbp3_l1 THEN 'L1'
        WHEN epa_scores_all.sbp3_l2 THEN 'L2'
        WHEN epa_scores_all.sbp3_l3 THEN 'L3'
        WHEN epa_scores_all.sbp3_l4 THEN 'L4'
        WHEN epa_scores_all.sbp3_l5 THEN 'L5'
    END AS sbp3,
    CASE GREATEST(epa_scores_all.pbli1_l1, epa_scores_all.pbli1_l2, epa_scores_all.pbli1_l3, epa_scores_all.pbli1_l4, epa_scores_all.pbli1_l5)
        WHEN epa_scores_all.pbli1_l1 THEN 'L1'
        WHEN epa_scores_all.pbli1_l2 THEN 'L2'
        WHEN epa_scores_all.pbli1_l3 THEN 'L3'
        WHEN epa_scores_all.pbli1_l4 THEN 'L4'
        WHEN epa_scores_all.pbli1_l5 THEN 'L5'
    END AS pbli1,
    CASE GREATEST(epa_scores_all.pbli2_l1, epa_scores_all.pbli2_l2, epa_scores_all.pbli2_l3, epa_scores_all.pbli2_l4, epa_scores_all.pbli2_l5)
        WHEN epa_scores_all.pbli2_l1 THEN 'L1'
        WHEN epa_scores_all.pbli2_l2 THEN 'L2'
        WHEN epa_scores_all.pbli2_l3 THEN 'L3'
        WHEN epa_scores_all.pbli2_l4 THEN 'L4'
        WHEN epa_scores_all.pbli2_l5 THEN 'L5'
    END AS pbli2,
    CASE GREATEST(epa_scores_all.ics1_l1, epa_scores_all.ics1_l2, epa_scores_all.ics1_l3, epa_scores_all.ics1_l4, epa_scores_all.ics1_l5)
        WHEN epa_scores_all.ics1_l1 THEN 'L1'
        WHEN epa_scores_all.ics1_l2 THEN 'L2'
        WHEN epa_scores_all.ics1_l3 THEN 'L3'
        WHEN epa_scores_all.ics1_l4 THEN 'L4'
        WHEN epa_scores_all.ics1_l5 THEN 'L5'
    END AS ics1,
    CASE GREATEST(epa_scores_all.ics2_l1, epa_scores_all.ics2_l2, epa_scores_all.ics2_l3, epa_scores_all.ics2_l4, epa_scores_all.ics2_l5)
        WHEN epa_scores_all.ics2_l1 THEN 'L1'
        WHEN epa_scores_all.ics2_l2 THEN 'L2'
        WHEN epa_scores_all.ics2_l3 THEN 'L3'
        WHEN epa_scores_all.ics2_l4 THEN 'L4'
        WHEN epa_scores_all.ics2_l5 THEN 'L5'
    END AS ics2,
    CASE GREATEST(epa_scores_all.prof1_l1, epa_scores_all.prof1_l2, epa_scores_all.prof1_l3, epa_scores_all.prof1_l4, epa_scores_all.prof1_l5)
        WHEN epa_scores_all.prof1_l1 THEN 'L1'
        WHEN epa_scores_all.prof1_l2 THEN 'L2'
        WHEN epa_scores_all.prof1_l3 THEN 'L3'
        WHEN epa_scores_all.prof1_l4 THEN 'L4'
        WHEN epa_scores_all.prof1_l5 THEN 'L5'
    END AS prof1,
    CASE GREATEST(epa_scores_all.prof2_l1, epa_scores_all.prof2_l2, epa_scores_all.prof2_l3, epa_scores_all.prof2_l4, epa_scores_all.prof2_l5)
        WHEN epa_scores_all.prof2_l1 THEN 'L1'
        WHEN epa_scores_all.prof2_l2 THEN 'L2'
        WHEN epa_scores_all.prof2_l3 THEN 'L3'
        WHEN epa_scores_all.prof2_l4 THEN 'L4'
        WHEN epa_scores_all.prof2_l5 THEN 'L5'
    END AS prof2
FROM epa_scoring.epa_scores_all AS epa_scores_all
INNER JOIN last_score_dates ON (
    epa_scores_all.created_time = last_score_dates.last_score_date
    AND epa_scores_all.subject_user_id = last_score_dates.subject_user_id
)