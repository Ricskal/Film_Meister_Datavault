-- Drop tables --
drop table if exists bdv.film_genre_link;
drop table if exists bdv.genre_hub;
drop table if exists dm.dim_datum;
drop table if exists rdv.film_hub;
drop table if exists rdv.film_sat;
drop table if exists rdv.filmavond_link;
drop table if exists rdv.filmavond_sat;
drop table if exists rdv.meister_hub;
drop table if exists stg.excelsheet;

-- Drop views --
drop view if exists bdv.film_hub;
drop view if exists bdv.film_sat;
drop view if exists bdv.filmavond_link;
drop view if exists bdv.filmavond_sat;
drop view if exists bdv.meister_hub;
drop view if exists dm.dim_datum_vw;
drop view if exists dm.dim_film;
drop view if exists dm.dim_meister;
drop view if exists dm.fact_filmavond;
drop view if exists stg.excelsheet_vw;
drop view if exists dm.dim_film_genre;

-- STG --
select * from stg.excelsheet;
select * from stg.excelsheet_vw;

-- RDV --
select * from rdv.film_hub;
select * from rdv.film_sat order by film_hub_key desc;
select * from rdv.filmavond_link order by laaddatum desc;
select * from rdv.filmavond_sat;
select * from rdv.meister_hub;

select *
from rdv.filmavond_link rfl
join rdv.filmavond_sat rfs on rfl.Filmavond_Link_Key = rfs.Filmavond_Link_Key
join rdv.film_hub rfh on rfl.Film_Hub_Key = rfh.Film_Hub_Key
join rdv.film_sat rfs2 on rfh.Film_Hub_Key =  rfs2.Film_Hub_Key
join rdv.meister_hub rmh on rfl.Meister_Hub_Key = rmh.Meister_Hub_Key
order by rfl.laaddatum  desc
;

-- BDV --
select * from bdv.film_hub;
select * from bdv.film_sat;
select * from bdv.filmavond_link;
select * from bdv.filmavond_sat;
select * from bdv.meister_hub;
select * from bdv.film_genre_link;
select * from bdv.genre_hub;

select *
from bdv.filmavond_link bfl
join bdv.filmavond_sat bfs on bfl.Filmavond_Link_Key = bfs.Filmavond_Link_Key
join bdv.film_hub bfh on bfl.Film_Hub_Key = bfh.Film_Hub_Key
join bdv.film_sat bfs2 on bfh.Film_Hub_Key = bfs2.Film_Hub_Key
join bdv.meister_hub bmh on bfl.Meister_Hub_Key = bmh.Meister_Hub_Key
join bdv.film_genre_link bfgl on bfh.Film_Hub_Key = bfgl.Film_Hub_Key
join bdv.genre_hub bgh on bfgl.Genre_Hub_Key = bgh.Genre_Hub_Key;

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
join dm.dim_meister ddm on dff.Dim_Meister_key = ddm.Dim_Meister_Key
join dm.dim_film_genre dfg on dff.Dim_Film_key = dfg.Dim_Film_Key
--join dm.dim_datum ddd on dff.Dim_Filmavond_Datum_key = ddd.Dim_Datum_Key
join dm.dim_datum_vw ddv on dff.Dim_Filmavond_Datum_key = ddv.Dim_Datum_Key
;