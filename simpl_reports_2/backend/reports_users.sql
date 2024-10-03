WITH activityevent_with_user AS (
    SELECT 
        activityevent.*,
        activityparticipant.userid,
        activityparticipant.currentrole
    FROM simpl2.activityparticipant AS activityparticipant
    INNER JOIN simpl2.activityevent AS activityevent ON (
        activityparticipant.activityeventid = activityevent.id
    )
),

-- this assumes a user cannot have two activities at the same moment
user_current_details AS (
    SELECT
        userid,
        currentrole,
        programid
    FROM activityevent_with_user 
    WHERE 
        (userid, activityeventdate) IN ( 
            SELECT 
                userid, 
                MAX(activityeventdate)
            FROM activityevent_with_user
            GROUP BY userid
        )
)

SELECT
    user_table.firstname AS first_name,
    user_table.lastname AS last_name,
    user_table.id AS user_id,
    user_current_details.programid AS program_id,
    user_current_details.currentrole AS type,
    programmembership.traineetype AS trainee_type,
    -- assuming creation of invitation record is the sent date
    userinvitation.createdat AS invite_sent,
    eulaaccepteddate AS registered,
    user_table.pgy,
    user_table.email
-- annoying rename, but user is a reserved word
FROM simpl2.user AS user_table
INNER JOIN user_current_details ON user_table.id = user_current_details.userid
INNER JOIN simpl2.userinvitation AS userinvitation ON user_table.id = userinvitation.inviteeid
INNER JOIN simpl2.programmembership AS programmembership ON (
    user_current_details.programid = programmembership.programid
    AND user_current_details.userid = programmembership.programmemberid
)