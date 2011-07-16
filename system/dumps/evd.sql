-- phpMyAdmin SQL Dump
-- version 3.2.5
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 16, 2011 at 04:17 PM
-- Server version: 5.1.44
-- PHP Version: 5.3.2

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `evd1`
--

-- --------------------------------------------------------

--
-- Table structure for table `church`
--

DROP TABLE IF EXISTS `church`;
CREATE TABLE IF NOT EXISTS `church` (
  `church_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `church_date_created` datetime NOT NULL,
  `church_last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `church_name` varchar(255) DEFAULT NULL,
  `church_full_name` varchar(1000) DEFAULT NULL,
  `section_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`church_id`),
  KEY `section_id` (`section_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `church`
--

INSERT INTO `church` (`church_id`, `church_date_created`, `church_last_modified`, `church_name`, `church_full_name`, `section_id`) VALUES(1, '2011-07-16 02:00:45', '2011-07-16 02:00:45', 'MARC', NULL, 1);
INSERT INTO `church` (`church_id`, `church_date_created`, `church_last_modified`, `church_name`, `church_full_name`, `section_id`) VALUES(2, '2011-07-16 02:00:45', '2011-07-16 02:00:45', 'OEWM', NULL, 2);

-- --------------------------------------------------------

--
-- Table structure for table `ci_sessions`
--

DROP TABLE IF EXISTS `ci_sessions`;
CREATE TABLE IF NOT EXISTS `ci_sessions` (
  `session_id` varchar(40) NOT NULL DEFAULT '0',
  `ip_address` varchar(16) NOT NULL DEFAULT '0',
  `user_agent` varchar(150) NOT NULL,
  `last_activity` int(10) unsigned NOT NULL DEFAULT '0',
  `user_data` text NOT NULL,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ci_sessions`
--


-- --------------------------------------------------------

--
-- Table structure for table `district`
--

DROP TABLE IF EXISTS `district`;
CREATE TABLE IF NOT EXISTS `district` (
  `district_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `district_date_created` datetime NOT NULL,
  `district_last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `district_name` varchar(255) DEFAULT NULL,
  `district_presbyter` int(11) unsigned NOT NULL,
  PRIMARY KEY (`district_id`),
  KEY `fk_district_pastor_profile_id` (`district_presbyter`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `district`
--

INSERT INTO `district` (`district_id`, `district_date_created`, `district_last_modified`, `district_name`, `district_presbyter`) VALUES(1, '2011-07-16 01:21:16', '2011-07-16 08:02:18', 'Eastern Visayas District', 2);

-- --------------------------------------------------------

--
-- Table structure for table `login_attempts`
--

DROP TABLE IF EXISTS `login_attempts`;
CREATE TABLE IF NOT EXISTS `login_attempts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(40) NOT NULL,
  `login` varchar(50) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `login_attempts`
--


-- --------------------------------------------------------

--
-- Table structure for table `pastor_profile`
--

DROP TABLE IF EXISTS `pastor_profile`;
CREATE TABLE IF NOT EXISTS `pastor_profile` (
  `pastor_profile_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pastor_profile_date_created` datetime NOT NULL,
  `pastor_profile_last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `pastor_profile_country` varchar(20) DEFAULT NULL,
  `pastor_profile_website` varchar(255) DEFAULT NULL,
  `pastor_profile_license` enum('local','general','ordained') DEFAULT NULL,
  `pastor_profile_title` enum('pastor','reverend') DEFAULT NULL,
  `user_id` int(11) unsigned DEFAULT NULL,
  `church_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`pastor_profile_id`),
  KEY `fk_pastor_profile_user_id` (`user_id`),
  KEY `fk_pastor_profile_church_id` (`church_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `pastor_profile`
--

INSERT INTO `pastor_profile` (`pastor_profile_id`, `pastor_profile_date_created`, `pastor_profile_last_modified`, `pastor_profile_country`, `pastor_profile_website`, `pastor_profile_license`, `pastor_profile_title`, `user_id`, `church_id`) VALUES(1, '2011-07-16 02:00:45', '2011-07-16 08:27:24', NULL, NULL, 'ordained', 'reverend', 2, 1);
INSERT INTO `pastor_profile` (`pastor_profile_id`, `pastor_profile_date_created`, `pastor_profile_last_modified`, `pastor_profile_country`, `pastor_profile_website`, `pastor_profile_license`, `pastor_profile_title`, `user_id`, `church_id`) VALUES(2, '2011-07-16 02:00:45', '2011-07-16 08:27:22', NULL, NULL, 'ordained', 'reverend', 3, 2);
INSERT INTO `pastor_profile` (`pastor_profile_id`, `pastor_profile_date_created`, `pastor_profile_last_modified`, `pastor_profile_country`, `pastor_profile_website`, `pastor_profile_license`, `pastor_profile_title`, `user_id`, `church_id`) VALUES(3, '2011-07-16 02:00:45', '2011-07-16 02:00:45', NULL, NULL, 'ordained', 'pastor', 4, 1);
INSERT INTO `pastor_profile` (`pastor_profile_id`, `pastor_profile_date_created`, `pastor_profile_last_modified`, `pastor_profile_country`, `pastor_profile_website`, `pastor_profile_license`, `pastor_profile_title`, `user_id`, `church_id`) VALUES(5, '2011-07-16 01:35:25', '2011-07-16 01:35:25', NULL, NULL, NULL, NULL, 5, 1);

-- --------------------------------------------------------

--
-- Table structure for table `section`
--

DROP TABLE IF EXISTS `section`;
CREATE TABLE IF NOT EXISTS `section` (
  `section_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `section_date_created` datetime NOT NULL,
  `section_last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `section_name` varchar(255) DEFAULT NULL,
  `section_presbyter` int(11) unsigned NOT NULL,
  `district_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`section_id`),
  KEY `fk_section_district_id` (`district_id`),
  KEY `fk_section_pastor_profile_id` (`section_presbyter`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `section`
--

INSERT INTO `section` (`section_id`, `section_date_created`, `section_last_modified`, `section_name`, `section_presbyter`, `district_id`) VALUES(1, '2011-07-16 01:21:16', '2011-07-16 02:54:56', 'Section 1', 1, 1);
INSERT INTO `section` (`section_id`, `section_date_created`, `section_last_modified`, `section_name`, `section_presbyter`, `district_id`) VALUES(2, '2011-07-16 01:21:16', '2011-07-16 01:21:16', 'Section 2', 0, 1);
INSERT INTO `section` (`section_id`, `section_date_created`, `section_last_modified`, `section_name`, `section_presbyter`, `district_id`) VALUES(3, '2011-07-16 01:21:16', '2011-07-16 01:21:16', 'Section 3', 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `user_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_date_created` datetime NOT NULL,
  `user_last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_last_login` datetime NOT NULL,
  `user_login` varchar(50) NOT NULL,
  `user_password` varchar(255) NOT NULL,
  `user_email` varchar(100) NOT NULL,
  `user_activated` tinyint(1) NOT NULL DEFAULT '1',
  `user_banned` tinyint(1) NOT NULL DEFAULT '0',
  `user_ban_reason` varchar(255) DEFAULT NULL,
  `user_new_password_key` varchar(50) DEFAULT NULL,
  `user_new_password_requested` datetime DEFAULT NULL,
  `user_new_email` varchar(100) DEFAULT NULL,
  `user_new_email_key` varchar(50) DEFAULT NULL,
  `user_last_ip` varchar(40) NOT NULL,
  `user_firstname` varchar(255) NOT NULL,
  `user_middlename` varchar(255) DEFAULT NULL,
  `user_lastname` varchar(255) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `user_date_created`, `user_last_modified`, `user_last_login`, `user_login`, `user_password`, `user_email`, `user_activated`, `user_banned`, `user_ban_reason`, `user_new_password_key`, `user_new_password_requested`, `user_new_email`, `user_new_email_key`, `user_last_ip`, `user_firstname`, `user_middlename`, `user_lastname`) VALUES(1, '2011-07-16 02:00:45', '2011-07-16 01:36:04', '2011-07-16 02:00:45', 'admin', '$P$B.i21bTQUP4qFX86HFFWHKL8neBw6E.', 'evd@b3rx.co.cc', 1, 0, NULL, NULL, NULL, NULL, '', '127.0.0.1', '', '', '');
INSERT INTO `user` (`user_id`, `user_date_created`, `user_last_modified`, `user_last_login`, `user_login`, `user_password`, `user_email`, `user_activated`, `user_banned`, `user_ban_reason`, `user_new_password_key`, `user_new_password_requested`, `user_new_email`, `user_new_email_key`, `user_last_ip`, `user_firstname`, `user_middlename`, `user_lastname`) VALUES(2, '2011-07-16 02:00:45', '2011-07-16 01:36:01', '2011-07-16 02:00:45', 'cmangoba', '$P$B.i21bTQUP4qFX86HFFWHKL8neBw6E.', 'upcmandaue@gmail.com', 1, 0, NULL, NULL, NULL, NULL, '', '127.0.0.1', 'Cornelio', NULL, 'Mangoba');
INSERT INTO `user` (`user_id`, `user_date_created`, `user_last_modified`, `user_last_login`, `user_login`, `user_password`, `user_email`, `user_activated`, `user_banned`, `user_ban_reason`, `user_new_password_key`, `user_new_password_requested`, `user_new_email`, `user_new_email_key`, `user_last_ip`, `user_firstname`, `user_middlename`, `user_lastname`) VALUES(3, '2011-07-16 02:00:45', '2011-07-16 01:35:59', '2011-07-16 02:00:45', 'aperez', '$P$B.i21bTQUP4qFX86HFFWHKL8neBw6E.', 'aperez@gmail.com', 1, 0, NULL, NULL, NULL, NULL, '', '127.0.0.1', 'Amado', NULL, 'Perez');
INSERT INTO `user` (`user_id`, `user_date_created`, `user_last_modified`, `user_last_login`, `user_login`, `user_password`, `user_email`, `user_activated`, `user_banned`, `user_ban_reason`, `user_new_password_key`, `user_new_password_requested`, `user_new_email`, `user_new_email_key`, `user_last_ip`, `user_firstname`, `user_middlename`, `user_lastname`) VALUES(4, '2011-07-16 02:00:45', '2011-07-16 01:35:57', '2011-07-16 02:00:45', 'tcrieta', '$P$B.i21bTQUP4qFX86HFFWHKL8neBw6E.', 'tcrieta@gmail.com', 1, 0, NULL, NULL, NULL, NULL, '', '', 'Tito', NULL, 'Crieta');
INSERT INTO `user` (`user_id`, `user_date_created`, `user_last_modified`, `user_last_login`, `user_login`, `user_password`, `user_email`, `user_activated`, `user_banned`, `user_ban_reason`, `user_new_password_key`, `user_new_password_requested`, `user_new_email`, `user_new_email_key`, `user_last_ip`, `user_firstname`, `user_middlename`, `user_lastname`) VALUES(5, '2011-07-16 01:03:07', '2011-07-16 01:35:25', '2011-07-16 01:03:07', 'bkintanar', '$P$BBSw.H0gl/pDO7bhDU6gjqXdGDOzCe0', 'bertrand.kintanar@gmail.com', 1, 0, NULL, NULL, NULL, NULL, NULL, '121.54.11.228', '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `user_autologin`
--

DROP TABLE IF EXISTS `user_autologin`;
CREATE TABLE IF NOT EXISTS `user_autologin` (
  `key_id` char(32) NOT NULL,
  `user_id` int(11) unsigned NOT NULL DEFAULT '0',
  `user_agent` varchar(150) NOT NULL,
  `last_ip` varchar(40) NOT NULL,
  `last_login` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`key_id`,`user_id`),
  KEY `fk_user_autologin_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_autologin`
--


--
-- Constraints for dumped tables
--

--
-- Constraints for table `church`
--
ALTER TABLE `church`
  ADD CONSTRAINT `fk_church_section_id` FOREIGN KEY (`section_id`) REFERENCES `section` (`section_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `district`
--
ALTER TABLE `district`
  ADD CONSTRAINT `fk_district_pastor_profile_id` FOREIGN KEY (`district_presbyter`) REFERENCES `pastor_profile` (`pastor_profile_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `pastor_profile`
--
ALTER TABLE `pastor_profile`
  ADD CONSTRAINT `fk_pastor_profile_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_pastor_profile_church_id` FOREIGN KEY (`church_id`) REFERENCES `church` (`church_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `section`
--
ALTER TABLE `section`
  ADD CONSTRAINT `fk_section_district_id` FOREIGN KEY (`district_id`) REFERENCES `district` (`district_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_section_pastor_profile_id` FOREIGN KEY (`section_presbyter`) REFERENCES `pastor_profile` (`pastor_profile_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `user_autologin`
--
ALTER TABLE `user_autologin`
  ADD CONSTRAINT `fk_user_autologin_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
SET FOREIGN_KEY_CHECKS=1;
