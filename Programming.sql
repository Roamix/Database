#AUTHOR Christoffer Hjort s144224

USE TrainManagement;

# Trigger that throw an error if trying to insert more
# tracks on a station thatn the station's capacity.
DELIMITER $$
CREATE TRIGGER capacityCheck
BEFORE INSERT ON Track FOR EACH ROW
BEGIN
	DECLARE errorText TEXT;
	IF (SELECT Lanes FROM Station WHERE StationName = New.FromStation)
		<= (SELECT count(Id)/2 FROM Track 
            WHERE FromStation = New.FromStation OR ToStation = New.FromStation)
    THEN
		SET errorText = CONCAT((SELECT StationName FROM Station 
                                WHERE StationName = New.FromStation), 
                                " can not have any more tracks");
        SIGNAL SQLSTATE '45000'SET MESSAGE_TEXT = errorText;
    END IF;
    
    IF (SELECT Lanes FROM Station WHERE StationName = New.ToStation)
		<= (SELECT count(Id)/2 FROM Track 
            WHERE FromStation = New.ToStation OR ToStation = New.ToStation)
    THEN
		SET errorText = CONCAT((SELECT StationName FROM Station 
                                WHERE StationName = New.ToStation), 
                                " can not have any more tracks");
        SIGNAL SQLSTATE '45000'SET MESSAGE_TEXT = errorText;
    END IF;
    
END;$$ 
DELIMITER ;


# This function exists merely to illustrate how it can be done,
# but its functinality is covered by the View 'RouteLengths'.
# Function that calculates the length of a route.
DELIMITER $$
CREATE FUNCTION routeLength (routeId INT)
RETURNS INT
BEGIN
	DECLARE len INT;
    SET len = (SELECT Sum(Length) FROM Track WHERE Id IN 
              (SELECT Track_Id FROM RouteTrack, Route WHERE Route_Id = Route.Id));
	RETURN len;
END;$$
DELIMITER ;
SELECT routeLength(2);


# Function that calculate the age of a train.
DELIMITER $$
CREATE FUNCTION TrainAge (trainID INT)
RETURNS INT
BEGIN
	DECLARE age INT;
    SET age = YEAR(curdate()) - 
             (SELECT ProductionYear FROM Train WHERE id = trainID);
	RETURN age;
END;$$
DELIMITER ;
SELECT TrainAge(1);


# Procedure that finds the neighbours of Station
DELIMITER $$
CREATE PROCEDURE StationNeighbours (IN vStationName VARCHAR(25))
BEGIN
    SELECT ToStation FROM Track WHERE FromStation = vStationName;
END;$$
DELIMITER ;
CALL StationNeighbours("Roskilde st");

# Procedure that connects two stations by two tracks,
# one in each direction
DELIMITER $$
CREATE PROCEDURE ConnectStationsParallel
(IN vStationName1 VARCHAR(25), IN vStationName2 VARCHAR(25), IN vDistance INT)
BEGIN
    INSERT Track VALUES(0, vDistance, vStationName1, vStationName2);
    INSERT Track VALUES(0, vDistance, vStationName2, vStationName1);
END;$$
DELIMITER ;
CALL ConnectStationsParallel("Roskilde udkants st", "Hvalsø st", 10);


# Procedure that adds a new city and connects it to 
# an existing city, by calling ConnectStationsParallel.
DELIMITER $$
CREATE PROCEDURE AddCityConnectTo
   (IN vCityName VARCHAR(45), 
    IN vZip INT, 
    IN vLanes INT, 
    IN vDistance INT, 
    IN vTargetName VARCHAR(45), 
    OUT vStatus TEXT)
#Add City with vCityName, Zip and Lanes = vLanes with vDistance to vTargetName
BEGIN
    DECLARE CityStationName TEXT;
    DECLARE TargetStationName TEXT;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET vStatus = "rollback";
    
    SET CityStationName = CONCAT(vCityName, " st");
    SET TargetStationName = CONCAT(vTargetName, " st");
    
    START TRANSACTION;
    INSERT City VALUES(vZip, vCityName);
    INSERT Station VALUES(CityStationName, vLanes, vZip);
    CALL ConnectStationsParallel(CityStationName, TargetStationName, vDistance);
    
    IF vStatus = "rollback"
    THEN
		SET vStatus = "Failed";
		ROLLBACK;
    ELSE
		SET vStatus = "Succes";
		COMMIT;
    END IF;
    
END;$$
DELIMITER ;
CALL AddCityConnectTo("Ringsted", 4100, 5, 13, "Roskilde", @vStatus);
SELECT @vStatus;

# Procedure that finds all employees working a specific day
DELIMITER $$
CREATE PROCEDURE EmployeesOnDate
(IN vDate DATE)
BEGIN
    SELECT * FROM Employee WHERE Initials IN 
    (SELECT Employee_Initials FROM Shift 
        WHERE ShiftStart LIKE CONCAT(vDate,'%'));
END;$$
DELIMITER ;


# Event that occurs every day, calls 'EmployeesOnDate'
SET GLOBAL event_scheduler = 1;
SHOW VARIABLES LIKE 'event_scheduler';

CREATE EVENT EmployeesToday ON SCHEDULE EVERY 1 DAY
STARTS '2016-04-11 00:00:01'
DO CALL EmployeesonDate(CURDATE());
