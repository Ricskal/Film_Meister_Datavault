CREATE VIEW IF NOT EXISTS bdv_meister_hub AS
    select
          rmh.Meister_Hub_Key
        , rmh.Meister_BK AS Film_Meister
    FROM rdv_meister_hub rmh
    ;