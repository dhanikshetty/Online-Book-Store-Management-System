-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema OBSM
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema OBSM
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `OBSM` DEFAULT CHARACTER SET latin1 ;
USE `OBSM` ;

-- -----------------------------------------------------
-- Table `OBSM`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `OBSM`.`customer` (
  `email` VARCHAR(200) NOT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `address` VARCHAR(200) NOT NULL,
  `phone` VARCHAR(45) NULL DEFAULT NULL,
  `password` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`email`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `OBSM`.`ORDERS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `OBSM`.`ORDERS` (
  `date` DATE NOT NULL,
  `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `customer_email` VARCHAR(200) NOT NULL,
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  INDEX `fk_ORDERS_customer1_idx` (`customer_email` ASC),
  CONSTRAINT `fk_ORDERS_customer1`
    FOREIGN KEY (`customer_email`)
    REFERENCES `OBSM`.`customer` (`email`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `OBSM`.`author`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `OBSM`.`author` (
  `ID` INT(11) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(150) NULL DEFAULT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `OBSM`.`publisher`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `OBSM`.`publisher` (
  `name` VARCHAR(100) NOT NULL,
  `address` VARCHAR(200) NOT NULL,
  `phone` INT(11) NOT NULL,
  PRIMARY KEY (`name`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `OBSM`.`books`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `OBSM`.`books` (
  `ISBN` INT(11) NOT NULL,
  `title` VARCHAR(100) NOT NULL,
  `price` INT(11) NOT NULL,
  `genre` VARCHAR(20) NOT NULL,
  `author_ID` INT(11) NOT NULL,
  `publisher_name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`ISBN`),
  INDEX `fk_books_author1_idx` (`author_ID` ASC),
  INDEX `fk_books_publisher1_idx` (`publisher_name` ASC),
  CONSTRAINT `fk_books_author1`
    FOREIGN KEY (`author_ID`)
    REFERENCES `OBSM`.`author` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_books_publisher1`
    FOREIGN KEY (`publisher_name`)
    REFERENCES `OBSM`.`publisher` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `OBSM`.`cart_has_books`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `OBSM`.`cart_has_books` (
  `books_ISBN` INT(11) NOT NULL,
  `count` INT(11) NULL DEFAULT NULL,
  `customer_email` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`books_ISBN`, `customer_email`),
  INDEX `fk_cart_has_books_books1_idx` (`books_ISBN` ASC),
  INDEX `fk_cart_has_books_customer1_idx` (`customer_email` ASC),
  CONSTRAINT `fk_cart_has_books_books1`
    FOREIGN KEY (`books_ISBN`)
    REFERENCES `OBSM`.`books` (`ISBN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cart_has_books_customer1`
    FOREIGN KEY (`customer_email`)
    REFERENCES `OBSM`.`customer` (`email`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `OBSM`.`order_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `OBSM`.`order_items` (
  `item_isbn` INT(11) NOT NULL,
  `count` VARCHAR(45) NULL DEFAULT NULL,
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `order_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `order_id_idx` (`order_id` ASC),
  CONSTRAINT `order_id`
    FOREIGN KEY (`order_id`)
    REFERENCES `OBSM`.`ORDERS` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `OBSM`.`warehouse`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `OBSM`.`warehouse` (
  `code` INT(11) NOT NULL,
  `address` VARCHAR(200) NOT NULL,
  `phone` INT(11) NOT NULL,
  PRIMARY KEY (`code`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `OBSM`.`warehouse_has_books`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `OBSM`.`warehouse_has_books` (
  `warehouse_code` INT(11) NOT NULL,
  `books_ISBN` INT(11) NOT NULL,
  `count` INT(11) NOT NULL,
  PRIMARY KEY (`warehouse_code`, `books_ISBN`),
  INDEX `fk_warehouse_has_books_books1_idx` (`books_ISBN` ASC),
  INDEX `fk_warehouse_has_books_warehouse1_idx` (`warehouse_code` ASC),
  CONSTRAINT `fk_warehouse_has_books_books1`
    FOREIGN KEY (`books_ISBN`)
    REFERENCES `OBSM`.`books` (`ISBN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_warehouse_has_books_warehouse1`
    FOREIGN KEY (`warehouse_code`)
    REFERENCES `OBSM`.`warehouse` (`code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

