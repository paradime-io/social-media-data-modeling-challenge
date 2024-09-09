with
    source as (
        select unnest(persons) as athlete
        from {{ source('olympics_api', 'athletes_bio') }}
    )

    , extracting_columnns as (
        select
            athlete.code as id
            , athlete.givenName as given_name
            , athlete.familyName as family_name
            , athlete.participantBio.gender as gender
            , athlete.nationality.code as nationality
            , athlete.participantBio.countryofBirth.code as country_of_birth
            , athlete.participantBio.countryofResidence.code as country_of_residence
            , athlete.disciplines as disciplines
            , length(athlete.registeredEvents) as num_of_events
            , athlete.birthDate as birth_date
            , athlete.medals as medals
            , athlete.participantBio.interest.extendedBios as extended_bios
        from source
    )

select *
from extracting_columnns