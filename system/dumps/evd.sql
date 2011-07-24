SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `evd2` ;
CREATE SCHEMA IF NOT EXISTS `evd2` DEFAULT CHARACTER SET utf8 ;
USE `evd2` ;

-- -----------------------------------------------------
-- Table `evd2`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `evd2`.`user` ;

CREATE  TABLE IF NOT EXISTS `evd2`.`user` (
  `user_id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `user_date_created` DATETIME NOT NULL ,
  `user_last_modified` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `user_last_login` DATETIME NOT NULL ,
  `user_login` VARCHAR(50) NOT NULL ,
  `user_password` VARCHAR(255) NOT NULL ,
  `user_email` VARCHAR(100) NOT NULL ,
  `user_activated` TINYINT(1) NOT NULL DEFAULT 1 ,
  `user_banned` TINYINT(1) NOT NULL DEFAULT 0 ,
  `user_ban_reason` VARCHAR(255) NULL DEFAULT NULL ,
  `user_new_password_key` VARCHAR(50) NULL DEFAULT NULL ,
  `user_new_password_requested` DATETIME NULL DEFAULT NULL ,
  `user_new_email` VARCHAR(100) NULL DEFAULT NULL ,
  `user_new_email_key` VARCHAR(50) NULL DEFAULT NULL ,
  `user_last_ip` VARCHAR(40) NOT NULL ,
  `user_firstname` VARCHAR(255) NOT NULL ,
  `user_middlename` VARCHAR(255) NULL ,
  `user_lastname` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`user_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `evd2`.`district`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `evd2`.`district` ;

CREATE  TABLE IF NOT EXISTS `evd2`.`district` (
  `district_id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `district_date_created` DATETIME NOT NULL ,
  `district_last_modified` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `district_name` VARCHAR(255) NULL DEFAULT NULL ,
  `district_presbyter` INT(11) UNSIGNED NOT NULL ,
  PRIMARY KEY (`district_id`) ,
  CONSTRAINT `fk_district_pastor_profile_id`
    FOREIGN KEY (`district_presbyter` )
    REFERENCES `evd2`.`pastor_profile` (`pastor_profile_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_district_pastor_profile_id` ON `evd2`.`district` (`district_presbyter` ASC) ;


-- -----------------------------------------------------
-- Table `evd2`.`section`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `evd2`.`section` ;

CREATE  TABLE IF NOT EXISTS `evd2`.`section` (
  `section_id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `section_date_created` DATETIME NOT NULL ,
  `section_last_modified` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `section_name` VARCHAR(255) NULL DEFAULT NULL ,
  `section_presbyter` INT(11) UNSIGNED NOT NULL ,
  `district_id` INT(11) UNSIGNED NOT NULL ,
  PRIMARY KEY (`section_id`) ,
  CONSTRAINT `fk_section_district_id`
    FOREIGN KEY (`district_id` )
    REFERENCES `evd2`.`district` (`district_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_section_pastor_profile_id`
    FOREIGN KEY (`section_presbyter` )
    REFERENCES `evd2`.`pastor_profile` (`pastor_profile_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_section_district_id` ON `evd2`.`section` (`district_id` ASC) ;

CREATE INDEX `fk_section_pastor_profile_id` ON `evd2`.`section` (`section_presbyter` ASC) ;


-- -----------------------------------------------------
-- Table `evd2`.`country`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `evd2`.`country` ;

CREATE  TABLE IF NOT EXISTS `evd2`.`country` (
  `country_id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `country_date_created` DATETIME NOT NULL ,
  `country_last_modified` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `country_name` VARCHAR(255) NULL ,
  PRIMARY KEY (`country_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `evd2`.`state`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `evd2`.`state` ;

CREATE  TABLE IF NOT EXISTS `evd2`.`state` (
  `state_id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `state_date_created` DATETIME NOT NULL ,
  `state_last_modified` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `state_name` VARCHAR(255) NULL ,
  `country_id` INT(11) UNSIGNED NOT NULL ,
  PRIMARY KEY (`state_id`) ,
  CONSTRAINT `fk_state_country_id`
    FOREIGN KEY (`country_id` )
    REFERENCES `evd2`.`country` (`country_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_state_country_id` ON `evd2`.`state` (`country_id` ASC) ;


-- -----------------------------------------------------
-- Table `evd2`.`city`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `evd2`.`city` ;

CREATE  TABLE IF NOT EXISTS `evd2`.`city` (
  `city_id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `city_date_created` DATETIME NOT NULL ,
  `city_last_modified` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `city_name` VARCHAR(255) NULL ,
  `state_id` INT(11) UNSIGNED NOT NULL ,
  PRIMARY KEY (`city_id`) ,
  CONSTRAINT `fk_city_state_id`
    FOREIGN KEY (`state_id` )
    REFERENCES `evd2`.`state` (`state_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_city_state_id` ON `evd2`.`city` (`state_id` ASC) ;


-- -----------------------------------------------------
-- Table `evd2`.`address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `evd2`.`address` ;

CREATE  TABLE IF NOT EXISTS `evd2`.`address` (
  `address_id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `address_date_created` DATETIME NULL ,
  `address_last_modified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `address_field1` VARCHAR(500) NULL ,
  `address_field2` VARCHAR(500) NULL ,
  `address_field3` VARCHAR(500) NULL ,
  `address_city` INT(11) UNSIGNED NOT NULL ,
  `address_state` INT(11) UNSIGNED NOT NULL ,
  `address_zip` VARCHAR(45) NULL ,
  `address_country` INT(11) UNSIGNED NOT NULL ,
  PRIMARY KEY (`address_id`) ,
  CONSTRAINT `fk_address_city`
    FOREIGN KEY (`address_city` )
    REFERENCES `evd2`.`city` (`city_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_address_country`
    FOREIGN KEY (`address_country` )
    REFERENCES `evd2`.`country` (`country_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_address_state`
    FOREIGN KEY (`address_state` )
    REFERENCES `evd2`.`state` (`state_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_address_city` ON `evd2`.`address` (`address_city` ASC) ;

CREATE INDEX `fk_address_country` ON `evd2`.`address` (`address_country` ASC) ;

CREATE INDEX `fk_address_state` ON `evd2`.`address` (`address_state` ASC) ;


-- -----------------------------------------------------
-- Table `evd2`.`church`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `evd2`.`church` ;

CREATE  TABLE IF NOT EXISTS `evd2`.`church` (
  `church_id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `church_date_created` DATETIME NOT NULL ,
  `church_last_modified` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `church_name` VARCHAR(255) NULL DEFAULT NULL ,
  `church_full_name` VARCHAR(1000) NULL DEFAULT NULL ,
  `section_id` INT(11) UNSIGNED NOT NULL ,
  `address_id` INT(11) UNSIGNED NOT NULL ,
  PRIMARY KEY (`church_id`) ,
  CONSTRAINT `fk_church_section_id`
    FOREIGN KEY (`section_id` )
    REFERENCES `evd2`.`section` (`section_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_church_address_id`
    FOREIGN KEY (`address_id` )
    REFERENCES `evd2`.`address` (`address_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_church_section_id` ON `evd2`.`church` (`section_id` ASC) ;

CREATE INDEX `fk_church_address_id` ON `evd2`.`church` (`address_id` ASC) ;


-- -----------------------------------------------------
-- Table `evd2`.`pastor_profile`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `evd2`.`pastor_profile` ;

CREATE  TABLE IF NOT EXISTS `evd2`.`pastor_profile` (
  `pastor_profile_id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `pastor_profile_date_created` DATETIME NOT NULL ,
  `pastor_profile_last_modified` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `pastor_profile_country` VARCHAR(20) NULL DEFAULT NULL ,
  `pastor_profile_website` VARCHAR(255) NULL DEFAULT NULL ,
  `pastor_profile_license` ENUM('local', 'general', 'ordained') NULL DEFAULT NULL ,
  `pastor_profile_title` ENUM('pastor', 'reverend') NULL DEFAULT NULL ,
  `user_id` INT(11) UNSIGNED NULL ,
  `church_id` INT(11) UNSIGNED NULL ,
  PRIMARY KEY (`pastor_profile_id`) ,
  CONSTRAINT `fk_pastor_profile_user_id`
    FOREIGN KEY (`user_id` )
    REFERENCES `evd2`.`user` (`user_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pastor_profile_church_id`
    FOREIGN KEY (`church_id` )
    REFERENCES `evd2`.`church` (`church_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_pastor_profile_user_id` ON `evd2`.`pastor_profile` (`user_id` ASC) ;

CREATE INDEX `fk_pastor_profile_church_id` ON `evd2`.`pastor_profile` (`church_id` ASC) ;


-- -----------------------------------------------------
-- Table `evd2`.`user_autologin`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `evd2`.`user_autologin` ;

CREATE  TABLE IF NOT EXISTS `evd2`.`user_autologin` (
  `key_id` CHAR(32) NOT NULL ,
  `user_id` INT(11) UNSIGNED NOT NULL DEFAULT '0' ,
  `user_agent` VARCHAR(150) NOT NULL ,
  `last_ip` VARCHAR(40) NOT NULL ,
  `last_login` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`key_id`, `user_id`) ,
  CONSTRAINT `fk_user_autologin_user_id`
    FOREIGN KEY (`user_id` )
    REFERENCES `evd2`.`user` (`user_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE INDEX `fk_user_autologin_user_id` ON `evd2`.`user_autologin` (`user_id` ASC) ;


-- -----------------------------------------------------
-- Table `evd2`.`login_attempts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `evd2`.`login_attempts` ;

CREATE  TABLE IF NOT EXISTS `evd2`.`login_attempts` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `ip_address` VARCHAR(40) NOT NULL ,
  `login` VARCHAR(50) NOT NULL ,
  `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `evd2`.`ci_sessions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `evd2`.`ci_sessions` ;

CREATE  TABLE IF NOT EXISTS `evd2`.`ci_sessions` (
  `session_id` VARCHAR(40) NOT NULL DEFAULT '0' ,
  `ip_address` VARCHAR(16) NOT NULL DEFAULT '0' ,
  `user_agent` VARCHAR(150) NOT NULL ,
  `last_activity` INT(10) UNSIGNED NOT NULL DEFAULT '0' ,
  `user_data` TEXT NOT NULL ,
  PRIMARY KEY (`session_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `evd2`.`article`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `evd2`.`article` ;

CREATE  TABLE IF NOT EXISTS `evd2`.`article` (
  `article_id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `article_date_created` DATETIME NOT NULL ,
  `article_last_modified` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `article_title` VARCHAR(200) NOT NULL ,
  `article_text` TEXT NOT NULL ,
  `user_id` INT(11) UNSIGNED NOT NULL ,
  PRIMARY KEY (`article_id`) ,
  CONSTRAINT `fk_article_user_id`
    FOREIGN KEY (`user_id` )
    REFERENCES `evd2`.`user` (`user_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_article_user_id` ON `evd2`.`article` (`user_id` ASC) ;


-- -----------------------------------------------------
-- Table `evd2`.`tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `evd2`.`tag` ;

CREATE  TABLE IF NOT EXISTS `evd2`.`tag` (
  `tag_id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `tag_date_created` DATETIME NOT NULL ,
  `tag_last_modified` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `tag_name` VARCHAR(100) NOT NULL ,
  PRIMARY KEY (`tag_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `evd2`.`article_has_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `evd2`.`article_has_tag` ;

CREATE  TABLE IF NOT EXISTS `evd2`.`article_has_tag` (
  `article_id` INT(11) UNSIGNED NOT NULL ,
  `tag_id` INT(11) UNSIGNED NOT NULL ,
  PRIMARY KEY (`article_id`, `tag_id`) ,
  CONSTRAINT `fk_article_has_tag_article_id`
    FOREIGN KEY (`article_id` )
    REFERENCES `evd2`.`article` (`article_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_article_has_tag_tag_id`
    FOREIGN KEY (`tag_id` )
    REFERENCES `evd2`.`tag` (`tag_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_article_has_tag_tag_id` ON `evd2`.`article_has_tag` (`tag_id` ASC) ;

CREATE INDEX `fk_article_has_tag_article_id` ON `evd2`.`article_has_tag` (`article_id` ASC) ;


INSERT INTO `address` (`address_id`, `address_date_created`, `address_last_modified`, `address_field1`, `address_field2`, `address_field3`, `address_city`, `address_state`, `address_zip`, `address_country`) VALUES (1, '2011-07-20 13:45:32', '2011-07-20 13:45:32', NULL, NULL, NULL, 442, 25, '6014', 1);
INSERT INTO `address` (`address_id`, `address_date_created`, `address_last_modified`, `address_field1`, `address_field2`, `address_field3`, `address_city`, `address_state`, `address_zip`, `address_country`) VALUES (2, '2011-07-20 13:45:32', '2011-07-20 13:45:32', NULL, NULL, NULL, 863, 44, NULL, 1);


INSERT INTO `article` (`article_id`, `article_date_created`, `article_last_modified`, `article_title`, `article_text`, `user_id`) VALUES (1, '2011-07-20 13:45:32', '2011-07-23 08:55:11', 'jQuery 1.6.2 Released', 'jQuery 1.6.2 is now out! This is the second minor release on top of jQuery 1.6 and lands a number of fixes for bugs.

As usual, we provide two copies of jQuery, one minified and one uncompressed (for debugging or reading).

jQuery Minified (for production)
jQuery Regular (for development and testing)
You can feel free to include the above URLs directly into your site and you will get the full performance benefits of a quickly-loading jQuery.

You can help us by dropping that code into your existing application and letting us know that if anything no longer works. Please file a bug and be sure to mention that you’re testing against jQuery 1.6.2.

We want to encourage everyone from the community to try and get involved in contributing back to jQuery core. We’ve set up a full page of information dedicated towards becoming more involved with the team. The team is here and ready to help you help us!', 1);
INSERT INTO `article` (`article_id`, `article_date_created`, `article_last_modified`, `article_title`, `article_text`, `user_id`) VALUES (2, '2011-07-20 13:45:32', '2011-07-23 08:55:36', 'JS Bin 2.8.0 is Out', 'JS Bin 2.8

Introducing JS Bin 2.8.0 - with live previews, resizable panels, autocomplete and more.', 1);
INSERT INTO `article` (`article_id`, `article_date_created`, `article_last_modified`, `article_title`, `article_text`, `user_id`) VALUES (3, '2011-07-20 13:45:32', '2011-07-23 08:56:55', 'IE10 Platform Preview 2 Released', 'What is a Platform Preview?
These are releases we send out on a regular basis. We are currently aiming to release a platform preview every 8-12 weeks, this one was released 11 weeks after IE10 PP1. These previews contain implementations of features that are close to final and are less likely to change, but by no means are guaranteed to represent the final implementation that we put in our shipping browser.

As well as platform previews we also release features on HTML5 Labs. HTML5labs.com is our way of bringing you interesting implementations so that you can test and provide feedback on them, with the caveat that the implementation will change and when we change there will likely be breaking changes. The File API has been the first feature from HTML5labs.com that has graduated to the Platform Preview. This graduation is an acknowledgement that were are happy that the standard is stable.', 1);
INSERT INTO `article` (`article_id`, `article_date_created`, `article_last_modified`, `article_title`, `article_text`, `user_id`) VALUES (4, '2011-07-23 08:56:55', '2011-07-23 08:57:54', 'WordPress 3.2 now available', 'Here in the U.S. we are observing Independence Day, and I can’t think of a more fitting way to mark a day that celebrates freedom than by releasing more free software to help democratize publishing around the globe. I’m excited to announce that WordPress 3.2 is now available to the world, both as an update in your dashboard and a download on WordPress.org. Version 3.2 is our fifteenth major release of WordPress and comes just four months after 3.1 (which coincidentally just passed the 15 million download mark this morning), reflecting the growing speed of development in the WordPress community and our dedication to getting improvements in your hands as soon as possible. We’re dedicating this release to noted composer and pianist George Gershwin.

Before we get to the release, in anticipation of the State of the Word speech at the upcoming WordCamp San Francisco (the annual WordPress conference) we’re doing a survey or census of the WordPress world. If you have a moment, please fill out this survey and we’ll share what we learn by publishing the aggregate results in August.

The focus for this release was making WordPress faster and lighter. The first thing you’ll notice when you log in to 3.2 is a refreshed dashboard design that tightens the typography, design, and code behind the admin. (Rhapsody in Grey?) If you’re starting a new blog, you’ll also appreciate the fully HTML5 new Twenty Eleven theme, fulfilling our plan to replace the default theme every year. Start writing your first post in our redesigned post editor and venture to the full-screen button in the editing toolbar to enter the new distraction-free writing or zen mode, my personal favorite feature of the release. All of the widgets, menus, buttons, and interface elements fade away to allow you to compose and edit your thoughts in a completely clean environment conducive to writing, but when your mouse strays to the top of the screen your most-used shortcuts are right there where you need them. (I like to press F11 to take my browser full-screen, getting rid of even the OS chrome.)', 1);
INSERT INTO `article` (`article_id`, `article_date_created`, `article_last_modified`, `article_title`, `article_text`, `user_id`) VALUES (5, '2011-07-23 08:56:55', '2011-07-23 08:58:51', 'Code Release: Backbone.js 0.5.0', 'After being on the slow burner for several months, Backbone.js 0.5.0 was released this afternoon. Backbone is the JavaScript library that DocumentCloud uses to build out the workspace where reporters can upload, edit and organize their primary source documents.

Along with a slew of tweaks and bug fixes, the most notable new feature is HTML5 “pushState” support, which you can see in action by trying a search in DocumentCloud’s public archive. This enables the use of true URLs, but also requires you to do a bit of extra work on the back end to be sure that your application is capable of serving these pages, so it’s strictly on an opt-in basis.', 1);


INSERT INTO `article_has_tag` (`article_id`, `tag_id`) VALUES (1, 1);
INSERT INTO `article_has_tag` (`article_id`, `tag_id`) VALUES (1, 2);
INSERT INTO `article_has_tag` (`article_id`, `tag_id`) VALUES (1, 3);


INSERT INTO `church` (`church_id`, `church_date_created`, `church_last_modified`, `church_name`, `church_full_name`, `section_id`, `address_id`) VALUES (1, '2011-07-20 13:45:32', '2011-07-20 13:45:32', 'MARC', 'Mandaue Apostolic Revival Center', 1, 1);
INSERT INTO `church` (`church_id`, `church_date_created`, `church_last_modified`, `church_name`, `church_full_name`, `section_id`, `address_id`) VALUES (2, '2011-07-20 13:45:32', '2011-07-20 13:45:32', 'OEWM', 'On Eagle\'s Wings Ministries', 2, 2);




INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bangued', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (2, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Boliney', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (3, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bucay', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (4, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bucloc', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (5, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Daguioman', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (6, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Danglas', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (7, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Dolores', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (8, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'La Paz', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (9, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Lacub', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (10, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Lagangilang', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (11, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Lagayan', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (12, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Langiden', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (13, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Licuan-Baay', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (14, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Luba', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (15, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Malibcong', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (16, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Manabo', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (17, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Peñarrubia', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (18, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pidigan', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (19, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pilar', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (20, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sallapadan', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (21, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Isidro', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (22, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Juan', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (23, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Quintin', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (24, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tayum', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (25, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tineg', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (26, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tubo', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (27, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Villaviciosa', 1);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (28, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Butuan City', 2);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (29, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Cabadbaran City', 2);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (30, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Buenavista', 2);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (31, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Carmen', 2);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (32, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Jabonga', 2);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (33, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Kitcharao', 2);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (34, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Las Nieves', 2);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (35, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Magallanes', 2);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (36, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Nasipit', 2);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (37, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Remedios T. Romualdez', 2);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (38, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Santiago', 2);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (39, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tubay', 2);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (40, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bayugan City', 3);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (41, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bunawan', 3);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (42, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Esperanza', 3);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (43, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'La Paz', 3);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (44, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Loreto', 3);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (45, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Prosperidad', 3);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (46, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Rosario', 3);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (47, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Francisco', 3);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (48, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Luis', 3);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (49, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Santa Josefa', 3);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (50, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sibagat', 3);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (51, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Talacogon', 3);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (52, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Trento', 3);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (53, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Veruela', 3);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (54, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Altavas', 4);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (55, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Balete', 4);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (56, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Banga', 4);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (57, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Batan', 4);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (58, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Buruanga', 4);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (59, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Ibajay', 4);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (60, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Kalibo', 4);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (61, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Lezo', 4);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (62, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Libacao', 4);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (63, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Madalag', 4);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (64, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Makato', 4);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (65, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Malay', 4);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (66, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Malinao', 4);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (67, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Nabas', 4);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (68, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'New Washington', 4);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (69, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Numancia', 4);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (70, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tangalan', 4);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (71, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Legazpi City', 5);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (72, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Ligao City', 5);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (73, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tabaco City', 5);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (74, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bacacay', 5);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (75, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Camalig', 5);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (76, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Daraga', 5);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (77, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Guinobatan', 5);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (78, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Jovellar', 5);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (79, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Libon', 5);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (80, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Malilipot', 5);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (81, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Malinao', 5);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (82, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Manito', 5);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (83, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Oas', 5);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (84, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pio Duran', 5);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (85, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Polangui', 5);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (86, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Rapu-Rapu', 5);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (87, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Santo Domingo', 5);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (88, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tiwi', 5);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (89, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Anini-y', 6);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (90, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Barbaza', 6);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (91, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Belison', 6);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (92, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bugasong', 6);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (93, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Caluya', 6);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (94, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Culasi', 6);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (95, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Hamtic', 6);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (96, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Laua-an', 6);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (97, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Libertad', 6);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (98, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pandan', 6);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (99, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Patnongon', 6);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (100, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Jose', 6);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (101, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Remigio', 6);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (102, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sebaste', 6);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (103, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sibalom', 6);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (104, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tibiao', 6);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (105, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tobias Fornier', 6);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (106, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Valderrama', 6);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (107, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Calanasan', 7);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (108, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Conner', 7);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (109, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Flora', 7);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (110, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Kabugao', 7);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (111, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Luna', 7);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (112, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pudtol', 7);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (113, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Santa Marcela', 7);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (114, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Baler', 8);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (115, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Casiguran', 8);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (116, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Dilasag', 8);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (117, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Dinalungan', 8);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (118, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Dingalan', 8);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (119, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Dipaculao', 8);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (120, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Maria Aurora', 8);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (121, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Luis', 8);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (122, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Isabela City', 9);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (123, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Lamitan City', 9);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (124, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Akbar', 9);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (125, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Al-Barka', 9);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (126, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Hadji Mohammad Ajul', 9);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (127, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Hadji Muhtamad', 9);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (128, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Lantawan', 9);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (129, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Maluso', 9);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (130, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sumisip', 9);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (131, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tabuan-Lasa', 9);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (132, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tipo-Tipo', 9);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (133, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tuburan', 9);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (134, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Ungkaya Pukan', 9);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (135, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Balanga City', 10);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (136, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Abucay', 10);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (137, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bagac', 10);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (138, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Dinalupihan', 10);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (139, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Hermosa', 10);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (140, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Limay', 10);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (141, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Mariveles', 10);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (142, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Morong', 10);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (143, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Orani', 10);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (144, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Orion', 10);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (145, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pilar', 10);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (146, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Samal', 10);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (147, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Basco', 11);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (148, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Itbayat', 11);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (149, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Ivana', 11);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (150, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Mahatao', 11);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (151, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sabtang', 11);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (152, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Uyugan', 11);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (153, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Batangas City', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (154, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Lipa City', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (155, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tanauan City', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (156, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Agoncillo', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (157, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Alitagtag', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (158, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Balayan', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (159, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Balete', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (160, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bauan', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (161, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Calaca', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (162, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Calatagan', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (163, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Cuenca', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (164, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Ibaan', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (165, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Laurel', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (166, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Lemery', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (167, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Lian', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (168, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Lobo', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (169, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Mabini', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (170, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Malvar', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (171, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Mataas na Kahoy', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (172, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Nasugbu', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (173, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Padre Garcia', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (174, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Rosario', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (175, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Jose', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (176, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Juan', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (177, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Luis', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (178, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Nicolas', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (179, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Pascual', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (180, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Santa Teresita', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (181, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Santo Tomas', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (182, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Taal', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (183, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Talisay', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (184, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Taysan', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (185, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tingloy', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (186, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tuy', 12);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (187, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Baguio City', 13);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (188, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Atok', 13);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (189, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bakun', 13);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (190, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bokod', 13);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (191, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Buguias', 13);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (192, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Itogon', 13);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (193, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Kabayan', 13);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (194, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Kapangan', 13);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (195, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Kibungan', 13);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (196, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'La Trinidad', 13);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (197, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Mankayan', 13);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (198, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sablan', 13);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (199, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tuba', 13);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (200, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tublay', 13);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (201, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Almeria', 14);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (202, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Biliran', 14);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (203, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Cabucgayan', 14);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (204, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Caibiran', 14);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (205, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Culaba', 14);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (206, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Kawayan', 14);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (207, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Maripipi', 14);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (208, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Naval', 14);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (209, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tagbilaran City', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (210, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Alburquerque', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (211, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Alicia', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (212, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Anda', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (213, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Antequera', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (214, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Baclayon', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (215, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Balilihan', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (216, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Batuan', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (217, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bien Unido', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (218, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bilar', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (219, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Buenavista', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (220, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Calape', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (221, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Candijay', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (222, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Carmen', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (223, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Catigbian', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (224, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Clarin', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (225, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Corella', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (226, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Cortes', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (227, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Dagohoy', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (228, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Danao', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (229, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Dauis', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (230, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Dimiao', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (231, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Duero', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (232, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Garcia Hernandez', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (233, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Guindulman', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (234, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Inabanga', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (235, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Jagna', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (236, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Jetafe', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (237, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Lila', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (238, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Loay', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (239, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Loboc', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (240, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Loon', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (241, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Mabini', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (242, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Maribojoc', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (243, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Panglao', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (244, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pilar', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (245, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pres. Carlos P. Garcia', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (246, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sagbayan', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (247, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Isidro', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (248, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Miguel', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (249, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sevilla', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (250, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sierra Bullones', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (251, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sikatuna', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (252, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Talibon', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (253, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Trinidad', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (254, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tubigon', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (255, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Ubay', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (256, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Valencia', 15);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (257, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Malaybalay City', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (258, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Valencia City', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (259, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Baungon', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (260, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Cabanglasan', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (261, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Damulog', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (262, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Dangcagan', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (263, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Don Carlos', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (264, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Impasug-Ong', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (265, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Kadingilan', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (266, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Kalilangan', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (267, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Kibawe', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (268, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Kitaotao', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (269, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Lantapan', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (270, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Libona', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (271, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Malitbog', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (272, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Manolo Fortich', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (273, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Maramag', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (274, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pangantucan', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (275, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Quezon', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (276, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Fernando', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (277, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sumilao', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (278, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Talakag', 16);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (279, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Malolos City', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (280, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Meycauayan City', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (281, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Jose del Monte City', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (282, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Angat', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (283, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Balagtas', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (284, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Baliuag', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (285, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bocaue', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (286, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bulacan', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (287, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bustos', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (288, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Calumpit', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (289, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Doña Remedios Trinidad', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (290, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Guiguinto', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (291, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Hagonoy', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (292, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Marilao', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (293, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Norzagaray', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (294, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Obando', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (295, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pandi', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (296, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Paombong', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (297, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Plaridel', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (298, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pulilan', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (299, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Ildefonso', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (300, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Miguel', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (301, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Rafael', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (302, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Santa Maria', 17);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (303, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tuguegarao City', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (304, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Abulug', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (305, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Alcala', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (306, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Allacapan', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (307, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Amulung', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (308, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Aparri', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (309, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Baggao', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (310, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Ballesteros', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (311, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Buguey', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (312, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Calayan', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (313, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Camalaniugan', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (314, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Claveria', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (315, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Enrile', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (316, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Gattaran', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (317, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Gonzaga', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (318, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Iguig', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (319, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Lal-Lo', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (320, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Lasam', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (321, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pamplona', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (322, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Peñablanca', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (323, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Piat', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (324, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Rizal', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (325, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sanchez-Mira', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (326, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Santa Ana', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (327, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Santa Praxedes', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (328, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Santa Teresita', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (329, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Santo Niño', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (330, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Solana', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (331, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tuao', 18);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (332, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Basud', 19);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (333, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Capalonga', 19);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (334, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Daet', 19);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (335, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Jose Panganiban', 19);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (336, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Labo', 19);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (337, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Mercedes', 19);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (338, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Paracale', 19);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (339, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Lorenzo Ruiz', 19);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (340, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Vicente', 19);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (341, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Santa Elena', 19);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (342, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Talisay', 19);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (343, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Vinzons', 19);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (344, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Iriga City', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (345, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Naga City', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (346, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Baao', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (347, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Balatan', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (348, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bato', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (349, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bombon', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (350, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Buhi', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (351, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bula', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (352, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Cabusao', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (353, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Calabanga', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (354, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Camaligan', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (355, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Canaman', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (356, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Caramoan', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (357, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Del Gallego', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (358, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Gainza', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (359, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Garchitorena', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (360, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Goa', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (361, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Lagonoy', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (362, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Libmanan', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (363, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Lupi', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (364, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Magarao', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (365, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Milaor', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (366, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Minalabac', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (367, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Nabua', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (368, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Ocampo', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (369, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pamplona', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (370, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pasacao', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (371, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pili', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (372, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Presentacion', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (373, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Ragay', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (374, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sagñay', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (375, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Fernando', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (376, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Jose', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (377, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sipocot', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (378, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Siruma', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (379, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tigaon', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (380, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tinambac', 20);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (381, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Catarman', 21);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (382, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Guinsiliban', 21);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (383, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Mahinog', 21);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (384, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Mambajao', 21);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (385, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sagay', 21);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (386, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Roxas City', 22);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (387, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Cuartero', 22);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (388, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Dao', 22);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (389, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Dumalag', 22);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (390, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Dumarao', 22);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (391, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Ivisan', 22);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (392, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Jamindan', 22);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (393, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Ma-ayon', 22);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (394, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Mambusao', 22);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (395, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Panay', 22);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (396, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Panitan', 22);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (397, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pilar', 22);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (398, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pontevedra', 22);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (399, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'President Roxas', 22);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (400, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sapi-an', 22);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (401, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sigma', 22);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (402, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tapaz', 22);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (403, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bagamanoc', 23);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (404, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Baras', 23);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (405, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bato', 23);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (406, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Caramoran', 23);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (407, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Gigmoto', 23);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (408, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pandan', 23);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (409, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Panganiban', 23);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (410, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Andres', 23);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (411, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Miguel', 23);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (412, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Viga', 23);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (413, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Virac', 23);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (414, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Cavite City', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (415, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Dasmariñas City', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (416, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tagaytay City', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (417, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Trece Martires City', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (418, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Alfonso', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (419, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Amadeo', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (420, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bacoor', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (421, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Carmona', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (422, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Gen. Mariano Alvarez', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (423, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Gen. Emilio Aguinaldo', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (424, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Gen. Trias', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (425, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Imus', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (426, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Indang', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (427, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Kawit', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (428, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Magallanes', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (429, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Maragondon', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (430, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Mendez', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (431, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Naic', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (432, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Noveleta', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (433, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Rosario', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (434, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Silang', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (435, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tanza', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (436, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Ternate', 24);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (437, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bogo City', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (438, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Carcar City', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (439, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Cebu City', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (440, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Danao City', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (441, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Lapu-Lapu City', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (442, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Mandaue City', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (443, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Naga City', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (444, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Talisay City', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (445, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Toledo City', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (446, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Alcantara', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (447, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Alcoy', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (448, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Alegria', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (449, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Aloguinsan', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (450, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Argao', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (451, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Asturias', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (452, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Badian', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (453, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Balamban', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (454, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bantayan', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (455, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Barili', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (456, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Boljoon', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (457, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Borbon', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (458, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Carmen', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (459, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Catmon', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (460, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Compostela', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (461, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Consolacion', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (462, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Cordoba', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (463, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Daanbantayan', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (464, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Dalaguete', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (465, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Dumanjug', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (466, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Ginatilan', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (467, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Liloan', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (468, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Madridejos', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (469, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Malabuyoc', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (470, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Medellin', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (471, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Minglanilla', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (472, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Moalboal', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (473, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Oslob', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (474, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pilar', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (475, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Pinamungahan', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (476, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Poro', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (477, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Ronda', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (478, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Samboan', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (479, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Fernando', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (480, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Francisco', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (481, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'San Remigio', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (482, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Santa Fe', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (483, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Santander', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (484, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sibonga', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (485, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Sogod', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (486, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tabogon', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (487, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tabuelan', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (488, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tuburan', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (489, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Tudela', 25);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (490, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Compostela', 26);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (491, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Laak', 26);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (492, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mabini', 26);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (493, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Maco', 26);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (494, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Maragusan', 26);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (495, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mawab', 26);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (496, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Monkayo', 26);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (497, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Montevista', 26);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (498, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Nabunturan', 26);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (499, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'New Bataan', 26);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (500, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pantukan', 26);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (501, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kidapawan City', 27);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (502, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Alamada', 27);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (503, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Aleosan', 27);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (504, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Antipas', 27);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (505, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Arakan', 27);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (506, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Banisilan', 27);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (507, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Carmen', 27);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (508, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kabacan', 27);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (509, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Libungan', 27);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (510, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'M\'Lang', 27);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (511, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Magpet', 27);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (512, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Makilala', 27);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (513, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Matalam', 27);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (514, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Midsayap', 27);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (515, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pigkawayan', 27);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (516, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pikit', 27);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (517, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'President Roxas', 27);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (518, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tulunan', 27);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (519, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Panabo City', 28);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (520, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Island Garden City of Samal', 28);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (521, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tagum City', 28);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (522, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Asuncion', 28);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (523, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Braulio E. Dujali', 28);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (524, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Carmen', 28);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (525, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kapalong', 28);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (526, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'New Corella', 28);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (527, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Isidro', 28);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (528, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santo Tomas', 28);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (529, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Talaingod', 28);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (530, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Davao City', 29);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (531, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Digos City', 29);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (532, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bansalan', 29);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (533, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Don Marcelino', 29);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (534, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Hagonoy', 29);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (535, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Jose Abad Santos', 29);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (536, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kiblawan', 29);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (537, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Magsaysay', 29);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (538, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Malalag', 29);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (539, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Malita', 29);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (540, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Matanao', 29);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (541, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Padada', 29);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (542, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Cruz', 29);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (543, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Maria', 29);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (544, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sarangani', 29);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (545, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sulop', 29);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (546, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mati City', 30);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (547, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Baganga', 30);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (548, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Banaybanay', 30);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (549, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Boston', 30);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (550, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Caraga', 30);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (551, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cateel', 30);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (552, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Governor Generoso', 30);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (553, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lupon', 30);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (554, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Manay', 30);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (555, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Isidro', 30);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (556, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tarragona', 30);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (557, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Basilisia [Rizal]', 31);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (558, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cagdianao', 31);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (559, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dinagat', 31);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (560, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Libjo [Albor]', 31);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (561, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Loreto', 31);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (562, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Jose', 31);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (563, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Borongan City', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (564, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Arteche', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (565, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Balangiga', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (566, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Balangkayan', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (567, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Can-avid', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (568, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dolores', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (569, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'General MacArthur', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (570, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Giporlos', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (571, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Guiuan', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (572, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Hernani', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (573, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Jipapad', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (574, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lawaan', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (575, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Llorente', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (576, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Maslog', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (577, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Maydolong', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (578, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mercedes', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (579, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Oras', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (580, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Quinapondan', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (581, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Salcedo', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (582, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Julian', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (583, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Policarpo', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (584, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sulat', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (585, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Taft', 32);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (586, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Buenavista', 33);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (587, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Jordan', 33);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (588, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Nueva Valencia', 33);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (589, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Lorenzo', 33);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (590, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sibunag', 33);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (591, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Aguinaldo', 34);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (592, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Alfonso Lista', 34);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (593, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Asipulo', 34);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (594, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Banaue', 34);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (595, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Hingyon', 34);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (596, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Hungduan', 34);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (597, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kiangan', 34);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (598, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lagawe', 34);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (599, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lamut', 34);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (600, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mayoyao', 34);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (601, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tinoc', 34);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (602, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Batac City', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (603, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Laoag City', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (604, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Adams', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (605, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bacarra', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (606, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Badoc', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (607, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bangui', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (608, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Banna', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (609, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Burgos', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (610, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Carasi', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (611, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Currimao', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (612, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dingras', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (613, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dumalneg', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (614, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Marcos', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (615, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Nueva Era', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (616, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pagudpud', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (617, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Paoay', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (618, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pasuquin', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (619, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Piddig', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (620, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pinili', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (621, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Nicolas', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (622, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sarrat', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (623, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Solsona', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (624, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Vintar', 35);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (625, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Candon City', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (626, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Vigan City', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (627, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Alilem', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (628, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Banayoyo', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (629, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bantay', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (630, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Burgos', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (631, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cabugao', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (632, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Caoayan', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (633, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cervantes', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (634, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Galimuyod', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (635, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Gregorio Del Pilar', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (636, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lidlidda', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (637, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Magsingal', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (638, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Nagbukel', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (639, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Narvacan', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (640, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Quirino', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (641, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Salcedo', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (642, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Emilio', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (643, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Esteban', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (644, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Ildefonso', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (645, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Juan', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (646, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Vicente', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (647, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (648, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Catalina', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (649, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Cruz', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (650, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Lucia', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (651, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Maria', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (652, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santiago', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (653, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santo Domingo', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (654, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sigay', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (655, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sinait', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (656, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sugpon', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (657, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Suyo', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (658, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tagudin', 36);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (659, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cauayan City', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (660, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santiago City', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (661, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Alicia', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (662, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Angadanan', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (663, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Aurora', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (664, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Benito Soliven', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (665, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Burgos', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (666, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cabagan', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (667, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cabatuan', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (668, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cordon', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (669, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Delfin Albano', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (670, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dinapigue', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (671, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Divilacan', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (672, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Echague', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (673, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Gamu', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (674, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Ilagan', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (675, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Jones', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (676, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Luna', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (677, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Maconacon', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (678, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mallig', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (679, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Naguilian', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (680, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Palanan', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (681, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Quezon', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (682, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Quirino', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (683, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Ramon', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (684, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Reina Mercedes', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (685, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Roxas', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (686, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Agustin', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (687, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Guillermo', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (688, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Isidro', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (689, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Manuel', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (690, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Mariano', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (691, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Mateo', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (692, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Pablo', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (693, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Maria', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (694, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santo Tomas', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (695, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tumauini', 37);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (696, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Iloilo City', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (697, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Passi City', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (698, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Ajuy', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (699, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Alimodian', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (700, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Anilao', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (701, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Badiangan', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (702, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Balasan', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (703, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Banate', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (704, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Barotac Nuevo', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (705, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Barotac Viejo', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (706, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Batad', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (707, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bingawan', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (708, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cabatuan', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (709, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Calinog', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (710, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Carles', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (711, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Concepcion', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (712, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dingle', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (713, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dueñas', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (714, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dumangas', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (715, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Estancia', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (716, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Guimbal', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (717, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Igbaras', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (718, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Janiuay', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (719, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lambunao', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (720, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Leganes', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (721, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lemery', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (722, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Leon', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (723, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Maasin', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (724, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Miagao', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (725, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mina', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (726, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'New Lucena', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (727, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Oton', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (728, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pavia', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (729, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pototan', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (730, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Dionisio', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (731, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Enrique', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (732, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Joaquin', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (733, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Miguel', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (734, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Rafael', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (735, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Barbara', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (736, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sara', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (737, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tigbauan', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (738, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tubungan', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (739, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Zarraga', 38);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (740, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tabuk City', 39);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (741, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Balbalan', 39);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (742, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lubuagan', 39);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (743, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pasil', 39);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (744, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pinukpuk', 39);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (745, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Rizal', 39);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (746, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tanudan', 39);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (747, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tinglayan', 39);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (748, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Fernando City', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (749, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Agoo', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (750, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Aringay', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (751, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bacnotan', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (752, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bagulin', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (753, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Balaoan', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (754, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bangar', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (755, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bauang', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (756, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Burgos', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (757, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Caba', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (758, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Luna', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (759, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Naguilian', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (760, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pugo', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (761, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Rosario', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (762, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Gabriel', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (763, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Juan', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (764, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santo Tomas', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (765, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santol', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (766, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sudipen', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (767, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tubao', 40);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (768, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Calamba City', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (769, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Pablo City', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (770, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Rosa City', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (771, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Alaminos', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (772, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bay', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (773, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Biñan', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (774, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cabuyao', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (775, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Calauan', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (776, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cavinti', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (777, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Famy', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (778, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kalayaan', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (779, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Liliw', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (780, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Los Baños', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (781, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Luisiana', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (782, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lumban', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (783, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mabitac', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (784, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Magdalena', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (785, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Majayjay', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (786, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Nagcarlan', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (787, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Paete', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (788, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pagsanjan', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (789, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pakil', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (790, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pangil', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (791, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pila', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (792, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Rizal', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (793, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Pedro', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (794, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Cruz', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (795, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Maria', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (796, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Siniloan', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (797, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Victoria', 41);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (798, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Iligan City', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (799, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bacolod', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (800, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Baloi', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (801, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Baroy', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (802, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kapatagan', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (803, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kauswagan', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (804, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kolambugan', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (805, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lala', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (806, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Linamon', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (807, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Magsaysay', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (808, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Maigo', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (809, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Matungao', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (810, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Munai', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (811, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Nunungan', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (812, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pantao Ragat', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (813, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pantar', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (814, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Poona Piagapo', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (815, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Salvador', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (816, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sapad', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (817, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sultan Naga Dimaporo', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (818, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tagoloan', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (819, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tangcal', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (820, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tubod', 42);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (821, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Marawi City', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (822, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bacolod-Kalawi', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (823, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Balabagan', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (824, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Balindong', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (825, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bayang', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (826, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Binidayan', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (827, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Buadiposo-Buntong', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (828, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bubong', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (829, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bumbaran', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (830, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Butig', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (831, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Calanogas', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (832, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Ditsaan-Ramain', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (833, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Ganassi', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (834, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kapai', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (835, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kapatagan', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (836, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lumba-Bayabao', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (837, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lumbaca-Unayan', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (838, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lumbatan', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (839, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lumbayanague', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (840, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Madalum', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (841, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Madamba', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (842, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Maguing', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (843, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Malabang', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (844, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Marantao', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (845, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Marogong', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (846, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Masiu', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (847, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mulondo', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (848, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pagayawan', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (849, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Piagapo', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (850, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Poona Bayabao', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (851, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pualas', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (852, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Saguiaran', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (853, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sultan Dumalondong', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (854, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Picong', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (855, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tagoloan II', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (856, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tamparan', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (857, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Taraka', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (858, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tubaran', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (859, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tugaya', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (860, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Wao', 43);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (861, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Baybay City', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (862, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Ormoc City', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (863, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tacloban City', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (864, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Abuyog', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (865, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Alangalang', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (866, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Albuera', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (867, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Babatngon', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (868, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Barugo', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (869, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bato', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (870, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Burauen', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (871, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Calubian', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (872, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Capoocan', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (873, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Carigara', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (874, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dagami', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (875, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dulag', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (876, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Hilongos', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (877, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Hindang', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (878, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Inopacan', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (879, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Isabel', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (880, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Jaro', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (881, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Javier', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (882, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Julita', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (883, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kananga', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (884, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'La Paz', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (885, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Leyte', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (886, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Macarthur', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (887, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mahaplag', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (888, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Matag-ob', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (889, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Matalom', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (890, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mayorga', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (891, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Merida', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (892, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Palo', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (893, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Palompon', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (894, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pastrana', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (895, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Isidro', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (896, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Miguel', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (897, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Fe', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (898, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tabango', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (899, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tabontabon', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (900, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tanauan', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (901, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tolosa', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (902, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tunga', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (903, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Villaba', 44);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (904, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cotabato City', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (905, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Ampatuan', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (906, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Barira', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (907, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Buldon', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (908, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Buluan', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (909, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Datu Abdullah Sangki', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (910, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Datu Anggal Midtimbang', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (911, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Datu Blah T. Sinsuat', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (912, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Datu Hoffer Ampatuan', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (913, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Datu Montawal', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (914, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Datu Odin Sinsuat', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (915, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Datu Paglas', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (916, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Datu Piang', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (917, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Datu Salibo', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (918, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Datu Saudi-Ampatuan', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (919, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Datu Unsay', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (920, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Gen. S. K. Pendatun', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (921, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Guindulungan', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (922, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kabuntalan', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (923, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mamasapano', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (924, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mangudadatu', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (925, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Matanog', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (926, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Northern Kabuntalan', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (927, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pagalungan', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (928, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Paglat', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (929, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pandag', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (930, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Parang', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (931, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Rajah Buayan', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (932, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Shariff Aguak', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (933, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Shariff Saydona Mustapha', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (934, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'South Upi', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (935, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sultan Kudarat', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (936, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sultan Mastura', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (937, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sultan sa Barongis', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (938, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Talayan', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (939, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Talitay', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (940, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Upi', 45);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (941, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Boac', 46);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (942, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Buenavista', 46);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (943, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Gasan', 46);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (944, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mogpog', 46);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (945, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Cruz', 46);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (946, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Torrijos', 46);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (947, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Masbate City', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (948, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Aroroy', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (949, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Baleno', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (950, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Balud', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (951, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Batuan', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (952, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cataingan', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (953, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cawayan', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (954, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Claveria', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (955, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dimasalang', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (956, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Esperanza', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (957, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mandaon', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (958, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Milagros', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (959, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mobo', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (960, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Monreal', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (961, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Palanas', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (962, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pio V. Corpuz', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (963, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Placer', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (964, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Fernando', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (965, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Jacinto', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (966, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Pascual', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (967, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Uson', 47);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (968, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Caloocan City', 48);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (969, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Las Piñas City', 48);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (970, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Makati City', 48);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (971, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Malabon City', 48);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (972, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mandaluyong City', 48);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (973, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Manila City', 48);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (974, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Marikina City', 48);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (975, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Muntinlupa City', 48);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (976, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Navotas City', 48);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (977, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Parañaque City', 48);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (978, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pasay City', 48);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (979, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pasig City', 48);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (980, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Quezon City', 48);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (981, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Juan City', 48);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (982, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Taguig City', 48);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (983, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Valenzuela City', 48);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (984, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pateros', 48);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (985, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Oroquieta City', 49);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (986, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Ozamiz City', 49);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (987, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tangub City', 49);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (988, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Aloran', 49);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (989, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Baliangao', 49);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (990, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bonifacio', 49);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (991, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Calamba', 49);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (992, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Clarin', 49);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (993, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Concepcion', 49);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (994, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Don Victoriano Chiongbian', 49);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (995, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Jimenez', 49);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (996, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lopez Jaena', 49);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (997, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Panaon', 49);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (998, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Plaridel', 49);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (999, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sapang Dalaga', 49);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1000, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sinacaban', 49);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1001, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tudela', 49);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1002, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cagayan de Oro', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1003, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Gingoog City', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1004, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'El Salvador City', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1005, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Alubijid', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1006, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Balingasag', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1007, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Balingoan', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1008, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Binuangan', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1009, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Claveria', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1010, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Gitagum', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1011, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Initao', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1012, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Jasaan', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1013, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kinoguitan', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1014, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lagonglong', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1015, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Laguindingan', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1016, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Libertad', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1017, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lugait', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1018, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Magsaysay', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1019, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Manticao', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1020, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Medina', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1021, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Naawan', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1022, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Opol', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1023, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Salay', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1024, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sugbongcogon', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1025, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tagoloan', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1026, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Talisayan', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1027, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Villanueva', 50);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1028, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Barlig', 51);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1029, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bauko', 51);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1030, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Besao', 51);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1031, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bontoc', 51);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1032, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Natonin', 51);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1033, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Paracelis', 51);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1034, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sabangan', 51);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1035, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sadanga', 51);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1036, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sagada', 51);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1037, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tadian', 51);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1038, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bacolod City', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1039, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bago City', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1040, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cadiz City', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1041, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Escalante City', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1042, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Himamaylan City', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1043, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kabankalan City', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1044, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'La Carlota City', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1045, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sagay City', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1046, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Carlos City', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1047, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Silay City', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1048, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sipalay City', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1049, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Talisay City', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1050, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Victorias City', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1051, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Binalbagan', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1052, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Calatrava', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1053, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Candoni', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1054, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cauayan', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1055, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Enrique B. Magalona', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1056, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Hinigaran', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1057, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Hinoba-an', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1058, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Ilog', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1059, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Isabela', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1060, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'La Castellana', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1061, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Manapla', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1062, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Moises Padilla', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1063, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Murcia', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1064, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pontevedra', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1065, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pulupandan', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1066, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Salvador Benedicto', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1067, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Enrique', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1068, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Toboso', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1069, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Valladolid', 52);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1070, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bais', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1071, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bayawan', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1072, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Canlaon', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1073, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dumaguete', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1074, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Guihulngan', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1075, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tanjay', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1076, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Amlan', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1077, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Ayungon', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1078, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bacong', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1079, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Basay', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1080, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bindoy', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1081, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dauin', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1082, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Jimalalud', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1083, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'La Libertad', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1084, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mabinay', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1085, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Manjuyod', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1086, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pamplona', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1087, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Jose', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1088, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Catalina', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1089, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Siaton', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1090, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sibulan', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1091, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tayasan', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1092, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Valencia', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1093, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Vallehermoso', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1094, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Zamboanguita', 53);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1095, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Allen', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1096, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Biri', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1097, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bobon', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1098, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Capul', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1099, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Catarman', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1100, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Catubig', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1101, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Gamay', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1102, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Laoang', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1103, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lapinig', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1104, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Las Navas', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1105, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lavezares', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1106, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lope de Vega', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1107, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mapanas', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1108, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mondragon', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1109, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Palapag', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1110, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pambujan', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1111, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Rosario', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1112, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Antonio', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1113, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Isidro', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1114, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Jose', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1115, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Roque', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1116, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Vicente', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1117, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Silvino Lobos', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1118, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Victoria', 54);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1119, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cabanatuan City', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1120, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Gapan City', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1121, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Science City of Muñoz', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1122, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Palayan City', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1123, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Jose City', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1124, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Aliaga', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1125, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bongabon', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1126, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cabiao', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1127, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Carranglan', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1128, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cuyapo', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1129, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Gabaldon', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1130, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'General Mamerto Natividad', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1131, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'General Tinio', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1132, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Guimba', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1133, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Jaen', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1134, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Laur', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1135, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Licab', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1136, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Llanera', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1137, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lupao', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1138, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Nampicuan', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1139, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pantabangan', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1140, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Peñaranda', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1141, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Quezon', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1142, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Rizal', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1143, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Antonio', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1144, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Isidro', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1145, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Leonardo', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1146, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Rosa', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1147, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santo Domingo', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1148, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Talavera', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1149, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Talugtug', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1150, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Zaragoza', 55);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1151, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Alfonso Castaneda', 56);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1152, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Ambaguio', 56);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1153, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Aritao', 56);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1154, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bagabag', 56);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1155, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bambang', 56);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1156, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bayombong', 56);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1157, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Diadi', 56);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1158, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dupax del Norte', 56);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1159, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dupax del Sur', 56);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1160, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kasibu', 56);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1161, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kayapa', 56);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1162, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Quezon', 56);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1163, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Fe', 56);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1164, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Solano', 56);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1165, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Villaverde', 56);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1166, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Abra de Ilog', 57);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1167, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Calintaan', 57);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1168, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Looc', 57);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1169, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lubang', 57);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1170, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Magsaysay', 57);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1171, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mamburao', 57);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1172, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Paluan', 57);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1173, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Rizal', 57);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1174, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sablayan', 57);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1175, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Jose', 57);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1176, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Cruz', 57);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1177, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Calapan City', 58);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1178, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Baco', 58);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1179, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bansud', 58);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1180, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bongabong', 58);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1181, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bulalacao', 58);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1182, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Gloria', 58);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1183, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mansalay', 58);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1184, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Naujan', 58);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1185, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pinamalayan', 58);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1186, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pola', 58);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1187, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Puerto Galera', 58);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1188, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Roxas', 58);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1189, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Teodoro', 58);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1190, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Socorro', 58);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1191, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Victoria', 58);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1192, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Puerto Princesa City', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1193, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Aborlan', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1194, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Agutaya', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1195, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Araceli', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1196, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Balabac', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1197, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bataraza', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1198, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Brooke\'s Point', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1199, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Busuanga', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1200, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cagayancillo', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1201, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Coron', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1202, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Culion', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1203, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cuyo', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1204, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dumaran', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1205, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'El Nido', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1206, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kalayaan', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1207, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Linapacan', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1208, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Magsaysay', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1209, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Narra', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1210, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Quezon', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1211, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Rizal', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1212, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Roxas', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1213, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Vicente', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1214, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sofronio Española', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1215, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Taytay', 59);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1216, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Angeles City', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1217, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'City of San Fernando', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1218, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Apalit', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1219, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Arayat', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1220, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bacolor', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1221, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Candaba', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1222, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Floridablanca', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1223, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Guagua', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1224, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lubao', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1225, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mabalacat', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1226, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Macabebe', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1227, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Magalang', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1228, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Masantol', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1229, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mexico', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1230, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Minalin', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1231, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Porac', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1232, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Luis', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1233, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Simon', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1234, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Ana', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1235, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Rita', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1236, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santo Tomas', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1237, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sasmuan', 60);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1238, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Alaminos City', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1239, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dagupan City', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1240, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Carlos City', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1241, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Urdaneta City', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1242, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Agno', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1243, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Aguilar', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1244, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Alcala', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1245, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Anda', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1246, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Asingan', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1247, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Balungao', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1248, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bani', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1249, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Basista', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1250, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bautista', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1251, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bayambang', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1252, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Binalonan', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1253, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Binmaley', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1254, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bolinao', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1255, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bugallon', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1256, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Burgos', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1257, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Calasiao', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1258, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dasol', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1259, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Infanta', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1260, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Labrador', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1261, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Laoac', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1262, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lingayen', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1263, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mabini', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1264, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Malasiqui', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1265, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Manaoag', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1266, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mangaldan', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1267, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mangatarem', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1268, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mapandan', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1269, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Natividad', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1270, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pozzorubio', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1271, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Rosales', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1272, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Fabian', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1273, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Jacinto', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1274, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Manuel', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1275, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Nicolas', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1276, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Quintin', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1277, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Barbara', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1278, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Maria', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1279, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santo Tomas', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1280, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sison', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1281, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sual', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1282, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tayug', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1283, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Umingan', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1284, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Urbiztondo', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1285, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Villasis', 61);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1286, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lucena City', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1287, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tayabas City', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1288, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Agdangan', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1289, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Alabat', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1290, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Atimonan', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1291, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Buenavista', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1292, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Burdeos', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1293, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Calauag', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1294, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Candelaria', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1295, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Catanauan', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1296, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dolores', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1297, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'General Luna', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1298, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'General Nakar', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1299, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Guinayangan', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1300, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Gumaca', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1301, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Infanta', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1302, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Jomalig', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1303, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lopez', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1304, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lucban', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1305, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Macalelon', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1306, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mauban', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1307, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mulanay', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1308, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Padre Burgos', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1309, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pagbilao', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1310, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Panukulan', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1311, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Patnanungan', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1312, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Perez', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1313, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pitogo', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1314, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Plaridel', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1315, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Polillo', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1316, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Quezon', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1317, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Real', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1318, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sampaloc', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1319, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Andres', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1320, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Antonio', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1321, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Francisco', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1322, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Narciso', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1323, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sariaya', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1324, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tagkawayan', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1325, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tiaong', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1326, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Unisan', 62);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1327, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Aglipay', 63);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1328, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cabarroguis', 63);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1329, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Diffun', 63);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1330, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Maddela', 63);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1331, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Nagtipunan', 63);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1332, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Saguday', 63);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1333, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Antipolo City', 64);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1334, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Angono', 64);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1335, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Baras', 64);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1336, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Binangonan', 64);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1337, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cainta', 64);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1338, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cardona', 64);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1339, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Jalajala', 64);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1340, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Morong', 64);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1341, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pililla', 64);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1342, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Rodriguez', 64);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1343, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Mateo', 64);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1344, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tanay', 64);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1345, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Taytay', 64);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1346, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Teresa', 64);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1347, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Alcantara', 65);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1348, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Banton', 65);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1349, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cajidiocan', 65);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1350, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Calatrava', 65);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1351, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Concepcion', 65);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1352, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Corcuera', 65);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1353, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Ferrol', 65);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1354, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Looc', 65);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1355, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Magdiwang', 65);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1356, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Odiongan', 65);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1357, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Romblon', 65);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1358, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Agustin', 65);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1359, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Andres', 65);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1360, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Fernando', 65);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1361, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Jose', 65);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1362, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Fe', 65);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1363, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Maria', 65);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1364, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Calbayog City', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1365, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Catbalogan City', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1366, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Almagro', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1367, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Basey', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1368, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Calbiga', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1369, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Daram', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1370, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Gandara', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1371, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Hinabangan', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1372, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Jiabong', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1373, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Marabut', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1374, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Matuguinao', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1375, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Motiong', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1376, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pagsanghan', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1377, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Paranas', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1378, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pinabacdao', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1379, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Jorge', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1380, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Jose De Buan', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1381, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Sebastian', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1382, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Margarita', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1383, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Rita', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1384, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santo Niño', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1385, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tagapul-an', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1386, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Talalora', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1387, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tarangnan', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1388, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Villareal', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1389, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Zumarraga', 66);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1390, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Alabel', 67);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1391, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Glan', 67);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1392, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kiamba', 67);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1393, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Maasim', 67);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1394, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Maitum', 67);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1395, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Malapatan', 67);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1396, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Malungon', 67);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1397, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Enrique Villanueva', 68);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1398, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Larena', 68);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1399, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lazi', 68);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1400, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Maria', 68);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1401, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Juan', 68);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1402, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Siquijor', 68);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1403, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sorsogon City', 69);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1404, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Barcelona', 69);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1405, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bulan', 69);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1406, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bulusan', 69);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1407, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Casiguran', 69);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1408, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Castilla', 69);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1409, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Donsol', 69);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1410, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Gubat', 69);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1411, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Irosin', 69);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1412, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Juban', 69);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1413, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Magallanes', 69);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1414, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Matnog', 69);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1415, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pilar', 69);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1416, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Prieto Diaz', 69);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1417, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Magdalena', 69);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1418, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'General Santos City', 70);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1419, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Koronadal City', 70);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1420, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Banga', 70);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1421, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lake Sebu', 70);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1422, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Norala', 70);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1423, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Polomolok', 70);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1424, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santo Niño', 70);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1425, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Surallah', 70);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1426, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'T\'Boli', 70);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1427, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tampakan', 70);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1428, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tantangan', 70);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1429, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tupi', 70);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1430, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Maasin City', 71);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1431, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Anahawan', 71);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1432, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bontoc', 71);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1433, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Hinunangan', 71);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1434, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Hinundayan', 71);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1435, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Libagon', 71);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1436, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Liloan', 71);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1437, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Limasawa', 71);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1438, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Macrohon', 71);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1439, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Malitbog', 71);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1440, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Padre Burgos', 71);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1441, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pintuyan', 71);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1442, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Saint Bernard', 71);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1443, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Francisco', 71);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1444, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Juan', 71);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1445, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Ricardo', 71);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1446, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Silago', 71);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1447, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sogod', 71);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1448, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tomas Oppus', 71);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1449, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tacurong City', 72);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1450, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bagumbayan', 72);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1451, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Columbio', 72);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1452, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Esperanza', 72);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1453, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Isulan', 72);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1454, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kalamansig', 72);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1455, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lambayong', 72);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1456, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lebak', 72);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1457, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lutayan', 72);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1458, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Palimbang', 72);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1459, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'President Quirino', 72);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1460, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sen. Ninoy Aquino', 72);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1461, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Banguingui', 73);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1462, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Hadji Panglima Tahil', 73);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1463, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Indanan', 73);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1464, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Jolo', 73);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1465, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kalingalan Caluang', 73);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1466, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lugus', 73);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1467, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Luuk', 73);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1468, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Maimbung', 73);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1469, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Old Panamao', 73);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1470, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Omar', 73);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1471, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pandami', 73);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1472, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Panglima Estino', 73);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1473, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pangutaran', 73);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1474, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Parang', 73);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1475, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pata', 73);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1476, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Patikul', 73);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1477, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Siasi', 73);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1478, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Talipao', 73);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1479, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tapul', 73);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1480, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Surigao City', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1481, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Alegria', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1482, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bacuag', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1483, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Burgos', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1484, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Claver', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1485, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dapa', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1486, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Del Carmen', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1487, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'General Luna', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1488, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Gigaquit', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1489, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mainit', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1490, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Malimono', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1491, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pilar', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1492, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Placer', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1493, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Benito', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1494, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Francisco', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1495, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Isidro', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1496, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Monica', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1497, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sison', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1498, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Socorro', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1499, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tagana-an', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1500, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tubod', 74);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1501, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bislig City', 75);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1502, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tandag City', 75);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1503, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Barobo', 75);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1504, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bayabas', 75);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1505, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cagwait', 75);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1506, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cantilan', 75);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1507, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Carmen', 75);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1508, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Carrascal', 75);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1509, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cortes', 75);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1510, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Hinatuan', 75);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1511, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lanuza', 75);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1512, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lianga', 75);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1513, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lingig', 75);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1514, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Madrid', 75);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1515, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Marihatag', 75);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1516, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Agustin', 75);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1517, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Miguel', 75);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1518, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tagbina', 75);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1519, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tago', 75);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1520, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tarlac City', 76);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1521, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Anao', 76);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1522, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bamban', 76);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1523, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Camiling', 76);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1524, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Capas', 76);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1525, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Concepcion', 76);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1526, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Gerona', 76);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1527, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'La Paz', 76);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1528, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mayantoc', 76);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1529, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Moncada', 76);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1530, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Paniqui', 76);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1531, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pura', 76);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1532, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Ramos', 76);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1533, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Clemente', 76);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1534, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Jose', 76);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1535, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Manuel', 76);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1536, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Ignacia', 76);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1537, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Victoria', 76);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1538, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bongao', 77);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1539, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Languyan', 77);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1540, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mapun', 77);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1541, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Panglima Sugala', 77);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1542, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sapa-Sapa', 77);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1543, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sibutu', 77);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1544, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Simunul', 77);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1545, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sitangkai', 77);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1546, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'South Ubian', 77);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1547, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tandubas', 77);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1548, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Turtle Islands', 77);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1549, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Olongapo City', 78);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1550, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Botolan', 78);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1551, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cabangan', 78);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1552, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Candelaria', 78);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1553, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Castillejos', 78);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1554, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Iba', 78);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1555, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Masinloc', 78);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1556, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Palauig', 78);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1557, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Antonio', 78);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1558, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Felipe', 78);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1559, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Marcelino', 78);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1560, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Narciso', 78);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1561, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Santa Cruz', 78);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1562, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Subic', 78);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1563, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dapitan City', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1564, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dipolog City', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1565, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bacungan', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1566, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Baliguian', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1567, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Godod', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1568, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Gutalac', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1569, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Jose Dalman', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1570, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kalawit', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1571, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Katipunan', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1572, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'La Libertad', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1573, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Labason', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1574, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Liloy', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1575, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Manukan', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1576, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mutia', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1577, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Piñan', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1578, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Polanco', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1579, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pres. Manuel A. Roxas', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1580, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Rizal', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1581, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Salug', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1582, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sergio Osmeña Sr.', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1583, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Siayan', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1584, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sibuco', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1585, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sibutad', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1586, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sindangan', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1587, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Siocon', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1588, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sirawai', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1589, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tampilisan', 79);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1590, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pagadian City', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1591, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Zamboanga City', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1592, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Aurora', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1593, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Bayog', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1594, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dimataling', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1595, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dinas', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1596, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dumalinao', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1597, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dumingag', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1598, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Guipos', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1599, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Josefina', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1600, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kumalarang', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1601, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Labangan', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1602, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lakewood', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1603, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lapuyan', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1604, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mahayag', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1605, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Margosatubig', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1606, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Midsalip', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1607, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Molave', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1608, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pitogo', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1609, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Ramon Magsaysay', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1610, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Miguel', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1611, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'San Pablo', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1612, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sominot', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1613, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tabina', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1614, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tambulig', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1615, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tigbao', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1616, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tukuran', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1617, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Vincenzo A. Sagun', 80);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1618, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Alicia', 81);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1619, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Buug', 81);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1620, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Diplahan', 81);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1621, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Imelda', 81);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1622, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Ipil', 81);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1623, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kabasalan', 81);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1624, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mabuhay', 81);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1625, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Malangas', 81);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1626, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Naga', 81);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1627, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Olutanga', 81);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1628, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Payao', 81);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1629, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Roseller Lim', 81);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1630, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Siay', 81);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1631, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Talusan', 81);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1632, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Titay', 81);
INSERT INTO `city` (`city_id`, `city_date_created`, `city_last_modified`, `city_name`, `state_id`) VALUES (1633, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tungawan', 81);


INSERT INTO `country` (`country_id`, `country_date_created`, `country_last_modified`, `country_name`) VALUES (1, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Philippines');


INSERT INTO `district` (`district_id`, `district_date_created`, `district_last_modified`, `district_name`, `district_presbyter`) VALUES (1, '2011-07-20 13:45:32', '2011-07-21 23:36:21', 'Eastern Visayas District', 4);




INSERT INTO `pastor_profile` (`pastor_profile_id`, `pastor_profile_date_created`, `pastor_profile_last_modified`, `pastor_profile_country`, `pastor_profile_website`, `pastor_profile_license`, `pastor_profile_title`, `user_id`, `church_id`) VALUES (2, '2011-07-21 09:48:39', '2011-07-21 23:44:15', NULL, NULL, 'ordained', 'reverend', 2, 1);
INSERT INTO `pastor_profile` (`pastor_profile_id`, `pastor_profile_date_created`, `pastor_profile_last_modified`, `pastor_profile_country`, `pastor_profile_website`, `pastor_profile_license`, `pastor_profile_title`, `user_id`, `church_id`) VALUES (3, '2011-07-21 09:48:57', '2011-07-21 23:51:08', NULL, NULL, 'ordained', 'pastor', 3, 1);
INSERT INTO `pastor_profile` (`pastor_profile_id`, `pastor_profile_date_created`, `pastor_profile_last_modified`, `pastor_profile_country`, `pastor_profile_website`, `pastor_profile_license`, `pastor_profile_title`, `user_id`, `church_id`) VALUES (4, '2011-07-21 09:49:16', '2011-07-21 23:42:46', NULL, NULL, 'ordained', 'reverend', 4, NULL);
INSERT INTO `pastor_profile` (`pastor_profile_id`, `pastor_profile_date_created`, `pastor_profile_last_modified`, `pastor_profile_country`, `pastor_profile_website`, `pastor_profile_license`, `pastor_profile_title`, `user_id`, `church_id`) VALUES (5, '2011-07-21 09:52:17', '2011-07-21 23:42:46', NULL, NULL, 'ordained', 'reverend', 5, NULL);
INSERT INTO `pastor_profile` (`pastor_profile_id`, `pastor_profile_date_created`, `pastor_profile_last_modified`, `pastor_profile_country`, `pastor_profile_website`, `pastor_profile_license`, `pastor_profile_title`, `user_id`, `church_id`) VALUES (6, '2011-07-21 09:52:28', '2011-07-21 23:42:48', NULL, NULL, 'ordained', 'reverend', 6, NULL);
INSERT INTO `pastor_profile` (`pastor_profile_id`, `pastor_profile_date_created`, `pastor_profile_last_modified`, `pastor_profile_country`, `pastor_profile_website`, `pastor_profile_license`, `pastor_profile_title`, `user_id`, `church_id`) VALUES (7, '2011-07-21 09:52:36', '2011-07-21 23:42:49', NULL, NULL, 'ordained', 'reverend', 7, NULL);


INSERT INTO `section` (`section_id`, `section_date_created`, `section_last_modified`, `section_name`, `section_presbyter`, `district_id`) VALUES (1, '2011-07-20 13:45:32', '2011-07-20 13:45:32', 'Cebu', 2, 1);
INSERT INTO `section` (`section_id`, `section_date_created`, `section_last_modified`, `section_name`, `section_presbyter`, `district_id`) VALUES (2, '2011-07-20 13:45:32', '2011-07-20 13:45:32', 'Leyte', 3, 1);
INSERT INTO `section` (`section_id`, `section_date_created`, `section_last_modified`, `section_name`, `section_presbyter`, `district_id`) VALUES (3, '2011-07-20 13:45:32', '2011-07-20 13:45:32', 'Bohol', 4, 1);


INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (1, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Abra', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (2, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Agusan del Norte', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (3, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Agusan del Sur', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (4, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Aklan', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (5, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Albay', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (6, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Antique', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (7, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Apayao', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (8, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Aurora', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (9, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Basilan', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (10, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bataan', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (11, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Batanes', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (12, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Batangas', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (13, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Benguet', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (14, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Biliran', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (15, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bohol', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (16, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bukidnon', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (17, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Bulacan', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (18, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Cagayan', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (19, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Camarines Norte', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (20, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Camarines Sur', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (21, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Camiguin', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (22, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Capiz', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (23, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Catanduanes', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (24, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Cavite', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (25, '2011-07-20 21:32:05', '2011-07-20 21:32:05', 'Cebu', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (26, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Compostela Valley', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (27, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Cotabato', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (28, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Davao del Norte', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (29, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Davao del Sur', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (30, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Davao Oriental', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (31, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Dinagat Islands', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (32, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Eastern Samar', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (33, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Guimaras', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (34, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Ifugao', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (35, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Ilocos Norte', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (36, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Ilocos Sur', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (37, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Isabela', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (38, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Iloilo', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (39, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Kalinga', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (40, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'La Union', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (41, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Laguna', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (42, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lanao del Norte', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (43, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Lanao del Sur', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (44, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Leyte', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (45, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Maguindanao', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (46, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Marinduque', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (47, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Masbate', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (48, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Metro Manila', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (49, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Misamis Occidental', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (50, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Misamis Oriental', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (51, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Mountain Province', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (52, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Negros Occidental', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (53, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Negros Oriental', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (54, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Northern Samar', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (55, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Nueva Ecija', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (56, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Nueva Vizcaya', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (57, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Occidental Mindoro', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (58, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Oriental Mindoro', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (59, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Palawan', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (60, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pampanga', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (61, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Pangasinan', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (62, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Quezon', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (63, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Quirino', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (64, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Rizal', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (65, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Romblon', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (66, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Samar', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (67, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sarangani', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (68, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Siquijor', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (69, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sorsogon', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (70, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'South Cotabato', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (71, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Southern Leyte', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (72, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sultan Kudarat', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (73, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Sulu', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (74, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Surigao del Norte', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (75, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Surigao del Sur', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (76, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tarlac', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (77, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Tawi-Tawi', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (78, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Zambales', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (79, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Zamboanga del Norte', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (80, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Zamboanga del Sur', 1);
INSERT INTO `state` (`state_id`, `state_date_created`, `state_last_modified`, `state_name`, `country_id`) VALUES (81, '2011-07-20 21:32:06', '2011-07-20 21:32:06', 'Zamboanga Sibugay', 1);


INSERT INTO `tag` (`tag_id`, `tag_date_created`, `tag_last_modified`, `tag_name`) VALUES (1, '2011-07-20 13:45:32', '2011-07-20 13:45:32', 'jquery');
INSERT INTO `tag` (`tag_id`, `tag_date_created`, `tag_last_modified`, `tag_name`) VALUES (2, '2011-07-20 13:45:32', '2011-07-20 13:45:32', 'web');
INSERT INTO `tag` (`tag_id`, `tag_date_created`, `tag_last_modified`, `tag_name`) VALUES (3, '2011-07-20 13:45:32', '2011-07-20 13:45:32', 'news');


INSERT INTO `user` (`user_id`, `user_date_created`, `user_last_modified`, `user_last_login`, `user_login`, `user_password`, `user_email`, `user_activated`, `user_banned`, `user_ban_reason`, `user_new_password_key`, `user_new_password_requested`, `user_new_email`, `user_new_email_key`, `user_last_ip`, `user_firstname`, `user_middlename`, `user_lastname`) VALUES (1, '2011-07-20 13:45:32', '2011-07-21 22:23:43', '2011-07-20 13:45:32', 'admin', '$P$BKZKeZ5nAXz/cX6MU9Nam0MdvgHPYQ.', 'contact@b3rx.co.cc', 1, 0, NULL, NULL, NULL, NULL, NULL, '121.54.11.228', 'NaCl.org', '', 'Admin');
INSERT INTO `user` (`user_id`, `user_date_created`, `user_last_modified`, `user_last_login`, `user_login`, `user_password`, `user_email`, `user_activated`, `user_banned`, `user_ban_reason`, `user_new_password_key`, `user_new_password_requested`, `user_new_email`, `user_new_email_key`, `user_last_ip`, `user_firstname`, `user_middlename`, `user_lastname`) VALUES (2, '2011-07-21 09:44:58', '2011-07-21 22:23:56', '2011-07-21 09:44:58', 'cmangoba', '$P$BF7AGbylNy8My0A3eNCF908cEEszoR0', 'contact+cmangoba@b3rx.co.cc', 1, 0, NULL, NULL, NULL, NULL, NULL, '121.54.11.228', 'Cornelio', '', 'Mangoba');
INSERT INTO `user` (`user_id`, `user_date_created`, `user_last_modified`, `user_last_login`, `user_login`, `user_password`, `user_email`, `user_activated`, `user_banned`, `user_ban_reason`, `user_new_password_key`, `user_new_password_requested`, `user_new_email`, `user_new_email_key`, `user_last_ip`, `user_firstname`, `user_middlename`, `user_lastname`) VALUES (3, '2011-07-21 09:46:05', '2011-07-21 22:24:05', '2011-07-21 09:46:05', 'tcrieta', '$P$BGB79mGbsOaUVS8MX0rcjyV1R798ok1', 'contact+tcrieta@b3rx.co.cc', 1, 0, NULL, NULL, NULL, NULL, NULL, '121.54.11.228', 'Tito', '', 'Crieta');
INSERT INTO `user` (`user_id`, `user_date_created`, `user_last_modified`, `user_last_login`, `user_login`, `user_password`, `user_email`, `user_activated`, `user_banned`, `user_ban_reason`, `user_new_password_key`, `user_new_password_requested`, `user_new_email`, `user_new_email_key`, `user_last_ip`, `user_firstname`, `user_middlename`, `user_lastname`) VALUES (4, '2011-07-21 09:46:45', '2011-07-21 22:24:13', '2011-07-21 09:46:45', 'aperez', '$P$B9C5tOMDTn27pfFXpPP1c7vAfdHZNR/', 'contact+aperez@b3rx.co.cc', 1, 0, NULL, NULL, NULL, NULL, NULL, '121.54.11.228', 'Amado', '', 'Perez');
INSERT INTO `user` (`user_id`, `user_date_created`, `user_last_modified`, `user_last_login`, `user_login`, `user_password`, `user_email`, `user_activated`, `user_banned`, `user_ban_reason`, `user_new_password_key`, `user_new_password_requested`, `user_new_email`, `user_new_email_key`, `user_last_ip`, `user_firstname`, `user_middlename`, `user_lastname`) VALUES (5, '2011-07-21 09:50:13', '2011-07-21 22:24:42', '2011-07-21 09:50:13', 'hpestano', '$P$B7S6p7EwfP6r6QlM2Xx1dWYL96l3rW0', 'contact+hpestano@b3rx.co.cc', 1, 0, NULL, NULL, NULL, NULL, NULL, '121.54.11.228', 'Henry', '', 'Pestaño');
INSERT INTO `user` (`user_id`, `user_date_created`, `user_last_modified`, `user_last_login`, `user_login`, `user_password`, `user_email`, `user_activated`, `user_banned`, `user_ban_reason`, `user_new_password_key`, `user_new_password_requested`, `user_new_email`, `user_new_email_key`, `user_last_ip`, `user_firstname`, `user_middlename`, `user_lastname`) VALUES (6, '2011-07-21 09:50:49', '2011-07-21 22:24:46', '2011-07-21 09:50:49', 'cpestano', '$P$BN2vGFn0NclDLaiHhyJq1plm7YnUH7/', 'contact+cpestano@b3rx.co.cc', 1, 0, NULL, NULL, NULL, NULL, NULL, '121.54.11.228', 'Ceasar', '', 'Pestaño');
INSERT INTO `user` (`user_id`, `user_date_created`, `user_last_modified`, `user_last_login`, `user_login`, `user_password`, `user_email`, `user_activated`, `user_banned`, `user_ban_reason`, `user_new_password_key`, `user_new_password_requested`, `user_new_email`, `user_new_email_key`, `user_last_ip`, `user_firstname`, `user_middlename`, `user_lastname`) VALUES (7, '2011-07-21 09:51:39', '2011-07-21 22:24:50', '2011-07-21 09:51:39', 'mpestano', '$P$BCLntKnCu0lm6JWy4v1x7NPmOJeM7E0', 'contact+mpestano@b3rx.co.cc', 1, 0, NULL, NULL, NULL, NULL, NULL, '121.54.11.228', 'Mario', '', 'Pestaño');




SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
