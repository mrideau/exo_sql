USE videoflix_db;

-- 1
SELECT title, year FROM movie;
-- 2
SELECT year FROM movie WHERE title='American Beauty';
-- 3
SELECT title FROM movie WHERE year='1999';
-- 4
SELECT title FROM movie WHERE year<'1998';
-- 5
SELECT lastname FROM user LEFT JOIN movie_review ON user.id = movie_review.user_id;
-- 6
SELECT lastname FROM user LEFT JOIN movie_review ON user.id = movie_review.user_id AND movie_review.stars >= 6;
-- 7
SELECT title FROM movie LEFT JOIN movie_review ON movie.id = movie_review.movie_id AND movie_review.stars = NULL;
-- 8
SELECT title FROM movie WHERE id IN (5,6,8);
-- 9
SELECT title, year FROM movie WHERE title LIKE '%Boogie%' OR '%Night%';
-- 10
SELECT id FROM staff WHERE firstname='Woody' AND lastname='Allen';
-- 1
SELECT * FROM staff WHERE id=(SELECT staff_id FROM movie_casting LEFT JOIN movie ON movie_casting.movie_id = movie.id WHERE movie.title='Annie Hall');
-- 2
SELECT lastname, firstname FROM staff WHERE id=(
	SELECT staff_id FROM movie_direction NATURAL JOIN movie_casting WHERE movie_direction.staff_id = movie_casting.staff_id
);
-- 3
SELECT title FROM movie WHERE country!='US';
-- 4
SELECT title, year, released_at, CONCAT(firstname, ' ', lastname) FROM movie
	INNER JOIN movie_casting ON movie.id = movie_casting.movie_id
	INNER JOIN movie_direction direction ON movie.id = direction.movie_id
	INNER JOIN staff ON staff.id = movie_casting.staff_id OR staff.id = direction.staff_id;
-- 5
SELECT * FROM staff
    INNER JOIN movie_casting ON staff.id = movie_casting.staff_id
	INNER JOIN movie_direction ON staff.id = movie_direction.staff_id;
-- 6
SELECT title FROM movie WHERE id=(SELECT id FROM staff WHERE firstname='Woody' AND lastname='Allen');
-- 7
SELECT year FROM movie INNER JOIN movie_review ON movie.id = movie_review.movie_id WHERE movie_review.stars > 3 ORDER BY year;
-- 8
SELECT title FROM movie LEFT JOIN movie_watch ON movie.id = movie_watch.user_id WHERE movie_watch.user_id IS NULL AND movie.country IN('US', 'FR');
-- 9
SELECT firstname, lastname FROM user LEFT JOIN movie_review ON user.id = movie_review.user_id WHERE movie_review.user_id IS NULL;
-- 10
SELECT firstname, lastname FROM user INNER JOIN movie_review ON user.id = movie_review.user_id GROUP BY movie_review.user_id HAVING COUNT(user.id) > 1 ;
-- 11
SELECT type, MAX(stars) FROM genre
	INNER JOIN movie_genre ON genre.id = movie_genre.genre_id
    INNER JOIN movie ON movie_genre.movie_id = movie.id
	INNER JOIN movie_review ON movie.id = movie_review.movie_id GROUP BY type;
-- 12
SELECT firstname, lastname FROM user
	INNER JOIN movie_review ON user.id = movie_review.user_id
    INNER JOIN movie ON movie_review.movie_id = movie.id WHERE movie.title = 'American Beauty';
-- 13
SELECT firstname, lastname, roles FROM staff
	INNER JOIN movie_casting ON staff.id = movie_casting.staff_id
    INNER JOIN movie ON movie.id = movie_casting.movie_id WHERE movie.title = 'Annie Hall';
-- 14
SELECT firstname, lastname, year FROM staff
	INNER JOIN movie_direction ON staff.id = movie_direction.staff_id
	INNER JOIN movie ON movie_direction.movie_id = movie.id WHERE movie.title = 'Eyes Wide Shut';
-- 15
SELECT title, firstname, lastname FROM staff
	INNER JOIN movie_casting ON staff.id = movie_casting.staff_id
    INNER JOIN movie ON movie.id = movie_casting.movie_id WHERE movie_casting.starred_as = 'Sean Maguire';
-- 16
SELECT firstname, lastname FROM staff
	INNER JOIN movie_casting ON staff.id = movie_casting.staff_id WHERE movie_casting.movie_id NOT IN(SELECT year FROM movie WHERE year BETWEEN 1990 AND 2000);
-- 17
SELECT firstname, lastname, COUNT(type) FROM (
	SELECT staff.*, genre.type FROM genre
		INNER JOIN movie_genre ON genre.id = movie_genre.genre_id
        INNER JOIN movie ON movie_genre.movie_id = movie.id
        INNER JOIN movie_direction ON movie.id = movie_direction.movie_id
        INNER JOIN staff ON movie_direction.staff_id = staff.id
) genres_per_director GROUP BY id ORDER BY lastname;
-- 18
SELECT title, year, released_at, type FROM movie
	INNER JOIN movie_genre ON movie.id = movie_genre.movie_id
	INNER JOIN genre ON movie_genre.genre_id = genre.id;
-- 19
SELECT title, year, type, firstname, lastname FROM movie
	INNER JOIN movie_genre ON movie.id = movie_genre.movie_id
	INNER JOIN genre ON movie_genre.genre_id = genre.id
	INNER JOIN movie_direction ON movie.id = movie_direction.movie_id
	INNER JOIN staff ON movie_direction.staff_id = staff.id;
-- 20
SELECT title, year, released_at, time, firstname, lastname FROM movie
	INNER JOIN movie_direction ON movie.id = movie_direction.movie_id
	INNER JOIN staff ON movie_direction.staff_id = staff.id
    WHERE released_at < '1989-01-01'
    ORDER BY year DESC;
-- 21
SELECT type, AVG(time) FROM (
	SELECT movie.*, genre.type FROM genre
    INNER JOIN movie_genre ON genre.id = movie_genre.genre_id
	INNER JOIN movie ON movie_genre.movie_id = movie.id
) avg_time_per_genre GROUP BY type;
-- 22
SELECT type, COUNT(type), AVG(stars) FROM (
	SELECT type, stars FROM genre
    LEFT JOIN movie_genre ON genre.id = movie_genre.genre_id
    LEFT JOIN movie_review ON movie_genre.movie_id = movie_review.movie_id WHERE stars > 4
) avg_stars_per_genre GROUP BY type;
-- 23
SELECT CONCAT(firstname, ' ', lastname) user, SUM(time_watched) time_watched FROM (
	SELECT user.*, time_watched FROM movie_watch
		INNER JOIN user ON movie_watch.user_id = user.id
) top_10_viewers GROUP BY id ORDER BY time_watched DESC LIMIT 10;
-- 24
SELECT CONCAT(firstname, ' ', lastname) user, email, SUM(time_watched) time_watched FROM (
	SELECT user.*, time_watched FROM movie_watch
		INNER JOIN user ON movie_watch.user_id = user.id
) nottop_5_viewers GROUP BY id ORDER BY time_watched ASC LIMIT 5;
-- 25
SELECT title, ROUND(sum_stars) FROM (
	SELECT movie.id, movie.title, time_watched, sum_stars FROM movie
		INNER JOIN movie_watch ON movie.id = movie_watch.movie_id
        INNER JOIN (
			SELECT movie_id, SUM(stars) sum_stars FROM movie_review GROUP BY movie_id
        ) movie_stars_sum ON movie.id = movie_stars_sum.movie_id
) movies GROUP BY id ORDER BY SUM(time_watched) DESC LIMIT 3;
-- 26
SELECT title FROM movie
	INNER JOIN movie_watch ON movie.id = movie_watch.movie_id
    LEFT JOIN movie_review ON movie.id = movie_review.movie_id WHERE movie_review.movie_id IS NULL
    GROUP BY id;
-- 27
SELECT type FROM movie_watch
    INNER JOIN movie_genre ON movie_watch.movie_id = movie_genre.movie_id
    INNER JOIN genre ON movie_genre.genre_id = genre.id WHERE YEAR(created_at) = 2020
    GROUP BY type;
-- 28
SELECT CONCAT(firstname, ' ', lastname) FROM user
	LEFT JOIN movie_watch ON user.id = movie_watch.user_id WHERE movie_watch.user_id IS NULL;
-- 29

-- 30
SELECT CONCAT(firstname, ' ', lastname), MONTHNAME(created_at) month, SUM(time_watched) FROM movie_watch
	INNER JOIN user ON movie_watch.user_id = user.id WHERE YEAR(created_at) = 2021 GROUP BY id, month;
-- 31
-- PAS FINI
SELECT user_id, month FROM (
	SELECT user_id, MONTHNAME(created_at) month, SUM(time_watched) time_watched FROM movie_watch GROUP BY user_id, month ORDER BY user_id, time_watched DESC
) time_watched_per_month_per_user WHERE MAX(time_watched) = (SELECT MAX(time_watched) FROM time_watched_per_month_per_user) GROUP BY user_id;

SELECT user_id, MONTHNAME(created_at) month, SUM(time_watched) time_watched FROM movie_watch GROUP BY user_id, month;

SELECT MAX(time_watched)
FROM (SELECT user_id, MONTH(time_watched) month, SUM(time_watched) time_watched FROM movie_watch GROUP BY user_id, MONTH(created_at)) A
GROUP BY user_id;

SELECT id, month, MAX(time_watched) FROM user
INNER JOIN (SELECT user_id, MONTH(created_at) month, SUM(time_watched) time_watched FROM movie_watch GROUP BY user_id, month) a
ON user.id = a.user_id
GROUP BY id;

SELECT user_id, MONTH(created_at) month, SUM(time_watched) time_watched FROM movie_watch GROUP BY user_id, month