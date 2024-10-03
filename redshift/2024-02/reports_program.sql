SELECT
    -- id
    program.id AS program_id,
    institution.id AS institution_id,
    -- name
    institution.name AS institution_name,
    program.name AS program_name
    -- description
    program.description
    -- lastModified
    program.updatedat AS last_modified,
    -- creationDate
    program.createdat AS creation_date

    -- not migrating
    -- idProgramType
    -- always 1, not migrating
    -- shortname
    -- looks like this matches description from simpl 2
    -- isArchived
    -- lastTaxonomyRefresh
FROM simpl2.program AS program
INNER JOIN simpl2.institution AS institution ON program.institutionid = institution.id