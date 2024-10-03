WITH last_observations AS (
    SELECT
        MAX(assessmentevent.createdat) AS last_observation,
        assessmentevent.rateruserid
    FROM simpl2.assessmentevent
    GROUP BY assessmentevent.rateruserid
),

current_roles AS (
    SELECT
        assessmentevent.rateruserid AS user_id,
        activityevent.programid AS program_id,
        activityparticipant.currentrole AS current_role,
        activityparticipant.currentpgy AS pgy,
        programmembership.traineetype AS trainee_type
    FROM simpl2.assessmentevent AS assessmentevent
    -- join filters for only most instance of a rater event
    INNER JOIN last_observations ON (
        assessmentevent.createdat = last_observations.last_observation
        AND assessmentevent.rateruserid = last_observations.rateruserid
    )
    -- get program from activities
    INNER JOIN simpl2.activityevent AS activityevent ON assessmentevent.activityeventid = activityevent.id
    -- -- get pgy from participant
    INNER JOIN simpl2.activityparticipant AS activityparticipant ON (
        activityevent.id = activityparticipant.activityeventid
        AND assessmentevent.rateruserid = activityparticipant.userid
    )
    -- get traineetype from program membership
    INNER JOIN simpl2.programmembership AS programmembership ON (
        activityevent.programid = programmembership.programid
        AND assessmentevent.rateruserid = programmembership.programmemberid
    )
    WHERE
        assessmentevent.createdat = last_observations.last_observation
)

SELECT
    -- personID
    users.id AS user_id,
    -- npi
    users.npi,
    -- firstName
    users.firstname AS first_name,
    -- lastName
    users.lastname AS last_name,
    -- consented
    users.eulaaccepteddate AS eula_accepted_date,
    -- programID
    current_roles.program_id,
    -- program
    institution.name AS institution_name,
    program.name AS program_name,
    -- pgrole
    current_roles.current_role,
    -- traineeType
    current_roles.trainee_type,
    -- email
    users.email,
    -- yearOfTrainingCompletion
    current_roles.pgy
    --
    -- not in simpl 2:
    -- isArchived
    -- isArchivedForSystem
    -- gender
    -- dob
    --
    -- possibly not migrated:
    -- dateRegistrationInviteSent
    -- dateRegistered
    -- firstLogin
    -- lastLogin
FROM simpl2.user AS users
INNER JOIN current_roles ON users.id = current_roles.user_id
INNER JOIN simpl2.program AS program ON current_roles.program_id = program.id
INNER JOIN simpl2.institution AS institution ON program.institutionid = institution.id