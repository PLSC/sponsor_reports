SELECT
    /* add traineeID, no names
    abp_trainees.first_name AS trainee_first_name,
    abp_trainees.last_name AS trainee_last_name,
    /* add raterID, no names
    abp_attendings.first_name AS rater_first_name,
    abp_attendings.last_name AS rater_last_name,
    /* add programID
    abp_trainees.pgy AS current_pgy,
    abp_trainees.trainee_type,
    abp_reports_assessments.complexity_score,
    abp_reports_assessments.supervision_score,
    abp_reports_assessments.practice_readiness_score,
    abp_reports_assessments.feedback_text,
    abp_reports_assessments.activity_name,
    abp_reports_assessments.setting,
    abp_reports_assessments.assessment_completion_date,
    abp_reports_assessments.activity_date
FROM abp_reports.abp_reports_assessments AS abp_reports_assessments
INNER JOIN abp_reports.abp_reports_users AS abp_trainees ON (
    abp_reports_assessments.trainee_id = abp_trainees.user_id
)
INNER JOIN abp_reports.abp_reports_users AS abp_attendings ON (
    abp_reports_assessments.attending_id = abp_attendings.user_id
)
