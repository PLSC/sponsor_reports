-- DEFINING THE DATASET

-- Q: how do we define 'ABP data'?
-- A: this gives two sponsor names, one of which is marked 'Deprecated'
-- assuming we can use:
    -- ABP as sponsor, id '8eed8a89-b1c1-47e1-bd8d-7f5b9e188d1a'
    -- Pediatrics as network, id '0b12baab-4d43-46be-9cb0-cf0ec8fceac5'
SELECT
    sponsor.name AS sponsor_name,
    network.*
FROM simpl2.network AS network
INNER JOIN simpl2.sponsor AS sponsor ON (
    network.sponsorid = sponsor.id
)
WHERE sponsor.name = 'ABP'

-- NOTES, FOLLOWUP:
-- will there always just be two networks? or more specialties tk?
-- can we get rid of this test data?

------------------------

-- DEFINING EVALUATIONS

-- Q: there are 51 EPAs - how many pediatric activities are there?
-- A: 47
SELECT activity.title
FROM simpl2.activityevent AS activityevent
-- joins for activity names
INNER JOIN simpl2.activityeventactivities AS activityeventactivities ON (
    activityevent.id = activityeventactivities.activityeventid
)
INNER JOIN simpl2.activity AS activity ON (
    activityeventactivities.activityid = activity.id
)
-- join for network filter
INNER JOIN simpl2.networkactivity AS networkactivity ON (
    activity.id = networkactivity.activityid
)
INNER JOIN simpl2.network AS network ON (
    networkactivity.networkid = network.id
)
WHERE network.name = 'Pediatrics'
GROUP BY activity.title
ORDER BY activity.title ASC

-- NOTES, FOLLOWUP:

-- for further parsing - these occasionally, but not always, put parens around category / setting
-- these are the 21 distinct activities with phases stripped:
    ACUTE CARE VISIT
    ACUTE COMMON PROBLEM	
    BEHAVIOR MENTAL HEALTH PROBLEM
    CARE FOR WELL NEWBORN
    CONSULT
    HANDOVER
    LEAD a Team and/or SUPERVISE	
    LONGITUDINAL CONTINUITY CLINIC ASSESSMENT
    PROCEDURE
    RECOGNIZE A DECOMPENSATING PATIENT AND MOBILIZE RESOURCES
    REFERRAL
    ROUTINE HEALTH VISIT
    ROUTINE NEWBORN VISIT
    SEVERELY ILL NEWBORN
    SEVERELY ILL PATIENT
    Single Free Text Question- COLLABORATING WITH OTHERS	
    Single Free Text Question- COMMUNICATING WITH PATIENT AND FAMILIES/PROVIDING FAMILY-CENTERED CARE	
    Single Free Text Question- GENERAL FEEDBACK	
    Single Free Text Question- KNOWING LIMITS AND SEEKING HELP	
    Single Free Text Question- PROMOTING HEALTH EQUITY	

-- do we call them 'activities'? epas?

------------------------

-- DEFINING EVALUATION METRICS

-- Q: what questions are there? eg, entrustability, complexity, etc...
-- A: there are 17 questions, but we'll mostly use supervision, complexity, and feedback
SELECT question.title
FROM simpl2.assessmentevent AS assessmentevent
-- joins for question
INNER JOIN simpl2.assessment AS assessment ON (
    assessmentevent.assessmentid = assessment.id
)
INNER JOIN simpl2.instrument AS instrument ON (
    assessment.instrumentid = instrument.id
)
INNER JOIN simpl2.question AS question ON (
    instrument.id = question.instrumentid
)
-- join for network filter
INNER JOIN simpl2.networkactivity AS networkactivity ON (
    assessmentevent.activityid = networkactivity.activityid
)
INNER JOIN simpl2.network AS network ON (
    networkactivity.networkid = network.id
)
WHERE network.name = 'Pediatrics'
GROUP BY question.title
ORDER BY question.title ASC

-- Q: how are these related to activities, assessments?
-- A: every activity requires responses for:
    -- complexity
    -- supervision
    -- practice readiness
    -- feedback
SELECT
    assessment.title,
    question.title
FROM simpl2.assessmentevent AS assessmentevent
-- joins for question
INNER JOIN simpl2.assessment AS assessment ON (
    assessmentevent.assessmentid = assessment.id
)
INNER JOIN simpl2.instrument AS instrument ON (
    assessment.instrumentid = instrument.id
)
INNER JOIN simpl2.question AS question ON (
    instrument.id = question.instrumentid
)
-- join for network filter
INNER JOIN simpl2.networkactivity AS networkactivity ON (
    assessmentevent.activityid = networkactivity.activityid
)
INNER JOIN simpl2.network AS network ON (
    networkactivity.networkid = network.id
)
WHERE network.name = 'Pediatrics'
GROUP BY assessment.title, question.title
ORDER BY assessment.title ASC, question.title ASC

-- Q: what is the set of possible values? ints, strings, unrestricted?
-- A: it's open response, like EPA data. we need to filter down to acceptable INT values.
SELECT
    assessment.title,
    question.title,
    answerevent.value
FROM simpl2.assessmentevent AS assessmentevent
-- joins for question
INNER JOIN simpl2.assessment AS assessment ON (
    assessmentevent.assessmentid = assessment.id
)
INNER JOIN simpl2.instrument AS instrument ON (
    assessment.instrumentid = instrument.id
)
INNER JOIN simpl2.question AS question ON (
    instrument.id = question.instrumentid
)
-- join for answer values
INNER JOIN simpl2.answerevent AS answerevent ON (
    assessmentevent.id = answerevent.assessmenteventid
)
-- join for network filter
INNER JOIN simpl2.networkactivity AS networkactivity ON (
    assessmentevent.activityid = networkactivity.activityid
)
INNER JOIN simpl2.network AS network ON (
    networkactivity.networkid = network.id
)
WHERE network.name = 'Pediatrics'
GROUP BY assessment.title, question.title, answerevent.value
ORDER BY assessment.title ASC, question.title ASC, answerevent.value ASC

-- NOTES, FOLLOWUP:

-- these are all of the available question types:
    Activity	
    Age	
    Collaborating with others	
    Complexity	
    Diagnosis	
    Duration of Observation	
    Family-Centered Care	
    Feedback	
    Health Equity	
    Knowing Limits and Help-Seeking	
    Next level	
    Plan	
    Practice Readiness	
    Procedure	
    Readiness for Practice	
    Supervision	
    Why	
-- fairly sure we only need complexity, supervision, practice readiness, feedback

------------------------

-- DEFINING 'CATEGORY' / 'LOCATION'

-- Q: where are these marked, how are they handled?
-- A: these are handled like phase in ABS - they're just tacked on to the activity.name
SELECT activity.title
FROM simpl2.activityevent AS activityevent
-- joins for activity names
INNER JOIN simpl2.activityeventactivities AS activityeventactivities ON (
    activityevent.id = activityeventactivities.activityeventid
)
INNER JOIN simpl2.activity AS activity ON (
    activityeventactivities.activityid = activity.id
)
-- join for network filter
INNER JOIN simpl2.networkactivity AS networkactivity ON (
    activity.id = networkactivity.activityid
)
INNER JOIN simpl2.network AS network ON (
    networkactivity.networkid = network.id
)
WHERE network.name = 'Pediatrics'
GROUP BY activity.title
ORDER BY activity.title ASC

-- NOTES, FOLLOWUP:
-- can we count on these activity names not changing to regex for category / setting?

------------------------