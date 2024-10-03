SELECT
    patientencounter.id AS case_id,
    evaluation.id AS evaluation_id,
    patientencounter.idProgram AS program_id,
    program.shortname AS program_name,
    patientencounter.idPersonCreator AS creator_id,
    rater.id AS rater_id,
    rater.firstName AS rater_first_name,
    rater.lastName AS rater_last_name,
    rater.gender AS rater_gender,
    rater.consentedToResearch AS rater_consented,
    rater_persongroup_has_person.isArchived AS rater_archived,
    subject.id AS subject_id,
    subject.idPGY AS subject_current_pgy,
    subject.firstName AS subject_first_name,
    subject.lastName AS subject_last_name,
    subject.gender AS subject_gender,
    subject.consentedToResearch AS subject_consented,
    subject_persongroup_has_person.isArchived AS subject_archived,
    subject_procedurerole.role AS subject_role_name,
	evaluation.idPGYTrainee AS trainee_pgy,
    evaluation.traineeType AS trainee_type,
    zwischevaluation.supervision,
    zwischevaluation.performance,
    zwischevaluation.complexity,
    CASE
        WHEN zwischevaluation.idAudio IS NOT NULL
        THEN TRUE 
        ELSE FALSE
    END AS has_dictation,
    patientencounter_has_canonicalprocedure.idMatchingCanonicalProcedure AS proc_id,
    canonicalprocedure.name AS proc_name,
    patientencounter.actualStartTime AS proc_start_time,
    patientencounter.actualStopTime AS proc_stop_time,
    zwischevaluation.submitted_at AS eval_completed,
    evaluation.status AS status,
    evaluation.statusDetails AS status_details,
    rater_login.lastLogin AS rater_last_login,
    subject_login.lastLogin AS subject_last_login,
    transcription.transcriptionText AS transcription_text
FROM simpl_or.zwischevaluation AS zwischevaluation
INNER JOIN simpl_or.patientencounter AS patientencounter ON (
    zwischevaluation.idPatientEncounter = patientencounter.id
)
INNER JOIN simpl_or.evaluation AS evaluation ON zwischevaluation.id = evaluation.id
INNER JOIN simpl_or.person AS rater ON evaluation.idPersonEvaluator = rater.id
INNER JOIN simpl_or.person AS subject ON zwischevaluation.idPerson = subject.id
INNER JOIN simpl_or.program AS program ON patientencounter.idProgram = program.id
INNER JOIN simpl_or.login AS rater_login ON rater.id = rater_login.id
INNER JOIN simpl_or.login AS subject_login ON subject.id = subject_login.id
INNER JOIN simpl_or.persongroup_has_person AS subject_persongroup_has_person ON (
    zwischevaluation.idPerson = subject_persongroup_has_person.idPerson
    AND patientencounter.idProgram = subject_persongroup_has_person.idProgram
)
INNER JOIN simpl_or.persongroup_has_person AS rater_persongroup_has_person ON (
    rater.id = rater_persongroup_has_person.idPerson
    AND patientencounter.idProgram = rater_persongroup_has_person.idProgram
)
INNER JOIN simpl_or.persongroup AS subject_persongroup ON (
    subject_persongroup_has_person.idPersonGroup = subject_persongroup.id
)
INNER JOIN simpl_or.persongroup AS rater_persongroup ON (
    rater_persongroup_has_person.idPersonGroup = rater_persongroup.id
)
INNER JOIN simpl_or.patientencounter_has_person AS subject_patientencounter_has_person ON (
    subject.id = subject_patientencounter_has_person.idPerson
    AND patientencounter.id = subject_patientencounter_has_person.idPatientEncounter
)
INNER JOIN simpl_or.procedurerole AS subject_procedurerole ON (
    subject_patientencounter_has_person.idRole = subject_procedurerole.id
)
INNER JOIN simpl_or.patientencounter_has_canonicalprocedure AS patientencounter_has_canonicalprocedure ON (
    patientencounter.id = patientencounter_has_canonicalprocedure.idPatientEncounter
)
INNER JOIN simpl_or.canonicalprocedure AS canonicalprocedure ON (
    patientencounter_has_canonicalprocedure.idMatchingCanonicalProcedure = canonicalprocedure.id
)
LEFT JOIN simpl_or.transcription AS transcription ON zwischevaluation.idAudio = transcription.idAudio
WHERE
    (
        (subject_persongroup.id = 3 AND rater_persongroup.id = 4)
        OR (subject_persongroup.id = 4 AND rater_persongroup.id = 3)
    )
    AND program.id NOT IN (3 , 5, 6, 10, 47)
    AND subject.id != 115
    AND rater.id != 115
    AND (
        evaluation.status = 'COMPLETE'
        OR evaluation.status = 'IGNORE'
    )
    AND (
        rater_persongroup.id = 3 
        OR rater_persongroup.id = 4
    )
    AND subject_procedurerole.id = subject_patientencounter_has_person.idRole
GROUP BY 
    patientencounter.id,
    evaluation.id,
    patientencounter.idProgram,
    program.shortname,
    patientencounter.idPersonCreator,
    rater.id,
    rater.firstName,
    rater.lastName,
    rater.gender,
    rater.consentedToResearch,
    rater_persongroup_has_person.isArchived,
    subject.id,
    subject.idPGY,
    subject.firstName,
    subject.lastName,
    subject.gender,
    subject.consentedToResearch,
    subject_persongroup_has_person.isArchived,
    subject_procedurerole.role,
	evaluation.idPGYTrainee,
    evaluation.traineeType,
    zwischevaluation.supervision,
    zwischevaluation.performance,
    zwischevaluation.complexity,
    patientencounter_has_canonicalprocedure.idMatchingCanonicalProcedure,
    canonicalprocedure.name,
    patientencounter.actualStartTime,
    patientencounter.actualStopTime,
    zwischevaluation.submitted_at,
    evaluation.status,
    evaluation.statusDetails,
    rater_login.lastLogin,
    subject_login.lastLogin,
    transcription.transcriptionText,
    zwischevaluation.idAudio