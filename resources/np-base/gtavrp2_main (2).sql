CREATE TABLE `characters` (
  `id` INT(11) NULL AUTO_INCREMENT,
  `owner` VARCHAR(50) DEFAULT NULL,
  `first_name` VARCHAR(50) NOT NULL DEFAULT 'John',
  `last_name` VARCHAR(50) NOT NULL DEFAULT 'Doe',
  `date_created` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  `cash` INT(9) DEFAULT 500,
  `bank` INT(9) NOT NULL DEFAULT 5000,
  `phone_number` BIGINT(11) NOT NULL DEFAULT 0,
  `dob` DATE NOT NULL DEFAULT '0000-00-00',
  `story` TEXT NOT NULL,
  `new` INT(1) NOT NULL DEFAULT 1,	
  `deleted` INT(11) NOT NULL DEFAULT 0,
  `deletion_date` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
  `gender` INT(1) NOT NULL DEFAULT 0,
  `jail_time` INT(11) NOT NULL DEFAULT 0,
  `dirty_money` INT(11) NOT NULL DEFAULT 0,
  `gang_type` INT(11) NOT NULL DEFAULT 0,
  `jail_time_mobster` INT(11) NOT NULL DEFAULT 0,
  `judge_type` INT(11) NOT NULL DEFAULT 0,
  `iswjob` INT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
);

CREATE TABLE `users` (
  `id` INT(11) NULL AUTO_INCREMENT,
  `hex_id` VARCHAR(100) DEFAULT NULL,
  `steam_id` VARCHAR(50) DEFAULT NULL,
  `community_id` VARCHAR(100) DEFAULT NULL,
  `license` VARCHAR(255) DEFAULT NULL,
  `name` VARCHAR(255) NOT NULL DEFAULT 'Uknown',
  `ip` VARCHAR(50) NOT NULL DEFAULT 'Uknown',
  `rank` VARCHAR(50) NOT NULL DEFAULT 'user',
  `date_created` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (id)
);

CREATE TABLE `users_whitelist` (
  `id` INT(11) NULL AUTO_INCREMENT,
  `steam_id` VARCHAR(50) DEFAULT NULL,
  `power` INT(11) NOT NULL DEFAULT 0,
  `admin_name` TEXT NOT NULL,
  `user_name` TEXT NOT NULL,
  `user_ip` TEXT NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE `user_bans` (
  `id` INT(11) NULL AUTO_INCREMENT,
  `admin` VARCHAR(255) NOT NULL,
  `name` VARCHAR(255) NOT NULL DEFAULT 'Unknown',
  `ip` VARCHAR(255) NOT NULL,
  `steam_id` VARCHAR(100) NOT NULL,
  `license` VARCHAR(255) NOT NULL,
  `bandate` INT(11) NOT NULL,
  `unbandate` INT(11) NOT NULL,
  `length` INT(11) NOT NULL,
  `reason` VARCHAR(255) NOT NULL DEFAULT 'No Reason',
  `removed` INT(11) NOT NULL DEFAULT 0,
   PRIMARY KEY (id)
);

ALTER TABLE `users_whitelist`
  ADD UNIQUE INDEX `steamid(steamid)`;



