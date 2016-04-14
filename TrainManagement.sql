-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema TrainManagement
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema TrainManagement
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `TrainManagement` DEFAULT CHARACTER SET utf8 ;
USE `TrainManagement` ;

-- -----------------------------------------------------
-- Table `TrainManagement`.`City`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TrainManagement`.`City` ;

CREATE TABLE IF NOT EXISTS `TrainManagement`.`City` (
  `Zip` INT NOT NULL,
  `CityName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Zip`));
#ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TrainManagement`.`Station`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TrainManagement`.`Station` ;

CREATE TABLE IF NOT EXISTS `TrainManagement`.`Station` (
  `StationName` VARCHAR(25) NOT NULL,
  `Lanes` INT NOT NULL,
  `Zip` INT NOT NULL,
  PRIMARY KEY (`StationName`),
  INDEX `fk_Station_City1_idx` (`Zip` ASC),
  CONSTRAINT `fk_Station_City1`
    FOREIGN KEY (`Zip`) 
    REFERENCES `TrainManagement`.`City` (`Zip`) 
    ON DELETE CASCADE 
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TrainManagement`.`Track`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TrainManagement`.`Track` ;

CREATE TABLE IF NOT EXISTS `TrainManagement`.`Track` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Length` INT NOT NULL,
  `FromStation` VARCHAR(25) NOT NULL,
  `ToStation` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_Track_Station_idx` (`FromStation` ASC),
  INDEX `fk_Track_Station1_idx` (`ToStation` ASC),
  CONSTRAINT `fk_Track_Station`
    FOREIGN KEY (`FromStation`)
    REFERENCES `TrainManagement`.`Station` (`StationName`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Track_Station1`
    FOREIGN KEY (`ToStation`)
    REFERENCES `TrainManagement`.`Station` (`StationName`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TrainManagement`.`Route`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TrainManagement`.`Route` ;

CREATE TABLE IF NOT EXISTS `TrainManagement`.`Route` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `StartStation` VARCHAR(25) NOT NULL,
  `EndStation` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_Route_Station1_idx` (`StartStation` ASC),
  INDEX `fk_Route_Station2_idx` (`EndStation` ASC),
  CONSTRAINT `fk_Route_Station1`
    FOREIGN KEY (`StartStation`)
    REFERENCES `TrainManagement`.`Station` (`StationName`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Route_Station2`
    FOREIGN KEY (`EndStation`)
    REFERENCES `TrainManagement`.`Station` (`StationName`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TrainManagement`.`RouteTrack`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TrainManagement`.`RouteTrack` ;

CREATE TABLE IF NOT EXISTS `TrainManagement`.`RouteTrack` (
  `Track_Id` INT NOT NULL,
  `Route_Id` INT NOT NULL,
  `Number` INT NOT NULL,
  INDEX `fk_RouteTrack_Track1_idx` (`Track_Id` ASC),
  PRIMARY KEY (`Route_Id`, `Track_Id`),
  INDEX `fk_RouteTrack_Route1_idx` (`Route_Id` ASC),
  CONSTRAINT `fk_RouteTrack_Track1`
    FOREIGN KEY (`Track_Id`)
    REFERENCES `TrainManagement`.`Track` (`Id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RouteTrack_Route1`
    FOREIGN KEY (`Route_Id`)
    REFERENCES `TrainManagement`.`Route` (`Id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TrainManagement`.`Train`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TrainManagement`.`Train` ;

CREATE TABLE IF NOT EXISTS `TrainManagement`.`Train` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Model` VARCHAR(45) NULL,
  `ProductionYear` INT NULL,
  `Route` INT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_Train_Route1_idx` (`Route` ASC),
  CONSTRAINT `fk_Train_Route1`
    FOREIGN KEY (`Route`)
    REFERENCES `TrainManagement`.`Route` (`Id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TrainManagement`.`Employee`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TrainManagement`.`Employee` ;

CREATE TABLE IF NOT EXISTS `TrainManagement`.`Employee` (
  `Initials` VARCHAR(3) NOT NULL,
  `FirstName` VARCHAR(25) NOT NULL,
  `LastName` VARCHAR(25) NOT NULL,
  `MiddleName` VARCHAR(45) NULL,
  `StreetName` VARCHAR(45) NULL,
  `StreetNo` INT NULL,
  `Zip` INT NULL,
  `Job` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`Initials`),
  INDEX `fk_Employee_City1_idx` (`Zip` ASC),
  CONSTRAINT `fk_Employee_City1`
    FOREIGN KEY (`Zip`)
    REFERENCES `TrainManagement`.`City` (`Zip`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TrainManagement`.`Shift`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TrainManagement`.`Shift` ;

CREATE TABLE IF NOT EXISTS `TrainManagement`.`Shift` (
  `Employee_Initials` VARCHAR(3) NOT NULL,
  `Train_Id` INT NOT NULL,
  `ShiftStart` DATETIME NOT NULL,
  `ShiftEnd` DATETIME NOT NULL,
  PRIMARY KEY (`Employee_Initials`, `Train_Id`),
  INDEX `fk_Shift_Train1_idx` (`Train_Id` ASC),
  CONSTRAINT `fk_Shift_Employee1`
    FOREIGN KEY (`Employee_Initials`)
    REFERENCES `TrainManagement`.`Employee` (`Initials`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Shift_Train1`
    FOREIGN KEY (`Train_Id`)
    REFERENCES `TrainManagement`.`Train` (`Id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `TrainManagement` ;

-- -----------------------------------------------------
-- Placeholder table for view `TrainManagement`.`RouteView`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TrainManagement`.`RouteView` 
    (`Id` INT, `StartStation` INT, `EndStation` INT);

-- -----------------------------------------------------
-- View `TrainManagement`.`RouteView`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `TrainManagement`.`RouteView` ;
DROP TABLE IF EXISTS `TrainManagement`.`RouteView`;
USE `TrainManagement`;
CREATE OR REPLACE VIEW `RouteView` AS
    SELECT 
        Id, StartStation, EndStation
    FROM
        Route;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
