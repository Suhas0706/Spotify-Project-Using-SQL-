create database spoo;
use spoo;

CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
-- eda 
select count(*) from spotify;

select DISTINCT album_type From spotify;

select  max(duration_min) From spotify;
select  min(duration_min) From spotify;

select * from spotify 
where duration_min = 0;

DELETE from spotify 
where duration_min = 0;
select * from spotify 
where duration_min = 0;

select DISTINCT channel From spotify;

select DISTINCT most_playedon From spotify;

--------------------------------------------------------
-----Data Analysis -Easy Category
--------------------------------------------------------

--Q.1 Retrive the names of all tracks that have more than 1 billion streams.

SELECT * FROM spotify
WHERE stream > 1000000000


--Q.2 List all albums along with their respective artists

SELECT 
album,artist
 FROM spotify;

select 
  distinct album, artist
from spotify
order by 1  

select 
  distinct album
from spotify
order by 1  

-----Q.3 Get the total of comments for tracks where licensed = TRUE.

Select 
sum(comments) as total_comments
from spotify
where licensed = 'true'

-----Q.4 Find all tracks that belongs to the album type single.
select * from spotify
where album_type = 'single'

-----Q.5 Count the total number of tracks by each artist

select
artist,
count(*) as total_no_songs
from spotify
group by artist
order by 2 
----------------------------------------------------------------------
--Q.6 Calculate the average danceability of tracks in each album
select 
album,
avg(danceability) as avg_danceability
from spotify
group by 1
order by 2 desc

--Q.7 Find the top 5 tracks with the highest energy values
select 
  track,
  max(energy)
from spotify
group by 1
order by 2 desc
limit 5

--Q.8 List all tracks along with their views and likes where official_video = TRUE
SELECT
    track,
    sum(Views) AS total_views
    SUM(likes) AS total_likes
FROM
    spotify
WHERE
    official_video = 'true'
GROUP BY
    1
ORDER BY
    2 DESC
    
--Q.9 For each album calculate the total views of all associated tracks
select 
album,
track,
sum(Views)
from spotify 
group by 1, 2   

--Q.10 Retrieve the track names have been streamed on spotify more than YouTube
select * from 
(select
track,
coalesce(sum(case when most_playedon = 'Youtube' then stream end),0) as streamed_on_youtube,
coalesce(sum(case when most_playedon = 'Youtube' then stream end),0) as streamed_on_spotify
from spotify
group by 1
) as t1
where streamed_on_spotify > streamed_on_youtube
and
streamed_on_youtube <> 0
---------------------------------------------------------------------------
--Q.11 Find the 3 most-viewed tracks for each artist using window function

WITH ranking_artist AS (
  SELECT
    artist,
    track,
    SUM(views) AS total_view,
    DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(Views) DESC) AS `rank`
  FROM spotify
  GROUP BY
    1,
    2
  ORDER BY
    1,
    3 DESC
)
SELECT
  *
FROM ranking_artist
WHERE
  `rank` <= 3;
  
  --- Q.12 Write a query to find tracks where the liveness score is above the average
  SELECT 
	track,
	artist, 
	liveness
 FROM spotify
 WHERE liveness >(SELECT AVG(liveness) FROM spotify)
 
 --Q.13 Use a WITH clasue to calculate the difference between the highest and lowest energy values for tracks in each album
 
 WITH cte
 AS 
(SELECT 
	album,
    MAX(energy) as higest_energy,
    MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT	
	album,
     higest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC     
 