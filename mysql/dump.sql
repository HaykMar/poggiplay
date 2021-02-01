-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Фев 02 2021 г., 01:11
-- Версия сервера: 5.7.26
-- Версия PHP: 7.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `dump`
--

-- --------------------------------------------------------

--
-- Структура таблицы `boosterpack`
--

DROP TABLE IF EXISTS `boosterpack`;
CREATE TABLE IF NOT EXISTS `boosterpack` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `bank` decimal(10,2) NOT NULL DEFAULT '0.00',
  `time_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `time_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `boosterpack`
--

INSERT INTO `boosterpack` (`id`, `price`, `bank`, `time_created`, `time_updated`) VALUES
(1, '5.00', '1.00', '2020-03-30 00:17:28', '2021-02-01 20:16:43'),
(2, '20.00', '0.00', '2020-03-30 00:17:28', '2021-02-01 18:26:01'),
(3, '50.00', '0.00', '2020-03-30 00:17:28', '2021-02-01 18:26:04');

-- --------------------------------------------------------

--
-- Структура таблицы `boosterpack_history`
--

DROP TABLE IF EXISTS `boosterpack_history`;
CREATE TABLE IF NOT EXISTS `boosterpack_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `boosterpack_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `bank` decimal(10,2) NOT NULL DEFAULT '0.00',
  `likes` int(11) NOT NULL,
  `time_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `boosterpack_id` (`boosterpack_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `boosterpack_history`
--

INSERT INTO `boosterpack_history` (`id`, `boosterpack_id`, `user_id`, `bank`, `likes`, `time_created`) VALUES
(1, 1, 1, '4.00', 1, '2021-02-01 19:21:16'),
(2, 1, 1, '5.00', 4, '2021-02-01 20:10:07'),
(3, 1, 1, '0.00', 10, '2021-02-01 20:14:38'),
(4, 1, 1, '0.00', 5, '2021-02-01 20:15:25'),
(5, 1, 1, '1.00', 4, '2021-02-01 20:16:43');

-- --------------------------------------------------------

--
-- Структура таблицы `comment`
--

DROP TABLE IF EXISTS `comment`;
CREATE TABLE IF NOT EXISTS `comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL,
  `assign_id` int(10) UNSIGNED NOT NULL,
  `text` text NOT NULL,
  `likes` int(11) NOT NULL DEFAULT '0',
  `time_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `time_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `comment`
--

INSERT INTO `comment` (`id`, `user_id`, `assign_id`, `text`, `likes`, `time_created`, `time_updated`) VALUES
(1, 1, 1, 'Ну чо ассигн проверим', 0, '2020-03-27 21:39:44', '2021-02-01 18:26:30'),
(2, 1, 1, 'Второй коммент', 1, '2020-03-27 21:39:55', '2021-02-01 20:15:35'),
(3, 2, 1, 'Второй коммент от второго человека', 0, '2020-03-27 21:40:22', '2021-02-01 18:26:35'),
(8, 1, 1, 'first comment', 0, '2021-02-01 19:17:51', '2021-02-01 19:17:51');

-- --------------------------------------------------------

--
-- Структура таблицы `post`
--

DROP TABLE IF EXISTS `post`;
CREATE TABLE IF NOT EXISTS `post` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL,
  `text` text NOT NULL,
  `img` varchar(1024) DEFAULT NULL,
  `likes` int(11) NOT NULL DEFAULT '0',
  `time_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `time_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `post`
--

INSERT INTO `post` (`id`, `user_id`, `text`, `img`, `likes`, `time_created`, `time_updated`) VALUES
(1, 1, 'Тестовый постик 1', '/images/posts/1.png', 1, '2018-08-30 13:31:14', '2021-02-01 19:21:30'),
(2, 1, 'Печальный пост', '/images/posts/2.png', 0, '2018-10-11 01:33:27', '2021-02-01 18:26:46');

-- --------------------------------------------------------

--
-- Структура таблицы `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` varchar(60) DEFAULT NULL,
  `password` varchar(32) DEFAULT NULL,
  `personaname` varchar(50) NOT NULL DEFAULT '',
  `avatarfull` varchar(150) NOT NULL DEFAULT '',
  `rights` tinyint(4) NOT NULL DEFAULT '0',
  `wallet_balance` decimal(10,2) NOT NULL DEFAULT '0.00',
  `wallet_total_refilled` decimal(10,2) NOT NULL DEFAULT '0.00',
  `wallet_total_withdrawn` decimal(10,2) NOT NULL DEFAULT '0.00',
  `like_balance` int(11) NOT NULL,
  `time_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `time_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `time_created` (`time_created`),
  KEY `time_updated` (`time_updated`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `user`
--

INSERT INTO `user` (`id`, `email`, `password`, `personaname`, `avatarfull`, `rights`, `wallet_balance`, `wallet_total_refilled`, `wallet_total_withdrawn`, `like_balance`, `time_created`, `time_updated`) VALUES
(1, 'admin@niceadminmail.pl', 'admin_pass', 'AdminProGod', 'https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/96/967871835afdb29f131325125d4395d55386c07a_full.jpg', 0, '5.00', '30.00', '25.00', 22, '2019-07-26 01:53:54', '2021-02-01 20:16:43'),
(2, 'simpleuser@niceadminmail.pl', 'simple_pass', 'simpleuser', 'https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/86/86a0c845038332896455a566a1f805660a13609b_full.jpg', 0, '0.00', '0.00', '0.00', 0, '2019-07-26 01:53:54', '2021-02-01 18:27:10');

-- --------------------------------------------------------

--
-- Структура таблицы `user_history`
--

DROP TABLE IF EXISTS `user_history`;
CREATE TABLE IF NOT EXISTS `user_history` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `wallet_balance` decimal(10,2) NOT NULL DEFAULT '0.00',
  `refilled` decimal(10,2) NOT NULL DEFAULT '0.00',
  `withdrawn` decimal(10,2) NOT NULL DEFAULT '0.00',
  `like_balance` int(11) NOT NULL,
  `time_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `time_created` (`time_created`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `user_history`
--

INSERT INTO `user_history` (`id`, `user_id`, `wallet_balance`, `refilled`, `withdrawn`, `like_balance`, `time_created`) VALUES
(1, 1, '20.00', '20.00', '0.00', 0, '2021-02-01 23:19:34'),
(2, 1, '15.00', '0.00', '5.00', 1, '2021-02-01 23:21:16'),
(3, 1, '10.00', '0.00', '5.00', 4, '2021-02-02 00:10:07'),
(4, 1, '5.00', '0.00', '5.00', 14, '2021-02-02 00:14:38'),
(5, 1, '0.00', '0.00', '5.00', 19, '2021-02-02 00:15:25'),
(6, 1, '10.00', '10.00', '0.00', 18, '2021-02-02 00:16:36'),
(7, 1, '5.00', '0.00', '5.00', 22, '2021-02-02 00:16:43');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
