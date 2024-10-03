-- PROBABLY DON'T NEED THIS IN ETL, JUST A GUIDE FOR UI
SELECT
    -- for UI group by + filter by
    trainee_id,
    -- for calc
    -- a note here - we want the count xof complexity_score = 3 over total count
    complexity_score
FROM abp_reports.abp_reports_assessments
