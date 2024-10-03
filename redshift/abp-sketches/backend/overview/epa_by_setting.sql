SELECT
    abp_reports_assessments.assessment_event_id,
    abp_reports_assessments.setting,
    CASE
        WHEN abp_reports_assessments.setting = 'Primary Care Clinic'
        THEN 1
        ELSE 0
    END AS primary_care_clinic,
    CASE
        WHEN abp_reports_assessments.setting = 'Emergency Department'
        THEN 1
        ELSE 0
    END AS emergency_departent,
    CASE
        WHEN abp_reports_assessments.setting = 'Hospitalist/Gen Peds Inpt'
        THEN 1
        ELSE 0
    END AS hospitalist_gen_peds_inpt,
    CASE
        WHEN abp_reports_assessments.setting = 'NICU/PICU/Step Down'
        THEN 1
        ELSE 0
    END AS nicu_picu_step_down,
    CASE
        WHEN abp_reports_assessments.setting = 'Nursery/Delivery Room'
        THEN 1
        ELSE 0
    END AS nurser_delivery_room,
    CASE
        WHEN abp_reports_assessments.setting = 'Other'
        THEN 1
        ELSE 0
    END AS other,
    abp_reports_assessments.assessment_completion_date,
    abp_reports_users.program_id
FROM abp_reports.abp_reports_assessments AS abp_reports_assessments
INNER JOIN abp_reports.abp_reports_users AS abp_reports_users ON (
    abp_reports_assessments.trainee_id = abp_reports_users.user_id
)