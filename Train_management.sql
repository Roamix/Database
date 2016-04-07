-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema Train_management
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Train_management
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Train_management` DEFAULT CHARACTER SET utf8 ;
USE `Train_management` ;

-- -----------------------------------------------------
-- Table `Train_management`.`City`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Train_management`.`City` (
  `Zip` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Zip`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Train_management`.`Station`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Train_management`.`Station` (
  `Name` VARCHAR(25) NOT NULL,
  `Lanes` INT NOT NULL,
  `City_Zip` INT NOT NULL,
  PRIMARY KEY (`Name`),
  INDEX `fk_Station_City1_idx` (`City_Zip` ASC),
  CONSTRAINT `fk_Station_City1`
    FOREIGN KEY (`City_Zip`)
    REFERENCES `Train_management`.`City` (`Zip`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Train_management`.`Track`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Train_management`.`Track` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Length` INT NOT NULL,
  `From` VARCHAR(25) NOT NULL,
  `To` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_Track_Station_idx` (`From` ASC),
  INDEX `fk_Track_Station1_idx` (`To` ASC),
  CONSTRAINT `fk_Track_Station`
    FOREIGN KEY (`From`)
    REFERENCES `Train_management`.`Station` (`Name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Track_Station1`
    FOREIGN KEY (`To`)
    REFERENCES `Train_management`.`Station` (`Name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Train_management`.`Route`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Train_management`.`Route` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Start` VARCHAR(25) NOT NULL,
  `Stop` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_Route_Station1_idx` (`Start` ASC),
  INDEX `fk_Route_Station2_idx` (`Stop` ASC),
  CONSTRAINT `fk_Route_Station1`
    FOREIGN KEY (`Start`)
    REFERENCES `Train_management`.`Station` (`Name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Route_Station2`
    FOREIGN KEY (`Stop`)
    REFERENCES `Train_management`.`Station` (`Name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Train_management`.`RouteTracks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Train_management`.`RouteTracks` (
  `Track_Id` INT NOT NULL,
  `Route_Id` INT NOT NULL,
  INDEX `fk_RouteTracks_Track1_idx` (`Track_Id` ASC),
  PRIMARY KEY (`Route_Id`, `Track_Id`),
  INDEX `fk_RouteTracks_Route1_idx` (`Route_Id` ASC),
  CONSTRAINT `fk_RouteTracks_Track1`
    FOREIGN KEY (`Track_Id`)
    REFERENCES `Train_management`.`Track` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RouteTracks_Route1`
    FOREIGN KEY (`Route_Id`)
    REFERENCES `Train_management`.`Route` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Train_management`.`Train`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Train_management`.`Train` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Model` VARCHAR(45) NULL,
  `ProductionYear` INT NULL,
  `Route_Id` INT NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_Train_Route1_idx` (`Route_Id` ASC),
  CONSTRAINT `fk_Train_Route1`
    FOREIGN KEY (`Route_Id`)
    REFERENCES `Train_management`.`Route` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Train_management`.`Employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Train_management`.`Employee` (
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
    REFERENCES `Train_management`.`City` (`Zip`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Train_management`.`Shift`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Train_management`.`Shift` (
  `Employee_Initials` VARCHAR(3) NOT NULL,
  `Train_Id` INT NOT NULL,
  `ShiftStart` DATETIME NOT NULL,
  `ShiftEnd` DATETIME NOT NULL,
  PRIMARY KEY (`Employee_Initials`, `Train_Id`),
  INDEX `fk_Shift_Train1_idx` (`Train_Id` ASC),
  CONSTRAINT `fk_Shift_Employee1`
    FOREIGN KEY (`Employee_Initials`)
    REFERENCES `Train_management`.`Employee` (`Initials`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Shift_Train1`
    FOREIGN KEY (`Train_Id`)
    REFERENCES `Train_management`.`Train` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `Train_management` ;

-- -----------------------------------------------------
-- Placeholder table for view `Train_management`.`RouteView`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Train_management`.`RouteView` (`Id` INT, `Start` INT, `Stop` INT);

-- -----------------------------------------------------
-- View `Train_management`.`RouteView`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Train_management`.`RouteView`;
USE `Train_management`;
CREATE  OR REPLACE VIEW `RouteView` AS SELECT Id, Start, Stop FROM Route;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
