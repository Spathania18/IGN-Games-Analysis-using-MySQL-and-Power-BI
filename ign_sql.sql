-- DATA PREPROCESSING



SELECT * FROM IGN;


-- Since we have no use for url Column, lets drop it out
ALTER TABLE IGN
DROP COLUMN url;

-- Checking missing values IN TITLE 
SELECT
*
FROM
IGN
WHERE
title IS NULL;

-- CHECKING REPEATING VALUES
SELECT 
title,
COUNT(*) AS CT
FROM 
IGN
GROUP BY 
title, platform
HAVING
COUNT(*) > 1;

-- repeated values
CREATE temporary TABLE TABLE1
SELECT
*,
ROW_NUMBER() OVER (PARTITION BY title, platform ORDER BY title) as ROWNUMBER
FROM 
IGN;


SELECT
*
FROM TABLE1
WHERE
ROWNUMBER = 2;

-- CREATING NEW TABLE WITH NO REAPETED VALUES
CREATE TABLE NEW_IGN AS
SELECT
*
FROM TABLE1
WHERE
ROWNUMBER = 1;



-- EXPLORATORY DATA ANALYSIS



SELECT * FROM new_ign;

ALTER TABLE new_ign
DROP COLUMN ROWNUMBER;

-- Total games rated each year
SELECT 
COUNT(title) AS Number_of_games,
release_year
FROM
new_ign
GROUP BY 
release_year
ORDER BY
COUNT(title) DESC;

-- Most used platform for rating games
SELECT 
platform, 
COUNT(platform) as Total_platforms
FROM
new_ign
GROUP BY
platform
ORDER BY
Total_platforms DESC;

-- Avg rating by platform used
SELECT 
round(AVG(score),2) AS avg_score,
platform
from
new_ign
GROUP BY
platform
ORDER BY
avg_score DESC;

-- Avg rating by game genre
SELECT 
round(AVG(score),2) AS avg_score,
genre
from
new_ign
GROUP BY
genre
ORDER BY
avg_score DESC;

-- BEST YEAR FOR GAMERS (COUNT OF GAMES THAT WERE AMAZING OR GREAT OR GOOD BY YEAR)
SELECT
SUM(Game_count) as Great_games_released,
release_year
FROM(
SELECT
COUNT(score_phrase) as Game_count,
score_phrase,
release_year
FROM
new_ign
GROUP BY
score_phrase,
release_year
HAVING
score_phrase IN ('Amazing','Great', "Good") 
) as table_1
GROUP BY
release_year
ORDER BY
Great_games_released DESC;

-- FIGURING OUT WHICH MONTH MOST GAMES ARE RELEASED
SELECT
COUNT(title) AS number_of_games,
release_month
FROM
new_ign
GROUP BY
release_month
ORDER BY
number_of_games DESC;

-- CHECKING IF EDITORS'S CHOICE HAVE A RELATION TO RATING OF GAME
SELECT
Round(AVG(score), 2)as average_score,
editors_choice
FROM
new_ign
GROUP BY
editors_choice;

-- TOP 10 GAMES OF ALL TIME
SELECT
DISTINCT(title),
score
FROM
new_ign
HAVING
score = 10
ORDER BY
score DESC;



