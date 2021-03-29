create view totalpt AS
select * 
from Rawscores
where SSN = "0001";

create view weights AS
select * 
from Rawscores
where SSN = "0002";

#Question 1
delimiter $$
drop procedure if exists ShowRawScores $$
create procedure ShowRawScores(IN num VARCHAR(4))
begin 
IF (num in (select SSN from Rawscores WHERE SSN != "0001" AND SSN != "0002")) THEN
select * from Rawscores where SSN = num;
ELSE
select "Invalid SSN" AS RESULT;

END IF;
end $$

#Question 2
create view WtdPts AS
select W.HW1/T.HW1 as HW1, W.HW2a/T.HW2a as HW2a, W.HW2b/T.HW2b as HW2b,W.Midterm/T.Midterm as Midterm,
W.HW3/T.HW3 as HW3, W.FExam/T.FExam as FExam
from totalpt as T, weights as W;

delimiter $$
drop procedure if exists ShowPercentages $$
create procedure ShowPercentages(IN num VARCHAR(4))
begin 
IF (num in (select SSN from Rawscores WHERE SSN != "0001" AND SSN != "0002")) THEN
select R.SSN,R.Lname, R.Fname, R.Section,round((R.HW1*100/T.HW1),3) as HW1, round((R.HW2a*100/T.HW2a),3) as HW2a,round((R.HW2b*100/T.HW2b),3) as HW2b,
round((R.Midterm*100/T.Midterm),3) as Midterm, round((R.HW3*100/T.HW3),3) as HW3,round((R.FExam*100/T.FExam),3) as HW3
from Rawscores as R, WtdPts as W, totalpt as T
where R.SSN = num ;

select 
concat("The cumulative course average for ", R.FName," ",R.LName ," is ", (R.HW1*W.HW1+R.HW2a*W.HW2a+R.HW2b*W.HW2b+R.Midterm*W.Midterm+R.HW3*W.HW3+R.FExam*W.FExam)*100) as Result
from Rawscores as R, WtdPts as W
where R.SSN = num;

ELSE
select "N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A"  AS Result;
select "Invalid Person: SSN Not Found";

END IF;
end $$

#Question 3
delimiter $$
drop procedure if exists AllRawScores $$
create procedure AllRawScores(IN num VARCHAR(10))
begin 
IF (num in (select CurPasswords from Passwords)) THEN
select * from Rawscores 
where (SSN != "0001" AND SSN != "0002")
group by Rawscores.Section, Rawscores.Lname, Rawscores.FName;
ELSE
select "Password Invalid" AS RESULT;

END IF;
end $$


#Question 4
delimiter $$
drop procedure if exists AllPercentages $$
create procedure AllPercentages(IN num VARCHAR(10))
begin 
IF (num in (select CurPasswords from Passwords)) THEN
select R.SSN,R.LName, R.FName, R.Section, round((R.HW1*100/T.HW1),3) as HW1, round((R.HW2a*100/T.HW2a),3) as HW2a,round((R.HW2b*100/T.HW2b),3) as HW2b,
round((R.Midterm*100/T.Midterm),3) as Midterm, round((R.HW3*100/T.HW3),3) as HW3,round((R.FExam*100/T.FExam),3) as FExam, ((R.HW1*W.HW1+R.HW2a*W.HW2a+R.HW2b*W.HW2b+R.Midterm*W.Midterm+R.HW3*W.HW3+R.FExam*W.FExam)*100) as CumAvg
from Rawscores as R, WtdPts as W, totalpt as T
where R.SSN!="0001" AND R.SSN != "0002"
group by R.Section,CumAvg;

ELSE
select "Password Invalid";

END IF;
end $$

#Question 5
delimiter $$
drop procedure if exists Stats $$
create procedure Stats(IN num VARCHAR(10))
begin 
IF (num in (select CurPasswords from Passwords)) THEN


select "315" as Result;
select R.SSN,R.LName, R.FName, R.Section, round((R.HW1*100/T.HW1),3) as HW1, round((R.HW2a*100/T.HW2a),3) as HW2a,round((R.HW2b*100/T.HW2b),3) as HW2b,
round((R.Midterm*100/T.Midterm),3) as Midterm, round((R.HW3*100/T.HW3),3) as HW3,round((R.FExam*100/T.FExam),3) as FExam, ((R.HW1*W.HW1+R.HW2a*W.HW2a+R.HW2b*W.HW2b+R.Midterm*W.Midterm+R.HW3*W.HW3+R.FExam*W.FExam)*100) as CumAvg
from Rawscores as R, WtdPts as W, totalpt as T
where R.SSN!="0001" AND R.SSN != "0002" AND R.Section = "315"
group by R.Section,CumAvg ;


(select "Mean" as Statistic, round(avg(T1.HW1),3) as HW1, round(avg(T1.HW2a),3) as HW2a, round(avg(T1.HW2b),3) as HW2b, round(avg(T1.Midterm),3) as Midterm, round(avg(T1.HW3),3) as HW3, round(avg(T1.FExam)) as FExam,round(avg(T1.CumAvg)) as FExam
from 
(select R.SSN,R.LName, R.FName, R.Section, round((R.HW1*100/T.HW1),3) as HW1, round((R.HW2a*100/T.HW2a),3) as HW2a,round((R.HW2b*100/T.HW2b),3) as HW2b,
round((R.Midterm*100/T.Midterm),3) as Midterm, round((R.HW3*100/T.HW3),3) as HW3,round((R.FExam*100/T.FExam),3) as FExam, ((R.HW1*W.HW1+R.HW2a*W.HW2a+R.HW2b*W.HW2b+R.Midterm*W.Midterm+R.HW3*W.HW3+R.FExam*W.FExam)*100) as CumAvg
from Rawscores as R, WtdPts as W, totalpt as T
where R.SSN!="0001" AND R.SSN != "0002" AND R.Section = "315") as T1);


(select "Minimum" as Statistic, min(T1.HW1) as HW1, min(T1.HW2a) as HW2a, min(T1.HW2b) as HW2b, min(T1.Midterm) as Midterm, min(T1.HW3) as HW3, min(T1.FExam) as FExam,min(T1.CumAvg) as FExam
from 
(select R.SSN,R.LName, R.FName, R.Section, round((R.HW1*100/T.HW1),3) as HW1, round((R.HW2a*100/T.HW2a),3) as HW2a,round((R.HW2b*100/T.HW2b),3) as HW2b,
round((R.Midterm*100/T.Midterm),3) as Midterm, round((R.HW3*100/T.HW3),3) as HW3,round((R.FExam*100/T.FExam),3) as FExam, ((R.HW1*W.HW1+R.HW2a*W.HW2a+R.HW2b*W.HW2b+R.Midterm*W.Midterm+R.HW3*W.HW3+R.FExam*W.FExam)*100) as CumAvg
from Rawscores as R, WtdPts as W, totalpt as T
where R.SSN!="0001" AND R.SSN != "0002"AND R.Section = "315") as T1);


(select "Maximum" as Statistic, max(T1.HW1) as HW1, max(T1.HW2a) as HW2a, max(T1.HW2b) as HW2b, max(T1.Midterm) as Midterm, max(T1.HW3) as HW3, max(T1.FExam) as FExam,max(T1.CumAvg) as FExam
from 
(select R.SSN,R.LName, R.FName, R.Section, round((R.HW1*100/T.HW1),3) as HW1, round((R.HW2a*100/T.HW2a),3) as HW2a,round((R.HW2b*100/T.HW2b),3) as HW2b,
round((R.Midterm*100/T.Midterm),3) as Midterm, round((R.HW3*100/T.HW3),3) as HW3,round((R.FExam*100/T.FExam),3) as FExam, ((R.HW1*W.HW1+R.HW2a*W.HW2a+R.HW2b*W.HW2b+R.Midterm*W.Midterm+R.HW3*W.HW3+R.FExam*W.FExam)*100) as CumAvg
from Rawscores as R, WtdPts as W, totalpt as T
where R.SSN!="0001" AND R.SSN != "0002"AND R.Section = "315") as T1);


(select "Std. Dev." as Statistic, round(stddev(T1.HW1),3) as HW1, round(stddev(T1.HW2a),3) as HW2a, round(stddev(T1.HW2b),3) as HW2b, round(stddev(T1.Midterm),3) as Midterm, round(stddev(T1.HW3),3) as HW3, round(stddev(T1.FExam),3) as FExam,round(stddev(T1.CumAvg),3) as FExam
from 
(select R.SSN,R.LName, R.FName, R.Section, round((R.HW1*100/T.HW1),3) as HW1, round((R.HW2a*100/T.HW2a),3) as HW2a,round((R.HW2b*100/T.HW2b),3) as HW2b,
round((R.Midterm*100/T.Midterm),3) as Midterm, round((R.HW3*100/T.HW3),3) as HW3,round((R.FExam*100/T.FExam),3) as FExam, ((R.HW1*W.HW1+R.HW2a*W.HW2a+R.HW2b*W.HW2b+R.Midterm*W.Midterm+R.HW3*W.HW3+R.FExam*W.FExam)*100) as CumAvg
from Rawscores as R, WtdPts as W, totalpt as T
where R.SSN!="0001" AND R.SSN != "0002"AND R.Section = "315") as T1);

select R.SSN,R.LName, R.FName, R.Section, round((R.HW1*100/T.HW1),3) as HW1, round((R.HW2a*100/T.HW2a),3) as HW2a,round((R.HW2b*100/T.HW2b),3) as HW2b,
round((R.Midterm*100/T.Midterm),3) as Midterm, round((R.HW3*100/T.HW3),3) as HW3,round((R.FExam*100/T.FExam),3) as FExam, ((R.HW1*W.HW1+R.HW2a*W.HW2a+R.HW2b*W.HW2b+R.Midterm*W.Midterm+R.HW3*W.HW3+R.FExam*W.FExam)*100) as CumAvg
from Rawscores as R, WtdPts as W, totalpt as T
where R.SSN!="0001" AND R.SSN != "0002" AND R.Section = "415"
group by R.Section,CumAvg;

select "415" as Result;
(select "Mean" as Statistic, round(avg(T1.HW1),3) as HW1, round(avg(T1.HW2a),3) as HW2a, round(avg(T1.HW2b),3) as HW2b, round(avg(T1.Midterm),3) as Midterm, round(avg(T1.HW3),3) as HW3, round(avg(T1.FExam)) as FExam,round(avg(T1.CumAvg)) as CumAvg
from 
(select R.SSN,R.LName, R.FName, R.Section, round((R.HW1*100/T.HW1),3) as HW1, round((R.HW2a*100/T.HW2a),3) as HW2a,round((R.HW2b*100/T.HW2b),3) as HW2b,
round((R.Midterm*100/T.Midterm),3) as Midterm, round((R.HW3*100/T.HW3),3) as HW3,round((R.FExam*100/T.FExam),3) as FExam, ((R.HW1*W.HW1+R.HW2a*W.HW2a+R.HW2b*W.HW2b+R.Midterm*W.Midterm+R.HW3*W.HW3+R.FExam*W.FExam)*100) as CumAvg
from Rawscores as R, WtdPts as W, totalpt as T
where R.SSN!="0001" AND R.SSN != "0002" AND R.Section = "415") as T1);


(select "Minimum" as Statistic, min(T1.HW1) as HW1, min(T1.HW2a) as HW2a, min(T1.HW2b) as HW2b, min(T1.Midterm) as Midterm, min(T1.HW3) as HW3, min(T1.FExam) as FExam,min(T1.CumAvg) as CumAvg
from 
(select R.SSN,R.LName, R.FName, R.Section, round((R.HW1*100/T.HW1),3) as HW1, round((R.HW2a*100/T.HW2a),3) as HW2a,round((R.HW2b*100/T.HW2b),3) as HW2b,
round((R.Midterm*100/T.Midterm),3) as Midterm, round((R.HW3*100/T.HW3),3) as HW3,round((R.FExam*100/T.FExam),3) as FExam, ((R.HW1*W.HW1+R.HW2a*W.HW2a+R.HW2b*W.HW2b+R.Midterm*W.Midterm+R.HW3*W.HW3+R.FExam*W.FExam)*100) as CumAvg
from Rawscores as R, WtdPts as W, totalpt as T
where R.SSN!="0001" AND R.SSN != "0002"AND R.Section = "415") as T1);



(select "Maximum" as Statistic, max(T1.HW1) as HW1, max(T1.HW2a) as HW2a, max(T1.HW2b) as HW2b, max(T1.Midterm) as Midterm, max(T1.HW3) as HW3, max(T1.FExam) as FExam,max(T1.CumAvg) as CumAvg
from 
(select R.SSN,R.LName, R.FName, R.Section, round((R.HW1*100/T.HW1),3) as HW1, round((R.HW2a*100/T.HW2a),3) as HW2a,round((R.HW2b*100/T.HW2b),3) as HW2b,
round((R.Midterm*100/T.Midterm),3) as Midterm, round((R.HW3*100/T.HW3),3) as HW3,round((R.FExam*100/T.FExam),3) as FExam, ((R.HW1*W.HW1+R.HW2a*W.HW2a+R.HW2b*W.HW2b+R.Midterm*W.Midterm+R.HW3*W.HW3+R.FExam*W.FExam)*100) as CumAvg
from Rawscores as R, WtdPts as W, totalpt as T
where R.SSN!="0001" AND R.SSN != "0002"AND R.Section = "415") as T1);



(select "Std. Dev." as Statistic, round(stddev(T1.HW1),3) as HW1, round(stddev(T1.HW2a),3) as HW2a, round(stddev(T1.HW2b),3) as HW2b, round(stddev(T1.Midterm),3) as Midterm, round(stddev(T1.HW3),3) as HW3, round(stddev(T1.FExam),3) as FExam,round(stddev(T1.CumAvg),3) as CumAvg
from 
(select R.SSN,R.LName, R.FName, R.Section, round((R.HW1*100/T.HW1),3) as HW1, round((R.HW2a*100/T.HW2a),3) as HW2a,round((R.HW2b*100/T.HW2b),3) as HW2b,
round((R.Midterm*100/T.Midterm),3) as Midterm, round((R.HW3*100/T.HW3),3) as HW3,round((R.FExam*100/T.FExam),3) as FExam, ((R.HW1*W.HW1+R.HW2a*W.HW2a+R.HW2b*W.HW2b+R.Midterm*W.Midterm+R.HW3*W.HW3+R.FExam*W.FExam)*100) as CumAvg
from Rawscores as R, WtdPts as W, totalpt as T
where R.SSN!="0001" AND R.SSN != "0002"AND R.Section = "415") as T1);


ELSE
select "Password Invalid";

END IF;
end $$

#Question 6
delimiter $$
drop procedure if exists ChangeScores $$
create procedure ChangeScores(IN pwd VARCHAR(10),num VARCHAR(10), asgn VARCHAR(20), newscore VARCHAR(10) )
begin 
IF (pwd in (select CurPasswords from Passwords)) THEN
IF (num in (select SSN from Rawscores WHERE SSN != "0001" AND SSN != "0002")) THEN
IF (asgn = 'HW1' or asgn = 'HW2a' or asgn = 'HW2b' or asgn = 'Midterm' or asgn = 'HW3' or asgn = 'FExam' ) THEN

select * from Rawscores
where Rawscores.SSN = num;

IF asgn = 'HW1' THEN
UPDATE Rawscores
SET Rawscores.HW1 = newscore
WHERE Rawscores.SSN = num;

ELSEIF asgn = 'HW2a' THEN 
UPDATE Rawscores
SET Rawscores.HW2a = newscore
WHERE Rawscores.SSN = num;

ELSEIF asgn = 'HW2b' THEN 
UPDATE Rawscores
SET Rawscores.HW2b = newscore
WHERE Rawscores.SSN = num;

ELSEIF asgn = 'Midterm' THEN 
UPDATE Rawscores
SET Rawscores.Midterm = newscore
WHERE Rawscores.SSN = num;

ELSEIF asgn = 'HW3' THEN 
UPDATE Rawscores
SET Rawscores.HW3 = newscore
WHERE Rawscores.SSN = num;

ELSE
UPDATE Rawscores
SET Rawscores.FExam = newscore
WHERE Rawscores.SSN = num;

END IF; 

select * from Rawscores
where Rawscores.SSN = num;

ELSE
select "assignment name invalid. Input should be among HW1, HW2a, HW2b, Midterm, HW3, FExam" as Error;
END IF; 

ELSEIF CHAR_LENGTH(num) != 4 THEN
select "ssn should be four characters!" as Error;
ELSE
select "ssn invalid" as Error;
END IF;

ELSE
select "Password invalid" as Error;
END IF;
end $$






