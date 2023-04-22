CREATE VIEW IF NOT EXISTS bdv_meister_hub as
    select
          rmh.Meister_Hub_Key
        , rmh.Meister_BK as Film_Meister
    from rdv_meister_hub rmh
    ;