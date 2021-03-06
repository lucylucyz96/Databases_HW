/*Question 1*/
SELECT A.Fname, A.Lname, B.Fname, B.Lname 
FROM Student AS A, Student AS B 
WHERE (A.stuID IN (SELECT WhoIsLiked FROM Likes WHERE B.stuID = Likes.WhoLikes))
AND (B.stuID IN (SELECT WhoIsLiked FROM Likes WHERE A.stuID = Likes.WhoLikes))
AND ((B.stuID not IN (SELECT WhoIsLoved FROM Loves WHERE A.stuID = Loves.WhoLoves))
OR (A.stuID not IN (SELECT WhoIsLoved FROM Loves WHERE B.stuID = Loves.WhoLoves)))
AND A.City_Code = B.City_Code
AND A.stuID<B.stuID;

/*Question 2*/
SELECT Student.Fname, Student.Lname, Car.CarManufacturer, Car.CarModel, Car.miles_per_gallon
FROM Student, Car, Car_Ownership, 
(SELECT MIN(Car.miles_per_gallon) AS miles_per_gallon 
FROM Car) as MIN
WHERE Student.StuID = Car_Ownership.StuID 
AND Car.CarID = Car_Ownership.CarID
AND Car.miles_per_gallon = MIN.miles_per_gallon;

/*Question 3*/
SELECT DISTINCT S.Fname, S.Lname, S.Age, D.DName 
FROM Student AS S, Department AS D, Car_Ownership as C
WHERE S.Stuid = C.Stuid and  not exists(
(SELECT CarModel
 FROM Car
 WHERE CarManufacturer = "Nissan")
 EXCEPT
 (SELECT R.CarModel
 	FROM  Car AS R, Car_Ownership AS C
 	WHERE S.StuID = C.StuID 
 	AND R.CarID = C.CarID))
AND S.Major = D.DNO;

/*Question 4*/
SELECT Student.Fname, Student.Lname
FROM Student, Car_Ownership
WHERE Student.StuID = Car_Ownership.StuID 
GROUP BY Car_Ownership.StuID
HAVING COUNT(Car_Ownership.CarID) >1;


/*Question 5*/
SELECT DISTINCT Student.Fname, Student.Lname
FROM Student,Lives_in, Has_Pet, Car_Ownership
WHERE Student.StuID IN (SELECT StuID FROM  Lives_in)
AND Student.StuID  IN (SELECT StuID FROM Has_Pet) 
AND Student.StuID NOT IN (SELECT StuID FROM Car_Ownership);

/*Question 7*/
SELECT MIN(Car.miles_per_gallon) AS min_MPG,MAX(Car.miles_per_gallon) AS max_MPG,AVG(Car.miles_per_gallon)AS avg_MPG
FROM Car
WHERE CarManufacturer = "Porsche";

/*Question 8*/ 
SELECT MIN(Student.Age), MAX(Student.Age), AVG(Student.Age)
FROM Student, Lives_in, Car_Ownership 
WHERE Student.stuID IN(SELECT StuID FROM Lives_in)
AND Student.stuID not IN (SELECT StuID FROM Car_Ownership);

/*Question 10*/ 
SELECT AVG(T.Age)
FROM
(SELECT Student.Age
FROM Student, Participates_in
WHERE Student.StuID = Participates_in.StuID
GROUP BY Student.StuID 
HAVING COUNT(DISTINCT Participates_in.ActID)>2) as T;

/*Question 11*/
SELECT T2.Act_name, T2.act_cnt
FROM 
(SELECT MAX(T.act_cnt) AS max_cnt
FROM (
SELECT Activity.activity_name AS Act_name, COUNT(Participates_in.stuid) AS act_cnt
FROM Activity, Participates_in
WHERE Activity.actid = Participates_in.actid
GROUP BY Participates_in.actid) AS T) AS T1,

(SELECT Activity.activity_name AS Act_name, COUNT(Participates_in.stuid) AS act_cnt
FROM Activity, Participates_in
WHERE Activity.actid = Participates_in.actid
GROUP BY Participates_in.actid) AS T2
WHERE T2.act_cnt = T1.max_cnt;


/*Question 12*/
SELECT DISTINCT Activity.activity_name 
FROM Activity, Participates_in, Faculty_Participates_in
WHERE Activity.actid not IN (SELECT actid FROM Participates_in)
AND Activity.actid IN (SELECT actid FROM Faculty_Participates_in);

/*Question 13*/
SELECT DISTINCT A.Fname, A.Lname
FROM Student AS A, Student AS B, Student AS C,Student AS D, Enrolled_in AS EIA, Enrolled_in AS EIB, Enrolled_in AS EIC,Lives_in AS LIC, Lives_in AS LID, City, VotedForElectioninUS,USCandidate
WHERE A.StuID = EIA.StuID AND A.StuID != B.StuID AND B.StuID = EIB.StuID AND C.StuID = EIC.StuID AND EIA.CID = EIB.CID AND EIA.StuID != EIB.StuID AND EIB.CID = EIC.CID AND EIB.Stuid != EIC.Stuid 
AND C.StuID = LIC.stuid AND D.StuID = LID.stuid AND LIC.dormid = LID.dormid AND LIC.room_number=LID.room_number
AND D.city_code = City.city_code AND City.state = "PA"
AND D.StuID = VotedForElectioninUS.StuID AND VotedForElectioninUS.Year = "2020" AND VotedForElectioninUS.CandidateID = USCandidate.CandidateId AND USCandidate.CandidateName = "Donald Trump" ;

/*Question 14*/
SELECT DISTINCT Student.Fname, Student.Lname, Faculty.Fname, Faculty.Lname
FROM Student, Faculty, Participates_in, Faculty_Participates_in, Course
WHERE Student.Advisor = Faculty.FacID
AND Student.StuID = Participates_in.StuID AND Participates_in.ActID = Faculty_Participates_in.ActID AND Faculty.FacID = Faculty_Participates_in.FacID
AND Faculty.FacID IN (SELECT Instructor FROM Course);

/*Question 15*/
SELECT DISTINCT A.Fname, A.Lname, B.Fname, B.Lname 
FROM Student AS A, Student AS B, Lives_in AS LIA, Lives_in AS LIB, City AS CityA, City AS CityB 
WHERE A.StuID = LIA.StuID AND B.StuID = LIB.StuID AND LIA.DormID = LIB.DormID AND LIA.Room_number = LIB.Room_number 
AND A.City_Code = CityA.City_code AND B.City_Code = CityB.City_code 
AND CityA.Country != CityB.Country
AND A.StuID < B.StuID;

/*Question 16*/
SELECT TT.avg_GPA, TT.DormID,TT.dorm_name
FROM
(SELECT AVG(T.GPA) AS avg_GPA, T.DormID, Dorm.dorm_name
FROM Dorm,
(SELECT S.StuID, (totals / totalcredits) AS GPA, Lives_in.DormID
FROM Student AS S,
(
SELECT t.StuID, SUM(t.credits) AS totalcredits, SUM(t.credits * t.gradepoINt) AS totals
FROM ( SELECT S.StuID, C.credits, G.gradepoint
FROM Student AS S, Enrolled_in AS E, Course AS C, Gradeconversion AS G
WHERE S.StuID = E.stuid AND E.cid = C.cid AND E.grade = G.lettergrade) AS t
GROUP BY t.StuID) AS tt
,Lives_in
WHERE S.StuID = tt.StuID AND S.StuID = Lives_in.StuID
)AS T
WHERE Dorm.dormid = T.DormID
GROUP BY T.DormID)AS TT
,

(SELECT MAX(TT.avg_GPA) AS max_GPA
FROM 
(SELECT AVG(T.GPA) AS avg_GPA, T.DormID
FROM 
(SELECT S.StuID, (totals / totalcredits) AS GPA, Lives_in.DormID
FROM Student AS S,
(
SELECT t.StuID, SUM(t.credits) AS totalcredits, SUM(t.credits * t.gradepoint) AS totals
FROM ( SELECT S.StuID, C.credits, G.gradepoint
FROM Student AS S, Enrolled_in AS E, Course AS C, Gradeconversion AS G
WHERE S.StuID = E.stuid AND E.cid = C.cid AND E.grade = G.lettergrade) AS t
GROUP BY t.StuID) AS tt
,Lives_in
WHERE S.StuID = tt.StuID AND S.StuID = Lives_in.StuID
)AS T
GROUP BY T.DormID) AS TT) AS MAX
WHERE TT.avg_GPA = MAX.max_GPA 
;


/*Question 17*/
DROP TABLE if exists BALTIMORE_DISTANCE;
CREATE TABLE BALTIMORE_DISTANCE(
  city1_code varchar(3) ,
  city2_code varchar(3) ,
  distance INTEGER
) ;


INSERT INTO BALTIMORE_DISTANCE(city1_code,city2_code,distance)
SELECT T.city1_code, T.city2_code,t3.distance+t4.distance AS distance
FROM Direct_distance AS t3, Direct_distance AS t4, 
(SELECT DISTINCT t1.city2_code AS city1_code, t2.city2_code 
FROM Direct_distance AS t1, Direct_distance AS t2
WHERE t1.city2_code != t2.city2_code
) AS T
WHERE t3.city1_code = T.city1_code AND t3.city2_code = "BAL"
AND t4.city1_code = T.city2_code AND t4.city2_code = "BAL"
UNION  
SELECT DISTINCT t1.city2_code AS city1_code, t2.city2_code, 0 as distance 
FROM Direct_distance AS t1, Direct_distance AS t2
WHERE t1.city2_code = t2.city2_code;


/*Question 17*/
DROP TABLE if exists RECTANGULAR_DISTANCE;
CREATE TABLE RECTANGULAR_DISTANCE(
  city1_code varchar(3) ,
  city2_code varchar(3) ,
  distance INTEGER
) ;


INSERT INTO RECTANGULAR_DISTANCE(city1_code,city2_code,distance)
SELECT DISTINCT BALTIMORE_DISTANCE.city1_code, BALTIMORE_DISTANCE.city2_code, sqrt(power((70 * CityA.latitude - 70 * CityB.latitude),2)+power((70 * CityA.longitude - 70 * CityB.longitude),2)) AS distance
FROM BALTIMORE_DISTANCE, City AS CityA, City AS CityB
WHERE BALTIMORE_DISTANCE.city1_code = CityA.city_code AND BALTIMORE_DISTANCE.city2_code = CityB.city_code;
/*Question 17*/
DROP TABLE if exists ALL_DISTANCES;
CREATE TABLE ALL_DISTANCES (
  city1_code varchar(3) ,
  city2_code varchar(3) ,
  direct_distance INTEGER,
  baltimore_distance INTEGER,
  rectangular_distance INTEGER
) ;


INSERT INTO ALL_DISTANCES(city1_code,city2_code,direct_distance,baltimore_distance,rectangular_distance)
SELECT DISTINCT temp.city1_code, temp.city2_code,  MAX(Direct_distance) as direct_distance, MAX(Bal_distance) as baltimore_distance,MAX(Rec_distance) as rectangular_distance
FROM (
SELECT Rec.city1_code, Rec.city2_code, Rec.distance AS Rec_distance, NULL AS Direct_distance, NULL AS Bal_distance
FROM RECTANGULAR_DISTANCE AS Rec
UNION
SELECT DirectD.city1_code, DirectD.city2_code, NULL AS Rec_distance, DirectD.distance AS Direct_distance, NULL AS Bal_distance
FROM Direct_distance AS DirectD
WHERE DirectD.city1_code != DirectD.city2_code
UNION
SELECT Bal_dis.city1_code, Bal_dis.city2_code, NULL AS Rec_distance, NULL AS Direct_distance, Bal_dis.distance AS Bal_distance
FROM BALTIMORE_DISTANCE AS Bal_dis
) AS temp
GROUP BY temp.city1_code, temp.city2_code;


/*Question 17*/
DROP TABLE if exists BEST_DISTANCE;
CREATE TABLE BEST_DISTANCE (
  city1_code varchar(3) ,
  city2_code varchar(3) ,
  distance INTEGER
) ;

INSERT INTO BEST_DISTANCE(city1_code,city2_code,distance)
SELECT DISTINCT T.city1_code,T.city2_code,T.distance
FROM
(SELECT DISTINCT B.city1_code, B.city2_code, D.distance
FROM ALL_DISTANCES AS B,Direct_distance AS D
WHERE B.city1_code = D.city1_code AND B.city2_code = D.city2_code
Union ALL
SELECT DISTINCT A.city1_code, A.city2_code, least(A.baltimore_distance,A.rectangular_distance)
FROM ALL_DISTANCES AS A
WHERE NOT EXISTS (
    SELECT D.city1_code, D.city2_code FROM Direct_distance AS D
    WHERE A.city1_code= D.city1_code AND A.city2_code = D.city2_code)) AS T;

/*Question 18*/
SELECT DISTINCT City.city_name, T.cnt 
FROM City,
(SELECT Student.city_code, COUNT(Student.StuID) AS cnt
FROM Student
GROUP BY Student.city_code
HAVING COUNT(Student.StuID)>=2) AS T
WHERE City.city_code = T.city_code;

/*Question 19*/
SELECT DISTINCT A.Fname, A.Lname, D.city_name, D.state, D.country
FROM Student AS A, Student AS B, BEST_DISTANCE AS C, City AS D, City as E,
(SELECT LA.stuid AS stuid1, LB.stuid  AS stuid2
FROM Lives_in AS LA, Lives_in AS LB,
(SELECT Lives_in.DormID
FROM Lives_in
GROUP BY Lives_in.DormID
HAVING count(DISTINCT Lives_in.StuID)<300
) AS T
WHERE LA.dormid = LB.dormid
AND LA.dormid IN (T.DormID) AND LA.stuid != LB.stuid) AS TT
WHERE A.StuID = TT.stuid1 AND B.StuID = TT.stuid2
AND A.city_code = C.city1_code AND B.city_code = C.city2_code
AND C.distance <= 100
AND A.city_code = D.city_code
AND B.city_code = E.city_code
AND A.StuID != B.stuID;

/*Question 20*/
SELECT DISTINCT Student.Fname, Student.Lname, City.Country
FROM  Student,City,
(SELECT DISTINCT City.city_name, City.City_Code
FROM City, BEST_DISTANCE,
(SELECT MAX(T.distance) AS max_dis, T.country
FROM 
(SELECT DISTINCT Student.city_code, City.country, City.city_name, BEST_DISTANCE.distance
FROM City, BEST_DISTANCE, Student
WHERE Student.city_code = City.city_code and City.city_code = BEST_DISTANCE.city1_code AND BEST_DISTANCE.city2_code = "BAL") AS T
GROUP BY T.country) AS TT
WHERE City.country = TT.country AND BEST_DISTANCE.distance = TT.max_dis
AND BEST_DISTANCE.city1_code = City.city_code AND BEST_DISTANCE.city2_code = "BAL") AS TTT
WHERE Student.City_Code = TTT.City_Code
AND City.City_Code = Student.City_Code;

/*Question 21*/
SELECT Activity.Activity_name
FROM Activity,
(SELECT AVG(T1.distance) AS avg_dist, T1.ActID
FROM (
SELECT DISTINCT Participates_in.ActID, Participates_in.StuID, BEST_DISTANCE.distance
FROM Student AS A, Participates_in, BEST_DISTANCE 
WHERE Participates_in.StuID = A.StuID AND A.City_Code = BEST_DISTANCE.city1_code
AND BEST_DISTANCE.city2_code = "BAL") AS T1
GROUP BY T1.ActID) AS T2,
(SELECT MAX(TT.avg_dist) AS max_dist
FROM
(SELECT AVG(T.distance) AS avg_dist, T.ActID
FROM (
SELECT DISTINCT Participates_in.ActID, Participates_in.StuID, BEST_DISTANCE.distance
FROM Student AS A, Participates_in, BEST_DISTANCE 
WHERE Participates_in.StuID = A.StuID AND A.City_Code = BEST_DISTANCE.city1_code
AND BEST_DISTANCE.city2_code = "BAL") AS T
GROUP BY T.ActID) AS TT) AS MAX
WHERE T2.avg_dist = MAX.max_dist AND Activity.actid = T2.ActID;


/*Question 22*/
SELECT DISTINCT Student.Fname, Student.Lname, Student.Age, Student.StuID
FROM Student, Minor_in, Department,
(SELECT Student.Stuid  
FROM Enrolled_in, Course, Student,
(SELECT DISTINCT Member_of.FacID
FROM Member_of, Department, Faculty
WHERE Member_of.DNO= Department.DNO AND Department.Division = "EN" AND Member_of.Appt_Type = "Primary"
AND Faculty.Sex = "F" AND Faculty.FacID = Member_of.FacID AND Faculty.rank = "Professor") as T
WHERE Student.Stuid = Enrolled_in.Stuid and Enrolled_in.CID = Course.CID and Course.Instructor = T.FacID) as T1
WHERE Student.StuID = T1.StuID
AND Student.StuID = Minor_in.Stuid 
AND Minor_in.DNO = Department.DNO
AND Department.Division = "EN"
AND Student.Sex = "F";

/*Question 23*/
SELECT DISTINCT S.Fname, S.Lname, S.StuID 
FROM Student AS S
WHERE not exists(
(SELECT C.CID
 FROM Course AS C, Faculty AS F
 WHERE C.INstructor = F.FacID 
 AND F.Fname = "Paul"
 AND F.Lname = "Smolensky")
except
(
SELECT E.CID
FROM Enrolled_in AS E, Course AS CC, Faculty as FF
WHERE E.stuid = S.Stuid AND E.CID = CC.CID AND CC.Instructor = FF.FacID AND FF.Lname = "Smolensky" AND FF.Fname = "Paul"));

/*Question 24*/

SELECT DISTINCT A.StuID, A.Fname, A.Lname 
FROM Student AS A, Student as B, Student as C, Enrolled_in as AE, Enrolled_in as BE, Enrolled_in as CE,Enrolled_in as CE1,
City as BC, City as CC,VotedForElectioninUS as CV2020, VotedForElectioninUS as BV2020,  USCandidateFor as CAN2020B,
USCandidateFor as CAN2020C,
VotedForElectioninUS as CV2016, VotedForElectioninUS as BV2016,  USCandidateFor as CAN2016B, USCandidateFor as CAN2016C
WHERE A.Stuid = AE.Stuid AND B.Stuid = BE.Stuid AND C.Stuid = CE.Stuid AND B.Fname = "Linda" AND B.Lname = "Smith"
AND AE.CID = CE.CID  AND C.Stuid = CE1.StuID AND BE.CID = CE1.CID
AND B.city_code = BC.city_code AND C.city_code = CC.city_code AND BC.state = CC.state 
AND CV2020.stuid = C.stuid AND BV2020.stuid = B.stuid AND CV2020.Year = "2020" AND BV2020.Year = "2020"  AND CV2020.CandidateID = BV2020.CandidateID AND CV2020.CandidateID = CAN2020C.CandidateID AND CAN2020C.Office = "President"
AND BV2020.CandidateID = CAN2020B.CandidateID AND CAN2020B.Office = "President"
AND CV2016.stuid = C.stuid AND BV2016.stuid = B.stuid AND BV2016.Year = "2016" AND BV2020.Year = "2016" AND CV2016.CandidateID = BV2016.CandidateID AND CV2016.CandidateID = CAN2016C.CandidateID AND CAN2016C.Office = "President"
AND BV2016.CandidateID = CAN2016B.CandidateID AND CAN2016B.Office = "President"
AND A.StuID != B.Stuid; 


/*Question 25*/
SELECT DISTINCT Course.CName
FROM Student AS A, Student AS B, Member_of_club, Has_Allergy, Enrolled_in, Course
WHERE A.StuID not IN (SELECT StuID FROM Member_of_club)
AND A.StuID not IN (SELECT StuID FROM Has_Allergy)
AND B.StuID IN (SELECT StuID FROM Has_Allergy)
AND B.StuID IN(SELECT StuID FROM Member_of_club)
AND B.StuID IN(SELECT WhoIsLiked FROM Likes WHERE A.StuID = Likes.WhoLikes)
AND A.StuID = Enrolled_in.StuID
AND Course.CID = Enrolled_in.CID;

/*Question 26*/
SELECT S.Fname, S.Lname, D.dorm_name, COUNT(*) 
FROM ConductViolation AS C, Student AS S, Dorm AS D, Lives_in AS L   
WHERE S.StuID = C.StuID AND D.dormid = L.Dormid AND L.Stuid = S.Stuid 
GROUP BY C.StuID;

/*Question 27*/
SELECT SS.Fname, SS.Lname, Dorm.dorm_name ,MAX(T.cnt_violation) AS num_violations
FROM Student AS SS,Dorm, Lives_in,
(SELECT S.Fname, S.Lname,S.StuID, C.DormID, COUNT(*) AS cnt_violation
FROM ConductViolation AS C, Student AS S    
WHERE S.StuID = C.StuID 
GROUP BY C.StuID) AS T
WHERE SS.StuID = T.StuID AND SS.StuID = Lives_in.StuID AND Dorm.dormid = Lives_in.DormID
GROUP BY T.StuID;

/*Question 29*/
SELECT T.CName, T.Dname
FROM 
(SELECT COUNT(*) AS cnt, E.CID, Course.CName, Department.Dname 
FROM Student AS S, Enrolled_in AS E, ConductViolation AS C, Course, Department
WHERE S.StuID = E.StuId AND S.Stuid = C.Stuid AND Course.CID = E.CID AND Course.DNO = Department.DNO
GROUP BY E.CID) AS T,
(SELECT MAX(cnt) AS max_cnt
FROM 
(SELECT COUNT(*) AS cnt, E.CID, Course.CName, Department.Dname 
FROM Student AS S, Enrolled_in AS E, ConductViolation AS C, Course, Department
WHERE S.StuID = E.StuId AND S.Stuid = C.Stuid AND Course.CID = E.CID AND Course.DNO = Department.DNO
GROUP BY E.CID) AS T) AS MAX
WHERE T.cnt = MAX.max_cnt;

/*Question 30*/
SELECT Activity.Activity_name 
FROM Activity, 
(SELECT ConductViolation.StuID,ConductViolation.Dormid, ConductViolation.Reason, ConductViolation.Date,
Participates_in.ActID
FROM ConductViolation
INNER JOIN Participates_in ON ConductViolation.StuID = Participates_in.StuID
GROUP BY ActID
HAVING COUNT(*)>3) AS T
WHERE T.ActID = Activity.ActID;

/*Question 31*/
SELECT S1.Fname, S1.Lname, S2.Fname, S2.Lname, U1.CandidateName,U2.CandidateName
FROM Lives_in AS L1, Lives_in AS L2,VotedForElectioninUS AS V1, VotedForElectioninUS AS V2,
Student AS S1, Student AS S2, USCandidate AS U1, USCandidate AS U2, USCandidateFor as F1, USCandidateFor as F2
WHERE L1.stuid = V1.stuid AND L2.stuid = V2.stuid AND L1.dormid = L2.dormid AND V1.Year = 2020 AND V2.Year = 2020 
AND V1.CandidateID != V2.CandidateID AND L1.stuid < L2.stuid AND L1.room_number = L2.room_number 
AND S1.StuID = L1.stuid AND S2.StuID = L2.stuid 
AND V1.CandidateID = U1.CandidateId AND V2.CandidateID = U2.CandidateId
AND U1.CandidateID = F1.CandidateId AND F1.Year = 2020 AND F1.Office = "President"
AND U2.CandidateID = F2.CandidateID AND F2.Year = 2020 AND F2.Office = "President";

/*Question 32*/
SELECT TTT.dorm_name, TTT.cnt
FROM (
SELECT Dorm.dorm_name,COUNT(TT.stuid) AS cnt
FROM Dorm,
(SELECT DISTINCT T.stuid, T.dormid
FROM
(SELECT Lives_in.stuid, Lives_in.dormid, VotedForElectioninUS.CandidateID, VotedForElectioninUS.Year
FROM Lives_in 
INNER JOIN VotedForElectioninUS ON Lives_in.Stuid = VotedForElectioninUS.stuid) AS T, USCandidate, USCandidateFor
WHERE T.CandidateID = USCandidate.CandidateId AND USCandidate.CandidateName = "Donald Trump" AND USCandidateFor.CandidateID = USCandidate.CandidateID AND USCandidateFor.Office = "President"
AND T.Year = "2020") AS TT
WHERE Dorm.dormid = TT.DormID
GROUP BY Dorm.dorm_name) AS TTT,

(SELECT MAX(TTT.cnt) AS max_cnt
FROM
(
SELECT Dorm.dorm_name,COUNT(TT.stuid) AS cnt
FROM Dorm,
(SELECT DISTINCT T.stuid, T.dormid
FROM
(SELECT Lives_in.stuid, Lives_in.dormid, VotedForElectioninUS.CandidateID, VotedForElectioninUS.Year
FROM Lives_in 
INNER JOIN VotedForElectioninUS ON Lives_in.Stuid = VotedForElectioninUS.stuid) AS T, USCandidate, USCandidateFor
WHERE T.CandidateID = USCandidate.CandidateId AND USCandidate.CandidateName = "Donald Trump"AND USCandidateFor.CandidateID = USCandidate.CandidateID AND USCandidateFor.Office = "President"
AND T.Year = "2020") AS TT
WHERE Dorm.dormid = TT.DormID
GROUP BY Dorm.dorm_name) AS TTT) AS MAX
WHERE TTT.cnt = MAX.max_cnt
;

/*Question 33*/
SELECT T6.dorm_name,T6.cnt_vote, T6.cnt_stu, T6.percentage_vote
FROM 
(SELECT MAX(T6.percentage_vote) AS max_percent
FROM
(SELECT TTT.dorm_name,TTT.cnt_vote,TTTTT.cnt_stu, ROUND(TTT.cnt_vote/TTTTT.cnt_stu,2) AS percentage_vote
FROM
(SELECT Dorm.dorm_name,COUNT(TT.stuid) AS cnt_vote
FROM Dorm,
(SELECT DISTINCT T.stuid, T.dormid
FROM
(SELECT Lives_in.stuid, Lives_in.dormid, VotedForElectioninUS.CandidateID, VotedForElectioninUS.Year
FROM Lives_in
INNER joIN VotedForElectioninUS ON Lives_in.Stuid = VotedForElectioninUS.stuid
WHERE VotedForElectioninUS.Year = "2020") AS T, USCandidate,USCandidateFor
WHERE T.CandidateID = USCandidate.CandidateId AND USCandidate.CandidateName = "Donald Trump" AND 
USCandidateFor.CandidateID = USCandidate.CandidateID AND USCandidateFor.Office = "President"
AND USCandidateFor.Year = "2020") AS TT
WHERE Dorm.dormid = TT.DormID
GROUP BY Dorm.dorm_name) AS TTT

INNER JOIN

(SELECT TTTT.dorm_name, COUNT(TTTT.stuid) AS cnt_stu
FROM (
SELECT Dorm.dorm_name, Lives_in.stuid
FROM Dorm, Lives_in
WHERE Dorm.dormid = Lives_in.dormid ) AS TTTT
GROUP BY TTTT.dorm_name) AS TTTTT
ON TTT.dorm_name = TTTTT.dorm_name) AS T6) AS MAX,

(SELECT TTT.dorm_name,TTT.cnt_vote,TTTTT.cnt_stu, TTT.cnt_vote/TTTTT.cnt_stu AS percentage_vote
FROM
(SELECT Dorm.dorm_name,COUNT(TT.stuid) AS cnt_vote
FROM Dorm,
(SELECT DISTINCT T.stuid, T.dormid
FROM
(SELECT Lives_in.stuid, Lives_in.dormid, VotedForElectioninUS.CandidateID, VotedForElectioninUS.Year
FROM Lives_in
INNER JOIN VotedForElectioninUS on Lives_in.Stuid = VotedForElectioninUS.stuid
WHERE VotedForElectioninUS.Year = "2020") AS T, USCandidate,USCandidateFor
WHERE T.CandidateID = USCandidate.CandidateId AND USCandidate.CandidateName = "Donald Trump"
AND USCandidateFor.CandidateID = USCandidate.CandidateID AND USCandidateFor.Office = "President"
AND USCandidateFor.Year = "2020") AS TT
WHERE Dorm.dormid = TT.DormID
GROUP BY Dorm.dorm_name) AS TTT
INNER JOIN
(SELECT TTTT.dorm_name, COUNT(TTTT.stuid) AS cnt_stu
FROM (
SELECT Dorm.dorm_name, Lives_in.stuid
FROM Dorm, Lives_in
WHERE Dorm.dormid = Lives_in.dormid ) AS TTTT
GROUP BY TTTT.dorm_name) AS TTTTT
ON TTT.dorm_name = TTTTT.dorm_name) AS T6
WHERE ROUND(T6.percentage_vote,2) = MAX.max_percent;

/*Question 34*/
SELECT S1.Fname, S1.Lname, S1.Age, C1.CandidateName, C1.Party, V1.Year AS Year1, C2.CandidateName, C2.Party,
V2.Year AS Year2 
FROM VotedForElectioninUS AS V1, VotedForElectioninUS AS V2,
Student AS S1, USCandidate AS C1, USCandidate AS C2,USCandidateFor as U1, USCandidateFor as U2
WHERE V1.Stuid = V2.Stuid AND V1.Year = 2016 AND V2.Year = 2020
AND V1.CandidateID != V2.CandidateID
AND S1.Stuid = V1.Stuid AND C1.CandidateID = V1.CandidateId
AND C2.CandidateId = V2.CandidateId
AND C1.CandidateId = U1.CandidateId AND U1.Year = 2016 AND U1.Office = "President"
AND C2.CandidateID = U2.CandidateID AND U2.Year =2020 AND U2.Office = "President"; 

/*Question 35*/
SELECT DISTINCT S.Fname, S.Lname, C.State
FROM VotedForElectioninUS AS V1, VotedForElectioninUS AS V2, USCandidate AS C1,
USCandidate AS C2, Student AS S, City AS C, USCandidateFor as U1, USCandidateFor as U2
WHERE V1.Stuid = V2.Stuid AND V1.Year != V2.Year AND 
V1.CandidateId = C1.CandidateId AND V2.CandidateId = C2.CandidateId 
AND U1.CandidateID = C1.CandidateID AND U1.Year = V1.Year AND U1.Office = "President"
AND U2.CandidateID = C2.CandidateID AND U2.Year = V2.Year AND U2.Office = "President"
AND C1.Party != C2.Party
AND S.Stuid = V1.Stuid AND S.City_Code = C.city_code;

/*Question 36*/
SELECT DISTINCT Student.Fname, Student.Lname FROM Worked_at, Studied_Abroad, Student 
WHERE Position LIKE '%intern%' AND (Worked_at.Start_Date < Studied_Abroad.End_Date
OR Worked_at.End_Date > Studied_Abroad.Start_Date) AND Worked_at.StuID = Studied_Abroad.StuID
AND Student.Stuid = Worked_at.Stuid;

/*Question 37*/
SELECT S.Fname, S.Lname 
FROM Student AS S,
(SELECT W1.Stuid
FROM Worked_at AS W1, Worked_at AS W2
WHERE W1.Position LIKE '%intern%' AND W2.Position LIKE '%intern%'
AND W1.Stuid = W2.Stuid 
AND (W1.Start_Date <=W2.End_Date OR W1.End_Date>=W2.Start_Date)
AND (W1.Company != W2.Company OR W1.Position != W2.Position)) AS T
WHERE S.Stuid = T.Stuid 
GROUP BY T.Stuid 
HAVING COUNT(T.Stuid) >=2; 

/*Question 40*/
SELECT W.Company, W.Start_Date, W.End_Date, S.Fname, S.Lname,
DATEDIFF( W.End_Date,W.Start_Date)+1 AS duration 
FROM Worked_at AS W, Student AS S
WHERE W.Position like '%intern%'
AND S.Stuid = W.Stuid;

/*Question 41*/
SELECT T1.Fname, T1.Lname, T1.total_duration, T1.Company
FROM 
(SELECT max(T1.total_duration) as max_duration
FROM 
(SELECT T.Company, T.Start_Date, T.End_Date, T.Fname, T.Lname, SUM(duration) as total_duration
FROM
(SELECT DISTINCT W.Company, W.Start_Date, W.End_Date, S.Fname, S.Lname,S.Stuid, 
DATEDIFF( W.End_Date,W.Start_Date)+1 AS duration 
FROM Worked_at AS W, Student AS S
WHERE W.Position like '%intern%'
AND S.Stuid = W.Stuid
) AS T
GROUP BY T.stuid, T.Company) as T1) AS MAX
,

(SELECT T.Company, T.Start_Date, T.End_Date, T.Fname, T.Lname, SUM(duration) as total_duration
FROM
(SELECT DISTINCT W.Company, W.Start_Date, W.End_Date, S.Fname, S.Lname,S.Stuid, 
DATEDIFF( W.End_Date,W.Start_Date)+1 AS duration 
FROM Worked_at AS W, Student AS S
WHERE W.Position like '%intern%'
AND S.Stuid = W.Stuid
) AS T
GROUP BY T.stuid, T.Company) as T1
WHERE T1.total_duration = MAX.max_duration;

/*Question 42*/
SELECT DISTINCT S.Fname, S.Lname, D.dorm_name 
FROM Lives_in AS L1, Lives_in AS L2, Has_Pet AS H2, Pet AS P2, Has_Allergy AS A1,
Student AS S, Dorm AS D 
WHERE L2.Dormid = L1.Dormid AND H2.StuId = L2.Stuid AND H2.Petid = P2.Petid AND  
P2.PetType = A1.Allergy AND L1.Stuid = A1.Stuid AND S.Stuid = L1.Stuid AND 
D.Dormid = L1.Dormid;

/*Question 43*/
SELECT DISTINCT S2.Fname, S2.Lname,S1.Fname, S1.Lname, P3.petname 
FROM Student AS S1, Student AS S2, Student AS S3,
Lives_in AS L1, Lives_in AS L3, Has_Pet AS H3, Pet AS P3, Loves
WHERE L1.Dormid = L3.Dormid AND L1.Room_number = L3.Room_number
AND S1.stuid = L1.stuid AND S3.stuid = L3.stuid 
AND S3.stuid = H3.stuid AND H3.Petid = P3.petid 
AND P3.Petname = S2.Fname AND 
S2.Stuid IN (SELECT WhoIsLoved FROM Loves WHERE S1.stuID = Loves.WhoLoves ) AND 
S1.Stuid IN (SELECT WhoIsLoved FROM Loves WHERE S2.stuID = Loves.WhoLoves ); 

/*Question 44*/
SELECT S.Fname, S.Lname, S.Age, T.PetName, T.PetAge
FROM Has_Pet AS H,Student AS S,
(SELECT MAX(P.Petage) AS max_age
FROM Pet AS P 
WHERE P.PetType = "Dog") AS MAX,
(SELECT *
FROM Pet AS P 
WHERE P.PetType = "Dog") AS T
WHERE T.PetAge = MAX.max_age
AND T.Petid = H.Petid 
AND S.Stuid = H.Stuid;

/*Question 45*/
SELECT DISTINCT S1.Fname, S1.Lname,D1.dorm_name, L1.room_number, S2.Fname, S2.Lname,  D2.dorm_name, L2.room_number 
FROM Student AS S1, Student AS S2, Has_Pet AS H1, Has_Pet AS H2,Pet AS P1, Pet AS P2,
Dorm AS D1, Dorm AS D2, Lives_in AS L1, Lives_in AS L2
WHERE S1.stuid = H1.stuid AND S2.stuid =H2.stuid 
AND H1.Petid = P1.PetID AND H2.Petid = P2.Petid 
AND ((P1.PetType = 'Dog' AND P2.PetType = 'Cat') OR (P1.PetType = 'Cat' AND P2.PetType = 'Parrot')
or (P1.PetType = 'Cat' AND P2.PetType = 'Dog') OR(P1.PetType = 'Parrot' AND P2.PetType='Cat'))
AND S1.stuid < S2.stuid
AND S1.stuid = L1.stuid AND S2.stuid = L2.stuid 
AND L1.dormid = D1.dormid AND L2.dormid = D2.dormid; 

/*Question 46*/
SELECT  COUNT(DISTINCT L1.room_number) AS num_occupied_room, D.dorm_name, D.Student_capacity
FROM Lives_in AS L1, Dorm AS D
WHERE L1.dormid = D.dormid 
GROUP BY L1.dormid;

/*Question 47*/
SELECT IFNULL(T1.num_pet_room,0) as num_pet_room, Dorm.dorm_name
FROM
(SELECT COUNT(DISTINCT T.room_number) AS num_pet_room, T.dormid
FROM 
(SELECT DISTINCT L1.stuid, L1.dormid, L1.room_number, H1.Petid 
FROM Lives_in AS L1
INNER JOIN Has_Pet AS H1
ON L1.stuid = H1.stuid) AS T 
GROUP BY T.dormid) as T1
RIGHT JOIN 
Dorm 
ON T1.dormid = Dorm.dormid;

/*Question 48*/
SELECT T2.dorm_name,IFNULL(T1.num_pet,0) AS num_pet,IFNULL(num_pet_room/num_room,0) AS percent_room
FROM
(SELECT  COUNT(DISTINCT Lives_in.room_number) AS num_pet_room,Lives_in.dormid, COUNT(DISTINCT Has_Pet.petid) AS num_pet
FROM Has_Pet, Lives_in, Dorm
WHERE Has_Pet.stuid = Lives_in.stuid 
GROUP BY dormid ) AS T1
RIGHT JOIN 
(
SELECT COUNT(DISTINCT Lives_in.room_number) AS num_room, Lives_in.dormid,Dorm.dorm_name
FROM Lives_in, Dorm
WHERE Dorm.dormid = Lives_in.dormid
GROUP BY Lives_in.dormid
 ) AS T2
ON T1.dormid = T2.dormid;


/*Question 49*/ 
/* List the max amount of time on average a department's student spend on Role Playing video Games*/
SELECT T2.avg_hr_played
FROM
(SELECT MAX(T1.avg_hr_played) AS max_hr
FROM 
(SELECT D.DName, AVG(T.Hours_played) AS avg_hr_played
FROM Department AS D, 
(SELECT  V.GType, P.StuID, P.GameID, P.Hours_played, S.Major
FROM Video_Games AS V, Plays_Games AS P, Student AS S
WHERE V.GType = 'Role-playing game' 
AND V.GameID = P.GameID
AND S.StuID = P.Stuid ) AS T
WHERE T.Major = D.DNO
GROUP BY D.DNO ) AS T1) AS MAX,

(SELECT D.DName, AVG(T.Hours_played) AS avg_hr_played
FROM Department AS D, 
(SELECT  V.GType, P.StuID, P.GameID, P.Hours_played, S.Major
FROM Video_Games AS V, Plays_Games AS P, Student AS S
WHERE V.GType = 'Role-playing game' 
AND V.GameID = P.GameID
AND S.StuID = P.Stuid ) AS T
WHERE T.Major = D.DNO
GROUP BY D.DNO ) AS T2
WHERE T2.avg_hr_played = MAX.max_hr;




