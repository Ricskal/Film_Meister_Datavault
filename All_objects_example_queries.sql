-- STG --
select * from stg_excelsheet;
select * from stg_excelsheet_vw;

-- RDV --
select * from rdv_film_hub;
select * from rdv_film_sat;
select * from rdv_filmavond_link;
select * from rdv_filmavond_sat;
select * from rdv_meister_hub;

select
	*
from rdv_filmavond_link rfl
join rdv_filmavond_sat rfs on rfl.Filmavond_Link_Key = rfs.Filmavond_Link_Key
join rdv_film_hub rfh on rfl.Film_Hub_Key = rfh.Film_Hub_Key
join rdv_film_sat rfs2 on rfh.Film_Hub_Key =  rfs2.Film_Hub_Key
join rdv_meister_hub rmh on rfl.Meister_Hub_Key = rmh.Meister_Hub_Key;

-- BDV --
select * from bdv_film_hub;
select * from bdv_film_sat;
select * from bdv_filmavond_link;
select * from bdv_filmavond_sat;
select * from bdv_meister_hub;
select * from bdv_film_genre_link;
select * from bdv_genre_hub;

select
	*
from bdv_filmavond_link bfl
join bdv_filmavond_sat bfs on bfl.Filmavond_Link_Key = bfs.Filmavond_Link_Key
join bdv_film_hub bfh on bfl.Film_Hub_Key = bfh.Film_Hub_Key
join bdv_film_sat bfs2 on bfh.Film_Hub_Key = bfs2.Film_Hub_Key
join bdv_meister_hub bmh on bfl.Meister_Hub_Key = bmh.Meister_Hub_Key
join bdv_film_genre_link bfgl on bfh.Film_Hub_Key = bfgl.Film_Hub_Key
join bdv_genre_hub bgh on bfgl.Genre_Hub_Key = bgh.Genre_Hub_Key;

-- DM --








