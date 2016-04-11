#AUTHOR Christoffer Hjort s144224

use Train_managementv1;

SELECT * FROM City;
SELECT * FROM Station;
SELECT * FROM Track;
SELECT * FROM Route;
SELECT * FROM RouteTracks;
SELECT * FROM Train;
SELECT * FROM Employee;
SELECT * FROM Shift;

#DROP ORDER
DROP TABLE RouteTracks;
DROP TABLE Track;
DROP TABLE Shift;
DROP TABLE Employee;
DROP TABLE Train;
DROP TABLE Route;
DROP TABLE Station;
DROP TABLE City;

###########DELETE STATEMENTS##############
DELETE FROM City; #Will cascade delete Station, Track, Route, RouteTracks #Will set Train Route_Id to null
DELETE FROM Station; #Will cascade delete Track, Route, RouteTracks #Will set Train Route_Id to null
DELETE FROM Track; #Will cascade delete Route, RouteTracks #Will set Train Route_Id to null
DELETE FROM Route; #Will cascade delete RouteTracks #Train will have Route_Id set to null
DELETE FROM Train; #Will cascade delete Shift;
DELETE FROM Employee; #Will cascade delete Shift;

############INSERT STATEMENTS###################
#Single insert statement
INSERT City VALUES(4000, "Roskilde");
#Multiple insert statement
INSERT City VALUES(4320, "Lejre"), (4330, "Hvalsø");

INSERT Station VALUES("Roskilde st", 6, 4000), ("Lejre st", 2, 4320), ("Hvalsø st", 2, 4330);
INSERT Track VALUES(1, 9, "Lejre st", "Roskilde st"), (2, 9, "Roskilde st", "Lejre st");
INSERT Track VALUES(3, 10, "Hvalsø st", "Lejre st"), (4, 10, "Lejre st", "Hvalsø st");
INSERT Route VALUES(1, "Hvalsø st", "Roskilde st");
INSERT RouteTracks VALUES(1,1), (2,1);
INSERT Train VALUES(0001, "IC400", 2006, 1);
INSERT Employee VALUES("CH", "Christoffer", "Hjort", NULL, "Sandbanken", 2, 4320, "Train Operator");
INSERT Shift VALUES("CH", 1, '2016-04-14 09:00:00', '2016-04-14  17:00:00');

############UPDATE STATEMENTS###################
UPDATE Station SET Lanes = 3 WHERE StationName = "Hvalsø st";
UPDATE Track SET Length = 9 WHERE id = 1;
UPDATE Employee SET Job = "Conductor" WHERE Initials = "CH";
UPDATE Shift SET ShiftEnd = '2016-04-10 19:00:00' WHERE ShiftEnd = '2016-04-14 17:00:00';
