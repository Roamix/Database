#AUTHORS 
# Christoffer Hjort s144224
# Tobias Skovlund Petersen s123302

use TrainManagement;

SELECT * FROM City;
SELECT * FROM Station;
SELECT * FROM Track;
SELECT * FROM Route;
SELECT * FROM RouteTrack;
SELECT * FROM Train;
SELECT * FROM Employee;
SELECT * FROM Shift;

### DROP ORDER ###
#DROP TABLE RouteTracks;
#DROP TABLE Track;
#DROP TABLE Shift;
#DROP TABLE Employee;
#DROP TABLE Train;
#DROP TABLE Route;
#DROP TABLE Station;
#DROP TABLE City;

###########DELETE STATEMENTS##############
DELETE FROM City;     #Cascade delete Station and set Employee.Zip to NULL
DELETE FROM Station;  #Cascade delete Track and Route
DELETE FROM Track;    #Cascade delete RouteTrack
DELETE FROM Route;    #Cascade delete RouteTrack and set Train.Route_Id to NULL
DELETE FROM Train;    #Cascade delete Shift;
DELETE FROM Employee; #Cascade delete Shift;

############INSERT STATEMENTS###################
#Single insert statement
INSERT City VALUES(4000, "Roskilde");
#Multiple insert statements
INSERT City VALUES
    (4320, "Lejre"), 
    (4330, "Hvalsø");
INSERT Station VALUES
    ("Roskilde st", 6, 4000), 
    ("Roskilde udkants st", 2, 4000), 
    ("Lejre st", 2, 4320), 
    ("Hvalsø st", 2, 4330);
INSERT Track VALUES
    (1, 9, "Lejre st", "Roskilde st"), 
    (2, 9, "Roskilde st", "Lejre st");
INSERT Track VALUES
    (3, 10, "Hvalsø st", "Lejre st"), 
    (4, 10, "Lejre st", "Hvalsø st");
INSERT Track VALUES
    (5, 3, "Roskilde st", "Roskilde udkants st"), 
    (6, 3, "Roskilde udkants st", "Roskilde st");
INSERT Route VALUES
    (1, "Hvalsø st", "Roskilde st"),
    (2, "Roskilde udkants st", "Lejre Station");
INSERT RouteTrack VALUES 
    (3,1,1), 
    (1,1,2);
INSERT RouteTrack VALUES
    (6,2,1), 
    (2,2,2), 
    (4,2,3), 
    (3,2,4);
INSERT Train VALUES
    (0001, "IC400", 2006, 1);
INSERT Employee VALUES
    ("CH", "Christoffer", "Hjort", NULL, "Sandbanken", 2, 4320, "Train Operator"),
    ("TSP", "Tobias", "Petersen", "Skovlund", "Banevej", 2, 2800, "Conductor");
INSERT Shift VALUES
    ("CH", 1, '2016-04-14 09:00:00', '2016-04-14  17:00:00'),
    ("TSP", 1, '2016-04-14 08:00:00', '2016-04-14  16:00:00');

############UPDATE STATEMENTS###################
UPDATE Station SET Lanes = 3 WHERE StationName = "Hvalsø st";
UPDATE Track SET Length = 9 WHERE id = 1;
UPDATE Employee SET Job = "Conductor" WHERE Initials = "CH";
UPDATE Shift SET ShiftEnd = '2016-04-10 19:00:00' 
    WHERE ShiftEnd = '2016-04-14 17:00:00';

DROP VIEW IF EXISTS RouteLengths;
# Gives the total length of a route
CREATE VIEW RouteLengths AS
SELECT RouteTrack.Route_Id, SUM(Length) AS TotalLength 
FROM RouteTrack JOIN Track 
WHERE RouteTrack.Track_Id = Track.Id
GROUP BY RouteTrack.Route_Id;
SELECT * FROM RouteLengths;

DROP VIEW IF EXISTS TracksOnRoute;
# Gives all tracks in all routes, ordered.
CREATE VIEW TracksOnRoute AS
SELECT Route_Id AS Id, FromStation, ToStation
FROM RouteTrack JOIN Track
WHERE Track_Id = Track.Id
ORDER BY Route_Id, Number;
SELECT * FROM TracksOnRoute;
