-- DM --
select * from dm_fact_filmavond dff;
select * from dm_dim_film ddf;
select * from dm_dim_meister ddm;
select * from dm_dim_datum ddd;
select * from dm_dim_datum_vw ddv;
select * from dm_dim_film_genre;

select *
from dm_fact_filmavond dff
join dm_dim_film ddf on dff.Dim_Film_key = ddf.Dim_Film_Key
join dm_dim_meister ddm on dff.Dim_Meister_key = ddm.Dim_Meister_Key
--join dm_dim_film_genre dfg on dff.Dim_Film_key = dfg.Dim_Film_Key
--join dm_dim_datum ddd on dff.Dim_Filmavond_Datum_key = ddd.Dim_Datum_Key
join dm_dim_datum_vw ddv on dff.Dim_Filmavond_Datum_key = ddv.Dim_Datum_Key;

--------------------------
-- Algemene meetwaarden --
--------------------------
select
	  count(distinct dff.Dim_Film_key) as Aantal_Unieke_Films
	, sum(dff.Aantal_Filmavonden) as Aantal_Filmavonden
	, min(Filmavond_Datum.Datum) as Eerste_Filmavond
	, max(Filmavond_Datum.Datum) as Laatste_Filmavond
	, min(ddf.Film_Jaar) as Oudste_Film_Jaar
	, max(ddf.Film_Jaar) as Nieuwste_Film_Jaar
	, round(avg(ddf.Film_Jaar)) as Gemiddeld_Film_Jaar
	, max(ddf.Film_Tijdsduur_min) as Langste_Film_In_Minuten
	, min(ddf.Film_Tijdsduur_min) as Kortste_Film_In_Minuten
	, max(ddf.Film_IMDB_Score) as Hoogste_IMDb_Score
	, min(ddf.Film_IMDB_Score) as Laagste_IMDb_Score
from dm_fact_filmavond dff
inner join dm_dim_film ddf on dff.Dim_Film_key = ddf.Dim_Film_Key
inner join dm_dim_datum_vw Filmavond_Datum on dff.Dim_Filmavond_Datum_key = Filmavond_Datum.Dim_Datum_Key;

------------------------
-- Meister meetwaarde --
------------------------
select
	ddm.Film_Meister
	,dff.Film_Al_Gezien
	,count(*)
from dm_fact_filmavond dff
inner join dm_dim_film ddf on dff.Dim_Film_key = ddf.Dim_Film_Key
inner join dm_dim_datum_vw Filmavond_Datum on dff.Dim_Filmavond_Datum_key = Filmavond_Datum.Dim_Datum_Key
inner join dm_dim_meister ddm on dff.Dim_Meister_key = ddm.Dim_Meister_Key
group by 
	ddm.Film_Meister
	,dff.Film_Al_Gezien
;

select
	count(*) over (partition by ddm.Film_Meister, dff.Film_Al_Gezien)
	,ddm.Film_Meister
	,dff.Film_Al_Gezien
from dm_fact_filmavond dff
inner join dm_dim_film ddf on dff.Dim_Film_key = ddf.Dim_Film_Key
inner join dm_dim_datum_vw Filmavond_Datum on dff.Dim_Filmavond_Datum_key = Filmavond_Datum.Dim_Datum_Key
inner join dm_dim_meister ddm on dff.Dim_Meister_key = ddm.Dim_Meister_Key
;







