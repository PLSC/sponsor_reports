-- PROBABLY DON'T NEED THIS IN ETL, JUST A GUIDE FOR UI
SELECT
    -- for UI group by + filter by
    trainee_id,
    -- for calc
    supervision_score
FROM abp_reports.abp_reports_assessments
