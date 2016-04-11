#AUTHOR Christoffer Hjort s144224

USE Train_managementv1;

#TRIGGER THAT THROWS ERROR IF TRYING TO INSERT MORE TRACKS TO A STATION THAN THE STATION HAS CAPACITY
DELIMITER $$
CREATE TRIGGER capacityCheck
BEFORE INSERT ON Track FOR EACH ROW
BEGIN
	DECLARE errorText TEXT;
	IF (SELECT Lanes FROM Station WHERE StationName = New.TrackFrom)
		<= (SELECT count(Id)/2 FROM Track WHERE TrackFrom = New.TrackFrom OR TrackTo = New.TrackFrom)
    THEN
		SET errorText = CONCAT((SELECT StationName FROM Station WHERE StationName = New.TrackFrom), " can not have any more tracks");
        SIGNAL SQLSTATE '45000'SET MESSAGE_TEXT = errorText;
    END IF;
    
    IF (SELECT Lanes FROM Station WHERE StationName = New.TrackTo)
		<= (SELECT count(Id)/2 FROM Track WHERE TrackFrom = New.TrackTo OR TrackTo = New.TrackTo)
    THEN
		SET errorText = CONCAT((SELECT StationName FROM Station WHERE StationName = New.TrackTo), " can not have any more tracks");
        SIGNAL SQLSTATE '45000'SET MESSAGE_TEXT = errorText;
    END IF;
    
END;$$ 
DELIMITER ;



#FUNCTION THAT CALCULATES AND RETURNS LENGTH OF A ROUTE
DELIMITER $$
CREATE FUNCTION routeLength (routeId INT)
RETURNS INT
BEGIN
	DECLARE len INT;
    SET len = (SELECT Sum(Length) FROM Track WHERE Id IN (SELECT Track_Id FROM RouteTracks, Route WHERE Route_Id = routeId));
	RETURN len;
END;$$
DELIMITER ;
SELECT routeLength(2);



#FUNCTION AGE OF TRAIN
DELIMITER $$
CREATE FUNCTION TrainAge (trainID INT)
RETURNS INT
BEGIN
	DECLARE age INT;
    SET age = YEAR(curdate()) - (SELECT ProductionYear FROM Train WHERE id = trainID);
	RETURN age;
END;$$
DELIMITER ;
SELECT TrainAge(1);



#PROCEDURE Neighbours of Station
DELIMITER $$
CREATE PROCEDURE StationNeighbours (IN vStationName VARCHAR(25))
BEGIN
    SELECT TrackTo FROM Track WHERE TrackFrom = vStationName;
END;$$
DELIMITER ;
CALL StationNeighbours("Roskilde st");



#PROCEDURE CONNECT STATIONS PARALLEL
DELIMITER $$
CREATE PROCEDURE ConnectStationsParallel
(IN vStationName1 VARCHAR(25), IN vStationName2 VARCHAR(25), IN vDistance INT)
BEGIN
    INSERT Track VALUES(0, vDistance, vStationName1, vStationName2);
    INSERT Track VALUES(0, vDistance, vStationName2, vStationName1);
END;$$
DELIMITER ;
CALL ConnectStationsParallel("TempCity", "Hvalsø st", 10);



#PROCEDURE WITH TRANSACTION #Add new City and Connect to City. Adds main station of new city as well.
DELIMITER $$
CREATE PROCEDURE AddCityConnectTo
(IN vCityName VARCHAR(45), IN vZip INT, IN vLanes INT, IN vDistance INT, IN vTargetName VARCHAR(45), OUT vStatus TEXT)
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



#PROCEDURE THAT FIND EVERY EMPLOYEE WORKING ON SPECIFIED DAY
DELIMITER $$
CREATE PROCEDURE EmployeesOnDate
(IN vDate DATE)
BEGIN
    SELECT * FROM Employee WHERE Initials IN (SELECT Employee_Initials FROM Shift WHERE ShiftStart LIKE CONCAT(vDate,'%'));
END;$$
DELIMITER ;



#EVENT EVERY DAY, CALLS EmployeesOnDate
SET GLOBAL event_scheduler = 1;
SHOW VARIABLES LIKE 'event_scheduler';

CREATE EVENT EmployeesToday ON SCHEDULE EVERY 1 DAY
STARTS '2016-04-11 00:00:01'
DO CALL EmployeesonDate(CURDATE());






