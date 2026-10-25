# Netflix Movies and TV Shows Analysis with SQL

## Project Overview

This project uses PostgreSQL to explore Netflix movies and TV shows through 15 business questions. The analysis examines content types, audience ratings, countries, release years, genres, durations, directors, and actor appearances.

I developed this project to practice translating questions into SQL queries, cleaning text before aggregation, and interpreting the results accurately. I used pgAdmin 4 to create the table, import the dataset, and work with the queries.

## Objectives

- Compare the number of movies and TV shows and identify their most common ratings.
- Examine content distribution across countries, genres, and release years.
- Identify the longest movie and TV shows with more than five seasons.
- Explore Indian content and actors' movie appearances.
- Analyze recently added titles and missing director information.
- Classify descriptions using keyword matching.

## Tools and SQL Techniques

| Tool or technique | Application |
| --- | --- |
| PostgreSQL and pgAdmin 4 | Database setup and SQL analysis |
| Common table expressions (`WITH`) | Organizing queries into readable steps |
| `COUNT()`, `SUM()`, and `GROUP BY` | Summarizing titles by category |
| `RANK()` with `PARTITION BY` | Finding the most common rating separately for movies and TV shows |
| `STRING_TO_ARRAY()` and `UNNEST()` | Expanding comma-separated countries, genres, and actors into rows |
| `TRIM()` | Removing surrounding spaces before grouping names |
| `CASE` | Conditional counts, duration conversion, and keyword classification |
| `REPLACE()` and `CAST()` | Converting duration text into integers |
| `TO_DATE()`, `AGE()`, and `EXTRACT()` | Converting dates and filtering by time |
| `LIKE`, `ILIKE`, and regular expressions | Matching names, genres, keywords, and duration patterns |
| Numeric casting and `ROUND()` | Calculating release percentages without integer truncation |

## Dataset

The project uses the **Netflix Movies and TV Shows** dataset. Each record contains a title's identifying information and catalog metadata.

- [Kaggle dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows)

The table contains 12 columns:

| Column | Description |
| --- | --- |
| `show_id` | Title identifier |
| `type` | Movie or TV Show |
| `title` | Content title |
| `director` | Listed director or directors |
| `casts` | Listed cast members |
| `country` | Listed country or countries |
| `date_added` | Date added to Netflix, stored as text |
| `release_year` | Release year |
| `rating` | Audience rating classification |
| `duration` | Movie length or number of TV seasons |
| `listed_in` | Genre classifications |
| `description` | Content synopsis |

This is a historical dataset, so the analysis describes the supplied records rather than Netflix's current catalog.

## Repository Files

| File | Purpose |
| --- | --- |
| [business_questions.sql](business_questions.sql) | Lists the 15 analysis questions |
| [creation_of_table.sql](creation_of_table.sql) | Creates the Netflix table and includes a preview query |
| [solutions.sql](solutions.sql) | Contains the SQL solutions |

## Business Questions

1. Count the number of movies vs TV shows.
2. Find the most common rating for movies and TV shows separately.
3. List all movies released in 2018.
4. Find the top five countries with the most content on Netflix.
5. Identify the longest movie and show its title and duration.
6. Find content added in the last 10 years.
7. Find all movies and TV shows whose director field contains **Rajiv Chilaka**.
8. List all TV shows with more than five seasons, ordered by season count from highest to lowest.
9. Count the number of content items in each genre.
10. Find the top five release years with the most titles listed exclusively under India, showing each year's count and percentage of all such Indian titles.
11. List all movies whose genres include documentaries.
12. Find all content with a missing (`NULL`) director.
13. Count movies featuring **Salman Khan** whose release year differs from the current year by 10 or less, including the cutoff year.
14. Find the top 10 actors with the most appearances in movies listed exclusively under India.
15. Classify descriptions containing **kill** or **violence** as **Bad**, and all others as **Good**, then count each category separately for movies and TV shows.

## Data Cleaning and Analysis Choices

### Consistent country, genre, and actor names

Country, genre, and cast fields can contain multiple comma-separated values. I split these values into individual rows and applied `TRIM()` before grouping them. This combines entries such as `'Anupam Kher'` and `' Anupam Kher'` into one actor count.

A title associated with multiple countries or genres contributes to each listed group. These group counts therefore need not sum to the total number of titles.

### Indian content release percentages

Questions 10 and 14 use `country = 'India'`, which excludes multinational entries such as `'India, United States'`.

For question 10, the percentage is:

**Indian titles released in a given year / Indian titles across all release years × 100**

The output alias `avg_release` is retained in the SQL, but the calculation represents a percentage rather than an average.

### Time windows

Question 6 uses a 10-year threshold based on `date_added`. Question 13 compares the current year with `release_year` and includes the cutoff year. Both use `CURRENT_DATE`, so their results change over time. The queries do not separately exclude future dates or release years.

### Keyword classification

Question 15 uses case-insensitive substring matching. Words such as **killer** and **killing** also match the pattern **kill**. The Good/Bad categories indicate keyword matches only; a missing description falls into Good under the query's `ELSE` condition.

## How to Run the Project

1. Download the dataset and the repository's SQL files.
2. Create or select a PostgreSQL database in pgAdmin 4.
3. Run the `CREATE TABLE` statement in `creation_of_table.sql`.
4. Import the CSV into `netflix`, using a header row and comma delimiter. Map the source CSV's `cast` field to the table's `casts` column and import missing values as SQL `NULL`.
5. Run the preview query to inspect the imported records.
6. Open `solutions.sql` and execute the numbered queries.

## What I Learned

This project strengthened my understanding of CTEs, window functions, text cleaning, date calculations, and aggregation. It also demonstrated why query definitions matter: surrounding spaces can split counts, integer division can distort percentages, and an unclear time window can change which records qualify.

## Acknowledgment

[Najir H.'s Netflix SQL project](https://github.com/najirh/netflix_sql_project) provided inspiration for the business questions and project structure. The SQL solutions in this repository are my own original implementations and differ from Najir's solutions in query structure, filtering, text cleaning, and output detail. I adapted selected questions and made my own analysis choices, including the release year, 10-year time windows, and trimming country, genre, and actor names before aggregation.

## Author

**Frederic Amougou**

[GitHub](https://github.com/Frederic75115) | [LinkedIn](https://www.linkedin.com/in/frederic-amougou-1bb960307/)
