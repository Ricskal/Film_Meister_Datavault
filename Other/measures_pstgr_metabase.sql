-- DM --
select * from dm.fact_filmavond dff;
select * from dm.dim_film ddf;
select * from dm.dim_meister ddm;
select * from dm.dim_datum ddd;
select * from dm.dim_datum_vw ddv;
select * from dm.dim_film_genre;

select *
from dm.fact_filmavond dff
join dm.dim_film ddf on dff.Dim_Film_key = ddf.Dim_Film_Key
join dm.dim_meister ddm on dff.Dim_Meister_key = ddm.Dim_Meister_key
--join dm.dim_film_genre dfg on dff.Dim_Film_key = dfg.Dim_Film_Key
--join dm.dim_datum ddd on dff.dim_filmavond_datum_key = ddd.dim_datum_key
join dm.dim_datum_vw ddv on dff.dim_filmavond_datum_key = ddv.dim_datum_key;

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
	, max(ddf.film_tijdsduur_min) as Langste_Film_In_Minuten
	, min(ddf.film_tijdsduur_min) as Kortste_Film_In_Minuten
	, max(ddf.film_imdb_score) as Hoogste_IMDb_Score
	, min(ddf.film_imdb_score) as Laagste_IMDb_Score
from dm.fact_filmavond dff
inner join dm.dim_film ddf on dff.Dim_Film_key = ddf.Dim_Film_Key
inner join dm.dim_datum_vw Filmavond_Datum on dff.dim_filmavond_datum_key = Filmavond_Datum.dim_datum_key;

-----------------------------------------------------------
-- Meister meetwaarde: Avontuurlijkheid en Comfort Score --
-----------------------------------------------------------
with cte_gezien_totaal as (
	select
		  ddm.Film_Meister
		, dff.Film_Al_Gezien
		, count(distinct dff.Dim_Film_key) Totaal_Aantal_Films
	from dm.fact_filmavond dff
	inner join dm.dim_film ddf on dff.Dim_Film_key = ddf.Dim_Film_Key
	inner join dm.dim_meister ddm on dff.Dim_Meister_key = ddm.Dim_Meister_key
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
	, dff.dim_filmavond_datum_key 
	, dff.Film_Al_Gezien
	, 1 as Aantal_films
	, count(dff.dim_film_key) over (partition by ddm.film_meister order by dff.dim_filmavond_datum_key desc rows between unbounded preceding and current row) Totaal_Aantal_Films
	, count(dff.dim_film_key) over (partition by ddm.film_meister, dff.Film_Al_Gezien order by dff.dim_filmavond_datum_key desc rows between unbounded preceding and current row) Totaal_Aantal_Films_Gezien
	, round((count(dff.dim_film_key) over (partition by ddm.film_meister, dff.Film_Al_Gezien order by dff.dim_filmavond_datum_key desc rows between unbounded preceding and current row)/ 1.0) / (count(dff.dim_film_key) over (partition by ddm.film_meister order by dff.dim_filmavond_datum_key desc rows between unbounded preceding and current row)/ 1.0),4) test
	from dm.fact_filmavond dff
inner join dm.dim_film ddf on dff.Dim_Film_key = ddf.Dim_Film_Key
inner join dm.dim_meister ddm on dff.Dim_Meister_key = ddm.Dim_Meister_key
;

----------------------------------------------------
-- Meister meetwaarde: oudste- & nieuwste 3 films --
----------------------------------------------------
with cte_rownumber as (
	select
		  dm.dim_film.Film_Jaar
		, dm.dim_film.film_title
		, dm.fact_filmavond.dim_filmavond_datum_key
		, row_number () over (order by dm.dim_film.Film_Jaar desc, dm.fact_filmavond.dim_filmavond_datum_key desc) as rn
	from dm.fact_filmavond
	inner join dm.dim_film on dm.fact_filmavond.Dim_Film_key = dm.dim_film.Dim_Film_Key
	inner join dm.dim_datum_vw on dm.fact_filmavond.dim_filmavond_datum_key = dm.dim_datum_vw.dim_datum_key
	inner join dm.dim_meister on dm.fact_filmavond.Dim_Meister_key = dm.dim_meister.Dim_Meister_key
	where {{filmmeister}}
	and {{filmavonddatum}}
	group by
		  dm.dim_film.film_title
		, dm.dim_film.Film_Jaar
		, dm.fact_filmavond.dim_filmavond_datum_key
)
select
	  cte.Film_Jaar as Premièrejaar
	, cte.film_title as Filmtitel
from cte_rownumber cte
where cte.rn between 1 and 3
;

with cte_rownumber as (
	select
		  dm.dim_film.Film_Jaar
		, dm.dim_film.film_title
		, dm.fact_filmavond.dim_filmavond_datum_key
		, row_number () over (order by dm.dim_film.Film_Jaar asc, dm.fact_filmavond.dim_filmavond_datum_key desc) as rn
	from dm.fact_filmavond
	inner join dm.dim_film on dm.fact_filmavond.Dim_Film_key = dm.dim_film.Dim_Film_Key
	inner join dm.dim_datum_vw on dm.fact_filmavond.dim_filmavond_datum_key = dm.dim_datum_vw.dim_datum_key
	inner join dm.dim_meister on dm.fact_filmavond.Dim_Meister_key = dm.dim_meister.Dim_Meister_key
	where {{filmmeister}}
	and {{filmavonddatum}}
	group by
		  dm.dim_film.film_title
		, dm.dim_film.Film_Jaar
		, dm.fact_filmavond.dim_filmavond_datum_key
)
select
	  cte.Film_Jaar as Premièrejaar
	, cte.film_title as Filmtitel
from cte_rownumber cte
where cte.rn between 1 and 3
;

----------------------------------------------------------------
-- Meister meetwaarde: langste-, korste- gemiddelde speelduur --
----------------------------------------------------------------
with cte_rownumber as (
	select
		  dm.dim_film.film_tijdsduur_min 
		, dm.dim_film.film_title
		, dm.fact_filmavond.dim_filmavond_datum_key
		, row_number () over (order by dm.dim_film.film_tijdsduur_min desc, dm.fact_filmavond.dim_filmavond_datum_key desc) as rn
	from dm.fact_filmavond
	inner join dm.dim_film on dm.fact_filmavond.Dim_Film_key = dm.dim_film.Dim_Film_Key
	inner join dm.dim_datum_vw on dm.fact_filmavond.dim_filmavond_datum_key = dm.dim_datum_vw.dim_datum_key
	inner join dm.dim_meister on dm.fact_filmavond.Dim_Meister_key = dm.dim_meister.Dim_Meister_key
	where {{filmmeister}}
	and {{filmavonddatum}}
	group by
		  dm.dim_film.film_tijdsduur_min 
		, dm.dim_film.film_title
		, dm.fact_filmavond.dim_filmavond_datum_key
)
select
	  cte.film_tijdsduur_min as Speelduur
	, cte.film_title as Filmtitel
from cte_rownumber cte
where cte.rn between 1 and 3
;

with cte_rownumber as (
	select
		  dm.dim_film.film_tijdsduur_min 
		, dm.dim_film.film_title
		, dm.fact_filmavond.dim_filmavond_datum_key
		, row_number () over (order by dm.dim_film.film_tijdsduur_min asc, dm.fact_filmavond.dim_filmavond_datum_key desc) as rn
	from dm.fact_filmavond
	inner join dm.dim_film on dm.fact_filmavond.Dim_Film_key = dm.dim_film.Dim_Film_Key
	inner join dm.dim_datum_vw on dm.fact_filmavond.dim_filmavond_datum_key = dm.dim_datum_vw.dim_datum_key
	inner join dm.dim_meister on dm.fact_filmavond.Dim_Meister_key = dm.dim_meister.Dim_Meister_key
	where {{filmmeister}}
	and {{filmavonddatum}}
	group by
		  dm.dim_film.film_tijdsduur_min 
		, dm.dim_film.film_title
		, dm.fact_filmavond.dim_filmavond_datum_key
)
select
	  cte.film_tijdsduur_min as Speelduur
	, cte.film_title as Filmtitel
from cte_rownumber cte
where cte.rn between 1 and 3
;

----------------------------------------------------------
-- Meister meetwaarde: min, max en gemiddelde imbd-score--
----------------------------------------------------------
with cte_rownumber as (
	select
		  dm.dim_film.film_imdb_score 
		, dm.dim_film.film_title
		, dm.fact_filmavond.dim_filmavond_datum_key
		, row_number () over (order by dm.dim_film.film_imdb_score desc, dm.fact_filmavond.dim_filmavond_datum_key desc) as rn
	from dm.fact_filmavond
	inner join dm.dim_film on dm.fact_filmavond.Dim_Film_key = dm.dim_film.Dim_Film_Key
	inner join dm.dim_datum_vw on dm.fact_filmavond.dim_filmavond_datum_key = dm.dim_datum_vw.dim_datum_key
	inner join dm.dim_meister on dm.fact_filmavond.Dim_Meister_key = dm.dim_meister.Dim_Meister_key
	where {{filmmeister}}
	and {{filmavonddatum}}
	group by
		  dm.dim_film.film_imdb_score 
		, dm.dim_film.film_title
		, dm.fact_filmavond.dim_filmavond_datum_key
)
select
	  cte.film_imdb_score as IMDb-score
	, cte.film_title as Filmtitel
from cte_rownumber cte
where cte.rn between 1 and 3
;

with cte_rownumber as (
	select
		  dm.dim_film.film_imdb_score 
		, dm.dim_film.film_title
		, dm.fact_filmavond.dim_filmavond_datum_key
		, row_number () over (order by dm.dim_film.film_imdb_score asc, dm.fact_filmavond.dim_filmavond_datum_key desc) as rn
	from dm.fact_filmavond
	inner join dm.dim_film on dm.fact_filmavond.Dim_Film_key = dm.dim_film.Dim_Film_Key
	inner join dm.dim_datum_vw on dm.fact_filmavond.dim_filmavond_datum_key = dm.dim_datum_vw.dim_datum_key
	inner join dm.dim_meister on dm.fact_filmavond.Dim_Meister_key = dm.dim_meister.Dim_Meister_key
	where {{filmmeister}}
	and {{filmavonddatum}}
	group by
		  dm.dim_film.film_imdb_score 
		, dm.dim_film.film_title
		, dm.fact_filmavond.dim_filmavond_datum_key
)
select
	  cte.film_imdb_score as IMDb-score
	, cte.film_title as Filmtitel
from cte_rownumber cte
where cte.rn between 1 and 3
;

-----------------------------------------
-- Meister meetwaarde: midiaan filjaar --
-----------------------------------------
SELECT
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY dm.dim_film.film_jaar) AS median
FROM dm.fact_filmavond
INNER JOIN dm.dim_meister ON dm.fact_filmavond.dim_meister_key = dm.dim_meister.dim_meister_key
INNER JOIN dm.dim_film ON dm.fact_filmavond.dim_film_key = dm.dim_film.dim_film_key
INNER JOIN dm.dim_datum_vw ON dm.fact_filmavond.dim_filmavond_datum_key = dm.dim_datum_vw.dim_datum_key
where {{filmmeister}}
	and {{filmavonddatum}}
;

--------------------------------------------------------------
-- Meister meetwaarde: avontuurlijkheid - comfortabel score --
--------------------------------------------------------------
with cte_gezien_totaal as (
	select
		count(distinct dm.fact_filmavond.Dim_Film_key) Totaal_Aantal_Films
	from dm.fact_filmavond
	inner join dm.dim_film on dm.fact_filmavond.Dim_Film_key = dm.dim_film.Dim_Film_Key
	inner join dm.dim_meister on dm.fact_filmavond.Dim_Meister_key = dm.dim_meister.Dim_Meister_key
	inner join dm.dim_datum_vw on dm.fact_filmavond.dim_filmavond_datum_key = dm.dim_datum_vw.dim_datum_key
	where {{filmmeister}}
	and {{filmavonddatum}}
)
select
	round(
		(count(distinct dm.fact_filmavond.Dim_Film_key) / 1.0) / 
		(max(cte.Totaal_Aantal_Films) / 1.0) 
		, 4
	) as Score
from dm.fact_filmavond
inner join cte_gezien_totaal cte on true
inner join dm.dim_meister on dm.fact_filmavond.Dim_Meister_key = dm.dim_meister.Dim_Meister_key
inner join dm.dim_datum_vw on dm.fact_filmavond.dim_filmavond_datum_key = dm.dim_datum_vw.dim_datum_key
where dm.fact_filmavond.film_al_gezien = 'Nee'
and {{filmmeister}}
and {{filmavonddatum}}
;

--------------------------------------------------------------
-- Meister meetwaarde: avontuurlijkheid - comfortabel score --
--------------------------------------------------------------

