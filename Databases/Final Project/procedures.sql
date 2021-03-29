#Question a
delimiter $$
drop procedure if exists Max_Case_State $$
create procedure Max_Case_State(IN month VARCHAR(10))
begin 
IF (month in (select Month from COVID_CASES )) THEN
SELECT C.State, C.Avg_Positive FROM COVID_CASES AS C
WHERE C.Month = month
ORDER BY C.Avg_Positive DESC
LIMIT 1; 
ELSE
select "Invalid Month" AS RESULT;

END IF;
end $$

#call Max_Case_State("June");

#Question b
delimiter $$
drop procedure if exists Percent_Vote_for $$
create procedure Percent_Vote_for(IN state VARCHAR(20))
begin 
IF (state in (select State from PRESIDENTIAL_ELECTION_BY_STATE)) THEN
SELECT P.State, P.Year, P.Dem_Votes/(P.Dem_Votes+P.Rep_Votes+P.Other_Votes) AS Dem_Percent, P.Rep_Votes/(P.Dem_Votes+P.Rep_Votes+P.Other_Votes) as Rep_Percent,
P.Other_Votes/(P.Dem_Votes+P.Rep_Votes+P.Other_Votes) AS Other_Percent
FROM PRESIDENTIAL_ELECTION_BY_STATE AS P
WHERE P.State = state;
ELSE
select "Invalid State" AS RESULT;

END IF;
end $$

#call Percent_Vote_for("Arizona");

#Question e
delimiter $$
drop procedure if exists COVID_CASES_DENSITY $$
create procedure COVID_CASES_DENSITY()
begin 
SELECT C.State, AVG(C.Avg_Positive), U.Population_Density
FROM COVID_CASES AS C, US_STATES AS U
WHERE U.State = C.State
GROUP BY C.State;
end $$

#call COVID_CASES_DENSITY;

#Question f
delimiter $$
drop procedure if exists COVID_CASES_UNEMPLOY_RATE $$
create procedure COVID_CASES_UNEMPLOY_RATE()
begin 
SELECT C.State, C.Avg_Positive, S.Rate
FROM COVID_CASES AS C, STATE_UNEMPLOYMENT_RATE AS S
WHERE S.State = C.State AND S.Month = C.Month;
end $$

call COVID_CASES_UNEMPLOY_RATE;

#Question g
delimiter $$
drop procedure if exists Vote_order_Unemploy $$
create procedure Vote_order_Unemploy()
begin 
SELECT * 
FROM 
(SELECT C.State, C.Year, C.Dem_Votes, C.Rep_Votes, Avg(S1.Rate) as UnEmploy_rate
FROM PRESIDENTIAL_ELECTION_BY_STATE AS C, STATE_UNEMPLOYMENT_RATE AS S1
WHERE C.State = S1.State AND C.Year = 2020 
GROUP BY S1.State
UNION
SELECT C.State, C.Year, C.Dem_Votes, C.Rep_Votes, Avg(S.Rate) as UnEmploy_rate
FROM PRESIDENTIAL_ELECTION_BY_STATE AS C, STATE_UNEMPLOYMENT_RATE AS S
WHERE C.State = S.State AND C.Year = 2016
GROUP BY S.State) as T
ORDER BY T.UnEmploy_rate DESC;
end $$

call Vote_order_Unemploy;

#Question h 
delimiter $$
drop procedure if exists Hospital_COVID_Death $$
create procedure Hospital_COVID_Death()
begin 
SELECT U.State, U.Total_Hospitals, AVG(C.Avg_Death) as avg_death  
FROM COVID_CASES AS C, US_STATES AS U
WHERE C.State = U.State
GROUP BY C.State
ORDER BY U.Total_Hospitals DESC;
end $$

