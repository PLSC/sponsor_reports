SELECT
    SUM(primary_care_clinic) AS primary_care_clinic_total,
    SUM(emergency_departent) AS emergency_departent_total,
    SUM(hospitalist_gen_peds_inpt) AS hospitalist_gen_peds_inpt_total,
    SUM(nicu_picu_step_down) AS nicu_picu_step_down_total,
    SUM(nurser_delivery_room) AS nurser_delivery_room_total,
    SUM(other) AS other_total
FROM abp_reports.epa_by_setting
WHERE
    program_id = ?program_id
    AND assessment_completion_date >= ?filter_start_date
    AND assessment_completion_date < ?filter_end_date