-- unloads to: s3://medqip/etl-test-data/unload/
UNLOAD ('
    SELECT
        institution_name,
        program_name,
        program_id,
        activityevent_id,
        assessment_id,
        assessmentevent_id,
        rater_user_id,
        subject_user_id,
        current_role,
        current_pgy,
        trainee_type,
        complexity_score,
        entrustability_score,
        complexity_readable,
        entrustability_readable,
        assessment_title,
        activityevent_date,
        completion_date,
        expired,
        paired_status
    FROM derived_tables.simpl2_evaluations
')
TO 's3://medqip/etl-test-data/unload/'
IAM_ROLE 'arn:aws:iam::597534837657:role/medqip-redshift-copy-role'
-- parallel increases processing speed but writes to truncated part files
PARALLEL OFF
CSV;