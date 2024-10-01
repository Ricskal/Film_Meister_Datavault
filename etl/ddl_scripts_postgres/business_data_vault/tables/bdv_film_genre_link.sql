CREATE TABLE IF NOT EXISTS bdv.film_genre_link (
      Film_Genre_Link_Key SERIAL PRIMARY KEY
    , Film_Hub_Key VARCHAR
    , Genre_Hub_Key VARCHAR
);