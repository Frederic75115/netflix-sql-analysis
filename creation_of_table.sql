-- Schema of Netflix

CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(7),
    title        VARCHAR(104),
    director     VARCHAR(208),
    casts        VARCHAR(771),
    country      VARCHAR(123),
    date_added   VARCHAR(19),
    release_year INT,
    rating       VARCHAR(8),
    duration     VARCHAR(10),
    listed_in    VARCHAR(79),
    description  VARCHAR(250)
);

SELECT * FROM netflix;
