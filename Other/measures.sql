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

----------------------------------
-- Meister meetwaarde: Algemeen --
----------------------------------
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

-----------------------------------------------------------
-- Meister meetwaarde: Avontuurlijkheid en Comfort Score --
-----------------------------------------------------------
with cte_gezien_totaal as (
	select
		  ddm.Film_Meister
		, dff.Film_Al_Gezien
		, count(distinct dff.Dim_Film_key) Totaal_Aantal_Films
	from dm_fact_filmavond dff
	inner join dm_dim_film ddf on dff.Dim_Film_key = ddf.Dim_Film_Key
	inner join dm_dim_meister ddm on dff.Dim_Meister_key = ddm.Dim_Meister_Key
	group by
		  ddm.Film_Meister
		, dff.Film_Al_Gezien
)
select
	  cte1.Film_Meister
	, cte1.Film_Al_Gezien
	, cte1.Totaal_Aantal_Films
	, cte2.Film_Meister
	, cte2.Film_Al_Gezien
	, cte2.Totaal_Aantal_Films
	, round(
		(cte1.Totaal_Aantal_Films /1.0) / 
			((ifnull(cte1.Totaal_Aantal_Films,0) / 1.0) + 
			(ifnull(cte2.Totaal_Aantal_Films,0)/ 1.0))
		,4) 
	  as Score
	, case when cte1.Film_Al_Gezien = 'Ja' then 'Comfort' else 'Avontuurlijkheid' end as Score_Type
from cte_gezien_totaal cte1
left join cte_gezien_totaal cte2 
	on cte1.Film_Meister = cte2.Film_Meister 
	and cte1.Film_Al_Gezien <> cte2.Film_Al_Gezien;

---------------------------
-- Meister meetwaarde: ? --
---------------------------
select
	  dff.Fact_Filmavond_key 
	, ddm.Film_Meister
	, dff.Dim_Filmavond_Datum_key 
	, dff.Film_Al_Gezien
	, 1 as Aantal_films
	, count(dff.dim_film_key) over (partition by ddm.film_meister order by dff.dim_filmavond_datum_key desc rows between unbounded preceding and current row) Totaal_Aantal_Films
	, count(dff.dim_film_key) over (partition by ddm.film_meister, dff.Film_Al_Gezien order by dff.dim_filmavond_datum_key desc rows between unbounded preceding and current row) Totaal_Aantal_Films_Gezien
	, round((count(dff.dim_film_key) over (partition by ddm.film_meister, dff.Film_Al_Gezien order by dff.dim_filmavond_datum_key desc rows between unbounded preceding and current row)/ 1.0) / (count(dff.dim_film_key) over (partition by ddm.film_meister order by dff.dim_filmavond_datum_key desc rows between unbounded preceding and current row)/ 1.0),4) test
	from dm_fact_filmavond dff
inner join dm_dim_film ddf on dff.Dim_Film_key = ddf.Dim_Film_Key
inner join dm_dim_meister ddm on dff.Dim_Meister_key = ddm.Dim_Meister_Key
;







