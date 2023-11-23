--2023 ST.LOUIS CARDINALS DATA--

--Return all data for the pitching, batting, and game results tables--
SELECT *
FROM team_pitching$;

SELECT *
FROM team_batting$;

SELECT *
FROM game_results$;


--Delete irrelevant/unneeded columns--
ALTER TABLE team_pitching$
DROP COLUMN Rk, complete_games, shutouts, intentional_walks, so_w;

ALTER TABLE team_batting$
DROP COLUMN Rk, at_bats, sh, sf, ibb;


--Insert information into an existing column in the game_results table--
UPDATE game_results$
SET innings = 9
WHERE innings IS NULL;


--Add a new column named "throws" in the existing team_pitching table and then insert values for the new column--
ALTER TABLE team_pitching$
ADD throws VARCHAR(255);

UPDATE team_pitching$
SET throws = 'R'
WHERE name IN('Miles Mikolas', 'Jack Flaherty', 'Adam Wainwright','Dakota Hudson', 'Jake Woodford', 'Ryan Helsley',
              'Andre Pallante', 'Drew VerHagen', 'Giovanny Gallegos', 'Chris Stratton', 'Jordan Hicks',
			  'Casey Lawrence', 'James Naile', 'Jacob Barnes', 'Ryan Tepera', 'Ryan Tepera', 'Guillermo Zuñiga', 
			  'Kyle Leahy');

UPDATE team_pitching$
SET throws = 'L'
WHERE name IN('Jordan Montgomery', 'Steven Matz','Drew Rom', 'Matthew Liberatore', 'Zack Thompson', 'JoJo Romero', 
              'Génesis Cabrera', 'Andrew Suárez', 'John King', 'Packy Naughton');


--How many different picthers pitched for the Cardinals this year--
SELECT COUNT(*) AS pitchers_used
FROM team_pitching$;


--How many pitchers throw right-handed vs left-handed--
SELECT throws, COUNT(*) AS number_of_pitchers
FROM team_pitching$
GROUP BY throws;


--Who pitched the most innings this year--
SELECT TOP 5 name, innings_pitched
FROM team_pitching$
ORDER BY innings_pitched DESC;


--What pitchers had more than 100 strikeouts--
SELECT name, SUM(strikeouts) number_of_strikeouts
FROM team_pitching$
GROUP BY name
HAVING SUM(strikeouts) > 100
ORDER BY number_of_strikeouts DESC;


--Concatenate the first and last name columns--
SELECT CONCAT(first_name, ' ', last_name) AS full_name, position
FROM team_batting$;


--Which five players had the most hits over the course of the season--
SELECT TOP 5 CONCAT(first_name, ' ', last_name) AS full_name, SUM(hits) AS total_hits
FROM team_batting$
GROUP BY CONCAT(first_name, ' ', last_name)
ORDER BY SUM(hits) DESC;


--What players had 500-700 plate appearances--
SELECT CONCAT(first_name, ' ', last_name) AS full_name, SUM(plate_appearances) AS total_plate_appearances
FROM team_batting$
GROUP BY CONCAT(first_name, ' ', last_name)
HAVING SUM(plate_appearances) BETWEEN 500 AND 700
ORDER BY total_plate_appearances DESC;


--How long was the longest game played--
SELECT TOP 1 CONVERT(time(0), time) AS longest_game
FROM game_results$
ORDER BY longest_game DESC;


--Which days of the week had the most/least overall attendance--
SELECT day_of_week, SUM(attendance) AS attendance
FROM game_results$
WHERE home_away = 'home'
GROUP BY day_of_week
ORDER BY attendance DESC;


--How many extra inning games did the Cardinals play--
SELECT COUNT(*) AS extra_inning_games
FROM game_results$
WHERE  innings <> 9;


--What home game had the least amount of attendance--
SELECT TOP 1 opponent, MIN(attendance) AS least_attended_amount
FROM game_results$
WHERE home_away = 'home'
GROUP BY opponent
ORDER BY least_attended_amount ASC;


--List of teams that the Cardinals played this year--
SELECT DISTINCT opponent
FROM game_results$;


--What was the average attendance for home day games--
SELECT ROUND(AVG(attendance),0) AS averge_daygame_attendance
FROM game_results$
WHERE day_night_game = 'D' AND home_away = 'home';
	

--What was the average attendance for home night games--
SELECT ROUND(AVG(attendance),0) AS averge_nightgame_attendance
FROM game_results$
WHERE day_night_game = 'N' AND home_away = 'home';


--What days of the week did the Cardinals have the most wins--
SELECT day_of_week, COUNT(*) AS number_of_wins
FROM game_results$
WHERE wins_losses = 'W'
GROUP BY day_of_week
ORDER BY number_of_wins DESC;


--What were the longest losing and winnings streaks for the season--
SELECT MIN(winning_losing_streak) AS longest_losing_streak, MAX(winning_losing_streak) AS longest_winning_streak
FROM game_results$;


--Return information regarding the games played only in the month of June--
SELECT day_of_week, date, wins_losses, opponent
FROM game_results$
WHERE date LIKE 'June%';


--What was the difference between the shortest and longest games of the year--
SELECT DATEDIFF(MINUTE, MIN(time), MAX(time)) / 60 AS hours,
       DATEDIFF(MINUTE, MIN(time), MAX(time)) % 60 AS minutes
FROM game_results$;