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

-----------------------------------------
-- Meister meetwaarde: aantal uur film --
-----------------------------------------

select
	sum(dm.dim_film.Film_Tijdsduur_min) / 60 
from dm.fact_filmavond
inner join dm.dim_film on dm.fact_filmavond.Dim_Film_key = dm.dim_film.Dim_Film_Key
inner join dm.dim_meister on dm.fact_filmavond.Dim_Meister_key = dm.dim_meister.Dim_Meister_key
inner join dm.dim_datum_vw on dm.fact_filmavond.dim_filmavond_datum_key = dm.dim_datum_vw.dim_datum_key
where {{filmmeister}}
and {{filmavonddatum}}

--------------------------------------------
-- Meister meetwaarde: genre populairitei --
--------------------------------------------

with cte_totaal_films as (
	select
		count(dm.dim_film_genre.genre) Totaal
	from dm.fact_filmavond
	inner join dm.dim_film on dm.fact_filmavond.Dim_Film_key = dm.dim_film.Dim_Film_Key
	inner join dm.dim_meister on dm.fact_filmavond.Dim_Meister_key = dm.dim_meister.Dim_Meister_key
	inner join dm.dim_datum_vw on dm.fact_filmavond.dim_filmavond_datum_key = dm.dim_datum_vw.dim_datum_key
    inner join dm.dim_film_genre on dm.fact_filmavond.dim_film_key = dm.dim_film_genre.Dim_Film_Key
	where {{filmmeister}}
	and {{filmavonddatum}}
), cte_totaal_films_genre as (
    select
    	  dm.dim_film_genre.genre Genre
    	, count(*) Totaal
    from dm.fact_filmavond
    inner join dm.dim_film on dm.fact_filmavond.Dim_Film_key = dm.dim_film.Dim_Film_Key
    inner join dm.dim_meister on dm.fact_filmavond.Dim_Meister_key = dm.dim_meister.Dim_Meister_key
    inner join dm.dim_datum_vw on dm.fact_filmavond.dim_filmavond_datum_key = dm.dim_datum_vw.dim_datum_key
    inner join dm.dim_film_genre on dm.fact_filmavond.dim_film_key = dm.dim_film_genre.Dim_Film_Key
    group by dm.dim_film_genre.genre
	where {{filmmeister}}
	and {{filmavonddatum}}
)
select
      cte_totaal_films_genre.Genre
    , ((cte_totaal_films_genre.Totaal) * 1.0) / (cte_totaal_films.Totaal * 1.0) "Gekozen percentage"
from cte_totaal_films
inner join cte_totaal_films_genre on true
order by ((cte_totaal_films_genre.Totaal) * 1.0) / (cte_totaal_films.Totaal * 1.0) desc
;


---------------------------------------
-- Meister meetwaarde: laatste films --
---------------------------------------

with cte_rownumber as (
	select
	      dm.dim_datum_vw.date
        , dm.dim_film.film_title
		, dm.dim_meister.Film_Meister
		, row_number () over (order by dm.fact_filmavond.dim_filmavond_datum_key desc) as rn
	from dm.fact_filmavond
	inner join dm.dim_film on dm.fact_filmavond.Dim_Film_key = dm.dim_film.Dim_Film_Key
	inner join dm.dim_datum_vw on dm.fact_filmavond.dim_filmavond_datum_key = dm.dim_datum_vw.dim_datum_key
	inner join dm.dim_meister on dm.fact_filmavond.Dim_Meister_key = dm.dim_meister.Dim_Meister_key
	where {{filmmeister}}
	and {{filmavonddatum}}
)
select
	  cte.date as "Filmavond"
	, cte.film_title as "Filmtitel"
	, cte.Film_Meister as "Meister"
from cte_rownumber cte
where cte.rn between 1 and 5
;

---------------------------------------
-- DEI SCORE --
---------------------------------------


with AllGenres as (
    select distinct gh.genre_bk
    from bdv.genre_hub gh
)
, 
GenreFilmavondCombinations as (
    select
          fl.filmavond_link_key
        , fl.datum_filmavond_bk
        , fl.film_hub_key
        , ag.genre_bk
    from rdv.filmavond_link fl
    cross join AllGenres ag
)
--select * from GenreFilmavondCombinations; --Debug
,
GenreCountsPerFilm AS (
	SELECT
	      bfgl.Film_Hub_Key
	    , COUNT(bfgl.Film_Genre_Link_Key) AS Genre_Count_per_film
	FROM bdv.film_genre_link bfgl
	GROUP BY bfgl.Film_Hub_Key
)
,
GenreCounts as (
    select
          fl.filmavond_link_key
        , gh.genre_bk
        , count(*) as genre_count
    from rdv.filmavond_link fl
    inner join rdv.film_hub fh
        on fl.film_hub_key = fh.film_hub_key
    inner join bdv.film_genre_link fgl 
        on fh.film_hub_key = fgl.film_hub_key
    inner join bdv.genre_hub gh 
        on fgl.genre_hub_key = gh.genre_hub_key
    group by fl.filmavond_link_key, gh.genre_bk
)
--select * from GenreCounts order by filmavond_link_key; --Debug
, 
CumulativeGenreCount as (
    select
          gfc.filmavond_link_key
        , gfc.datum_filmavond_bk
        , gfc.film_hub_key
        , gfc.genre_bk
        , gcpf.Genre_Count_per_film
        , coalesce(sum((gc.genre_count * (1.0 / gcpf.Genre_Count_per_film))) over (partition by gfc.genre_bk order by gfc.datum_filmavond_bk asc), 0) as count
    from GenreFilmavondCombinations gfc
    left join GenreCounts gc
        on gfc.filmavond_link_key = gc.filmavond_link_key
        and gfc.genre_bk = gc.genre_bk
	inner join GenreCountsPerFilm gcpf
		on gfc.film_hub_key = gcpf.film_hub_key
)
--select * from CumulativeGenreCount order by filmavond_link_key asc; --Debug
,
CalculateAverage as (
	select
          cgc.filmavond_link_key
        , cgc.datum_filmavond_bk
        , cgc.genre_bk
        , cgc.count
		, avg(cgc.count) over (partition by cgc.filmavond_link_key) as AverageGenreCount
		, cgc.count / avg(cgc.count) over (partition by cgc.filmavond_link_key) as Score1
	from CumulativeGenreCount cgc
)
--select * from CalculateAverage order by filmavond_link_key asc; --Debug
,
CalculateScore as (
	select
          ca.filmavond_link_key
        , ca.datum_filmavond_bk
        , ca.genre_bk
        , ca.count
		, ca.AverageGenreCount
		, ca.Score1
		, case
			when ca.Score1 <= 1 then ca.Score1
			when ca.Score1 > 1 and ca.Score1 <= 2 then (2 - ca.Score1)
			when ca.Score1 > 2 then 0
		end as score2
		, case
			when ca.Score1 <= 1 then ca.Score1
			else (2 - Score1)
		end as score3
	from CalculateAverage ca
)
--select * from CalculateScore order by filmavond_link_key asc; --Debug
select
          cs.filmavond_link_key
		, avg(cs.score2) as diversiteit_score
		, avg(cs.score3) as diversiteit_score_hardcore
from CalculateScore cs 
group by cs.filmavond_link_key
--where filmavond_link_key in (1,2,3,4) --Debug
order by filmavond_link_key asc
;







