-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema Train_managementV1
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Train_managementV1
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Train_managementV1` DEFAULT CHARACTER SET utf8 ;
USE `Train_managementV1` ;

-- -----------------------------------------------------
-- Table `Train_managementV1`.`City`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Train_managementV1`.`City` ;

CREATE TABLE IF NOT EXISTS `Train_managementV1`.`City` (
  `Zip` INT NOT NULL,
  `CityName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Zip`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Train_managementV1`.`Station`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Train_managementV1`.`Station` ;

CREATE TABLE IF NOT EXISTS `Train_managementV1`.`Station` (
  `StationName` VARCHAR(25) NOT NULL,
  `Lanes` INT NOT NULL,
  `City_Zip` INT NOT NULL,
  PRIMARY KEY (`StationName`),
  INDEX `fk_Station_City1_idx` (`City_Zip` ASC),
  CONSTRAINT `fk_Station_City1`
    FOREIGN KEY (`City_Zip`)
    REFERENCES `Train_managementV1`.`City` (`Zip`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Train_managementV1`.`Track`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Train_managementV1`.`Track` ;

CREATE TABLE IF NOT EXISTS `Train_managementV1`.`Track` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Length` INT NOT NULL,
  `TrackFrom` VARCHAR(25) NOT NULL,
  `TrackTo` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_Track_Station_idx` (`TrackFrom` ASC),
  INDEX `fk_Track_Station1_idx` (`TrackTo` ASC),
  CONSTRAINT `fk_Track_Station`
    FOREIGN KEY (`TrackFrom`)
    REFERENCES `Train_managementV1`.`Station` (`StationName`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Track_Station1`
    FOREIGN KEY (`TrackTo`)
    REFERENCES `Train_managementV1`.`Station` (`StationName`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Train_managementV1`.`Route`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Train_managementV1`.`Route` ;

CREATE TABLE IF NOT EXISTS `Train_managementV1`.`Route` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `RouteStart` VARCHAR(25) NOT NULL,
  `RouteStop` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_Route_Station1_idx` (`RouteStart` ASC),
  INDEX `fk_Route_Station2_idx` (`RouteStop` ASC),
  CONSTRAINT `fk_Route_Station1`
    FOREIGN KEY (`RouteStart`)
    REFERENCES `Train_managementV1`.`Station` (`StationName`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Route_Station2`
    FOREIGN KEY (`RouteStop`)
    REFERENCES `Train_managementV1`.`Station` (`StationName`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Train_managementV1`.`RouteTracks`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Train_managementV1`.`RouteTracks` ;

CREATE TABLE IF NOT EXISTS `Train_managementV1`.`RouteTracks` (
  `Track_Id` INT NOT NULL,
  `Route_Id` INT NOT NULL,
  INDEX `fk_RouteTracks_Track1_idx` (`Track_Id` ASC),
  PRIMARY KEY (`Route_Id`, `Track_Id`),
  INDEX `fk_RouteTracks_Route1_idx` (`Route_Id` ASC),
  CONSTRAINT `fk_RouteTracks_Track1`
    FOREIGN KEY (`Track_Id`)
    REFERENCES `Train_managementV1`.`Track` (`Id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RouteTracks_Route1`
    FOREIGN KEY (`Route_Id`)
    REFERENCES `Train_managementV1`.`Route` (`Id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Train_managementV1`.`Train`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Train_managementV1`.`Train` ;

CREATE TABLE IF NOT EXISTS `Train_managementV1`.`Train` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Model` VARCHAR(45) NULL,
  `ProductionYear` INT NULL,
  `Route_Id` INT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_Train_Route1_idx` (`Route_Id` ASC),
  CONSTRAINT `fk_Train_Route1`
    FOREIGN KEY (`Route_Id`)
    REFERENCES `Train_managementV1`.`Route` (`Id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Train_managementV1`.`Employee`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Train_managementV1`.`Employee` ;

CREATE TABLE IF NOT EXISTS `Train_managementV1`.`Employee` (
  `Initials` VARCHAR(3) NOT NULL,
  `FirstName` VARCHAR(25) NOT NULL,
  `LastName` VARCHAR(25) NOT NULL,
  `MiddleName` VARCHAR(45) NULL,
  `StreetName` VARCHAR(45) NULL,
  `StreetNo` INT NULL,
  `City_Zip` INT NULL,
  `Job` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`Initials`),
  INDEX `fk_Employee_City1_idx` (`City_Zip` ASC),
  CONSTRAINT `fk_Employee_City1`
    FOREIGN KEY (`City_Zip`)
    REFERENCES `Train_managementV1`.`City` (`Zip`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Train_managementV1`.`Shift`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Train_managementV1`.`Shift` ;

CREATE TABLE IF NOT EXISTS `Train_managementV1`.`Shift` (
  `Employee_Initials` VARCHAR(3) NOT NULL,
  `Train_Id` INT NOT NULL,
  `ShiftStart` DATETIME NOT NULL,
  `ShiftEnd` DATETIME NOT NULL,
  PRIMARY KEY (`Employee_Initials`, `Train_Id`),
  INDEX `fk_Shift_Train1_idx` (`Train_Id` ASC),
  CONSTRAINT `fk_Shift_Employee1`
    FOREIGN KEY (`Employee_Initials`)
    REFERENCES `Train_managementV1`.`Employee` (`Initials`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Shift_Train1`
    FOREIGN KEY (`Train_Id`)
    REFERENCES `Train_managementV1`.`Train` (`Id`)
    ON DELETE CASCADE #Maybe just SET NULL
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `Train_managementV1` ;

-- -----------------------------------------------------
-- Placeholder table for view `Train_managementV1`.`RouteView`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Train_managementV1`.`RouteView` (`Id` INT, `RouteStart` INT, `RouteStop` INT);

-- -----------------------------------------------------
-- View `Train_managementV1`.`RouteView`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `Train_managementV1`.`RouteView` ;
DROP TABLE IF EXISTS `Train_managementV1`.`RouteView`;
USE `Train_managementV1`;
CREATE  OR REPLACE VIEW `RouteView` AS
    SELECT 
        Id, RouteStart, RouteStop
    FROM
        Route;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
