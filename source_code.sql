/****** Script for SelectTopNRows command from SSMS  ******/

--first load all these tables to a staging database with staging tables
--Analysis on IMDB_MOVIES DATASET
---Check for Duplicate records


Select imdb_title_id from [dbo].[IMDb_movies]
group by imdb_title_id
having count(*) >1
---it is unique
Select top 10 * from [dbo].[IMDb_movies]

--Since there are no dups and one record per imdb_title_id this table can be a dimension table for getting movie descriptions 
--- and voting details.

---movie_names
Select top 10 * from [dbo].[IMDb names]
group by imdb_name_id
having count(*) >1

--Based on the data we need to have one to many relationship table between cast and movie title
--Known titles, cast column
select top 10 imdb_name_id , known_for_titles from [moviesdb].dbo.[IMDb names]


select OtherID, cs.Value known_for_titles --SplitData
from yourtable
cross apply STRING_SPLIT (Data, ',') cs

select imdb_name_id, cs.Value known_for_titles 
into [moviesdb].dbo.[title_2_names_brg]
from (
select 'nm0363527' imdb_name_id ,'tt0416773,tt0109764,tt1618370,tt0207889' known_for_titles
) sub
cross apply STRING_SPLIT (known_for_titles, ',') cs



select * from [moviesdb].dbo.[IMDb_title_principals]
where imdb_name_id='nm0363527'

--will need to explode the known titles columns and convert the column values to rows per imdb_name_id.
--This will be our relationship table

drop table [moviesdb].dbo.[title_2_names_brg]
select top 4 imdb_name_id , cs.Value known_for_titles 
into [moviesdb].dbo.[title_2_names_brg]
from [moviesdb].dbo.[IMDb names]
cross apply STRING_SPLIT (known_for_titles, ',') cs


---Therefore from imdb_names table we will have two tables
--1. Imdb_cast_dim which is imdb_names table with all attributes except known_for_titles
--2. a many to many relationship bridge table with cast_2_title_RLTP Table with imdb_name_id, imdb_title_id blown out



----imdb_ratings is unique
select top 10 * from [moviesdb].dbo.[IMDb_ratings]

--this table could be joined with imdb_movies to have a huge dimension table

---imdb_title_principals
select top 20 * from [dbo].[IMDb_title_principals]

CREATE database movie_DW

use movie_DW

--checked if there are unmatching records

select top 10 *

from moviesdb.dbo.IMDb_movies m
full join moviesdb.dbo.IMDb_ratings r on m.[imdb_title_id]=r.[imdb_title_id]
where m.[imdb_title_id] is null or r.[imdb_title_id] is null

--no records returned
drop table [dbo].[MOVIES_DIM]
---Now create the dataset
select top 100 cast(m.[imdb_title_id] as varchar(50)) imdb_title_id
      ,[title]
      ,[original_title]
      ,[year]
      ,[date_published]
      ,[genre]
      ,[duration]
      ,[country]
      ,[language]
      ,[director]
      ,[writer]
      ,[production_company]
      ,[actors]
      ,[description]
      ,[avg_vote]
      ,[votes]
      ,[budget]
      ,[usa_gross_income]
      ,[worlwide_gross_income]
      ,[metascore]
      ,[reviews_from_users]
      ,[reviews_from_critics]

,r.[weighted_average_vote]
      ,[total_votes]
      ,[mean_vote]
      ,[median_vote]
      ,[votes_10]
      ,[votes_9]
      ,[votes_8]
      ,[votes_7]
      ,[votes_6]
      ,[votes_5]
      ,[votes_4]
      ,[votes_3]
      ,[votes_2]
      ,[votes_1]
      ,[allgenders_0age_avg_vote]
      ,[allgenders_0age_votes]
      ,[allgenders_18age_avg_vote]
      ,[allgenders_18age_votes]
      ,[allgenders_30age_avg_vote]
      ,[allgenders_30age_votes]
      ,[allgenders_45age_avg_vote]
      ,[allgenders_45age_votes]
      ,[males_allages_avg_vote]
      ,[males_allages_votes]
      ,[males_0age_avg_vote]
      ,[males_0age_votes]
      ,[males_18age_avg_vote]
      ,[males_18age_votes]
      ,[males_30age_avg_vote]
      ,[males_30age_votes]
      ,[males_45age_avg_vote]
      ,[males_45age_votes]
      ,[females_allages_avg_vote]
      ,[females_allages_votes]
      ,[females_0age_avg_vote]
      ,[females_0age_votes]
      ,[females_18age_avg_vote]
      ,[females_18age_votes]
      ,[females_30age_avg_vote]
      ,[females_30age_votes]
      ,[females_45age_avg_vote]
      ,[females_45age_votes]
      ,[top1000_voters_rating]
      ,[top1000_voters_votes]
      ,[us_voters_rating]
      ,[us_voters_votes]
      ,[non_us_voters_rating]
      ,[non_us_voters_votes]
into movie_DW.dbo.MOVIES_DIM
from moviesdb.dbo.IMDb_movies m
 join moviesdb.dbo.IMDb_ratings r on m.[imdb_title_id]=r.[imdb_title_id]

drop table movie_DW.dbo.Cast_Names_DIM
Select top 10 cast ([imdb_name_id] as varchar(50)) as imdb_name_id
      ,[name]
      ,[birth_name]
      ,[height]
      ,[bio]
      ,[birth_details]
      ,[birth_year]
      ,[date_of_birth]
      ,[place_of_birth]
      ,[death_details]
      ,[death_year]
      ,[date_of_death]
      ,[place_of_death]
      ,[reason_of_death]
      ,[spouses]
      ,[divorces]
      ,[spouses_with_children]
      ,[children]
      ,[primary_profession]
      ,[known_for_titles]
into movie_DW.dbo.Cast_Names_DIM
from [moviesdb].dbo.[IMDb names]

---Create relationship table
--drop table  Movies_title_2_Cast_name_Bridge
select cast( [imdb_title_id] as varchar(50)) [imdb_title_id]
      ,[ordering]
      ,cast([imdb_name_id] as varchar(50)) imdb_name_id
      ,[category]
      ,[job]
      ,[characters]
into Movies_title_2_Cast_name_Bridge
from moviesdb.[dbo].[IMDb_title_principals]
union all
select cast( known_for_titles as varchar(50)) [imdb_title_id]
      ,null [ordering]
      ,cast([imdb_name_id] as varchar(50)) imdb_name_id
      ,null [category]
      ,null [job]
      ,null [characters]
from [moviesdb].dbo.[title_2_names_brg_remainder]

select *
into [moviesdb].dbo.[title_2_names_brg_remainder]
from (
select known_for_titles , [imdb_name_id] from [moviesdb].dbo.[title_2_names_brg]
except 
select [imdb_title_id], [imdb_name_id] from moviesdb.[dbo].[IMDb_title_principals]
) a
select * from [moviesdb].dbo.[title_2_names_brg_remainder]

ALTER TABLE movie_DW.dbo.MOVIES_DIM
ADD UNIQUE ([imdb_title_id]);

ALTER TABLE movie_DW.dbo.Cast_Names_DIM
ADD UNIQUE ([imdb_name_id])