-- Netflix Data Analysis using SQL
-- Solutions of 15 Business Problems

-- 1. Count the Number of Movies vs TV Shows

SELECT
    SUM(CASE WHEN type = 'Movie' THEN 1 ELSE 0 END) AS numofmovies,
    SUM(CASE WHEN type = 'TV Show' THEN 1 ELSE 0 END) AS numofTVShows
FROM netflix;


-- 2. Find the Most Common Rating for Movies and TV Shows Separately

WITH cte AS (
    SELECT
        rating,
        COUNT(*) AS numofratings,
        type
    FROM netflix
    GROUP BY rating, type
),
join_ AS (
    SELECT
        rating,
        type,
        RANK() OVER (PARTITION BY type ORDER BY numofratings DESC)
    FROM cte
)
SELECT
    rating AS most_common_rating,
    type
FROM join_
WHERE rank = 1;


-- 3. List All Movies Released in 2018

SELECT *
FROM netflix
WHERE release_year = 2018
    AND type = 'Movie';


-- 4. Find the Top 5 Countries with the Most Content on Netflix
-- Count each title under every country listed, trimming surrounding spaces from country names.

WITH cte AS (
    SELECT
        *,
        TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS single_country
    FROM netflix
)
SELECT
    single_country,
    COUNT(*) AS numofcontentpercountry
FROM cte
GROUP BY single_country
ORDER BY numofcontentpercountry DESC
LIMIT 5;


-- 5. Identify the Longest Movie and Show Its Title and Duration

WITH cte AS (
    SELECT
        *,
        CAST(REPLACE(duration, ' min', '') AS INT) AS duration_int
    FROM netflix
    WHERE type = 'Movie'
        AND duration IS NOT NULL
)
SELECT
    title,
    duration
FROM cte
ORDER BY duration_int DESC
LIMIT 1;


-- 6. Find Content Added in the Last 10 Years

WITH cte AS (
    SELECT
        *,
        TO_DATE(date_added, 'Month DD, YYYY') AS new_date
    FROM netflix
)
SELECT *
FROM cte
WHERE AGE(CURRENT_DATE, new_date) <= INTERVAL '10 years'
    AND new_date IS NOT NULL;


-- 7. Find All Movies and TV Shows Whose Director Field Contains 'Rajiv Chilaka'

SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';


-- 8. List All TV Shows with More Than 5 Seasons, Ordered by Season Count from Highest to Lowest

WITH cte AS (
    SELECT
        *,
        CASE
            WHEN duration ~* '\m1\M'
                THEN CAST(REPLACE(duration, ' Season', '') AS INT)
            WHEN duration ~* '\mSeasons\M'
                THEN CAST(REPLACE(duration, ' Seasons', '') AS INT)
        END AS duration_int
    FROM netflix
)
SELECT
    title,
    type,
    duration
FROM cte
WHERE type = 'TV Show'
    AND duration_int > 5
    AND duration_int IS NOT NULL
ORDER BY duration_int DESC;


-- 9. Count the Number of Content Items in Each Genre
-- Trim surrounding spaces from genre names and order the counts from highest to lowest.

WITH cte AS (
    SELECT
        *,
        TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS genre
    FROM netflix
)
SELECT
    genre,
    COUNT(*) AS numofcontentitems
FROM cte
GROUP BY genre
ORDER BY numofcontentitems DESC;


-- 10. Find the Top 5 Release Years with the Most Titles Listed Exclusively Under India
-- Show the country, release year, number of titles, and each year's percentage of all titles
-- whose country is exactly 'India'.

SELECT
    country,
    release_year,
    COUNT(*) AS total_release,
    ROUND(
        ((COUNT(*)::numeric) /
        ((SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric)) * 100,
        2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY release_year, country
ORDER BY total_release DESC
LIMIT 5;


-- 11. List All Movies Whose Genres Include Documentaries

SELECT *
FROM netflix
WHERE type = 'Movie'
    AND listed_in ILIKE '%Documentaries%';


-- 12. Find All Content with a Missing Director

SELECT *
FROM netflix
WHERE director IS NULL;


-- 13. Count Movies Featuring 'Salman Khan' with a Release-Year Difference of 10 or Less
-- Compare the release year with the current year, including the cutoff year.

WITH cte AS (
    SELECT *
    FROM netflix
    WHERE casts LIKE '%Salman Khan%'
        AND type = 'Movie'
)
SELECT
    COUNT(*) numofmovies
FROM cte
WHERE EXTRACT(YEAR FROM CURRENT_DATE) - release_year <= 10;


-- 14. Find the Top 10 Actors with the Most Appearances in Movies Listed Exclusively Under India
-- Include only movies whose country is exactly 'India', and trim surrounding spaces from actor names.

WITH cte AS (
    SELECT
        *,
        TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) AS actor
    FROM netflix
    WHERE country = 'India'
        AND type = 'Movie'
)
SELECT
    actor,
    COUNT(*) AS numofmoviesperactor
FROM cte
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;


-- 15. Categorize Content Using 'Kill' and 'Violence' in the Description
-- Label descriptions containing either text pattern as 'Bad' and all others as 'Good'.
-- Match without regard to capitalization, including occurrences within longer words.
-- Count the items in each category separately for movies and TV shows.

WITH cte AS (
    SELECT
        *,
        CASE
            WHEN description ILIKE '%kill%' THEN 'Bad'
            WHEN description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
)
SELECT
    category,
    type,
    COUNT(*) AS numofitemspercategory
FROM cte
GROUP BY category, type
ORDER BY type;


-- End of Reports
