CREATE VIEW IF NOT EXISTS bdv.meister_hub AS
    select
          rmh.Meister_Hub_Key
        , rmh.Meister_BK AS Film_Meister
    FROM rdv.meister_hub rmh
;