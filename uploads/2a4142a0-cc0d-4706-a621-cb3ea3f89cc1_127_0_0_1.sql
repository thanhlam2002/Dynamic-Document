-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th9 14, 2025 lúc 06:52 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `event25`
--
CREATE DATABASE IF NOT EXISTS `event25` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `event25`;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `attendance`
--

CREATE TABLE `attendance` (
  `attendance_id` bigint(20) NOT NULL,
  `attended` bit(1) NOT NULL,
  `event_id` bigint(20) NOT NULL,
  `marked_on` datetime(6) NOT NULL,
  `method` varchar(20) DEFAULT NULL,
  `student_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `entity_user`
--

CREATE TABLE `entity_user` (
  `id` int(11) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `birth_day` date DEFAULT NULL,
  `date_join` date DEFAULT NULL,
  `email` varchar(180) NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `roles` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `entity_user`
--

INSERT INTO `entity_user` (`id`, `address`, `avatar`, `birth_day`, `date_join`, `email`, `full_name`, `gender`, `password`, `phone_number`, `roles`) VALUES
(1, 'Đông Anh, hà Nội', NULL, '1991-05-23', '2025-09-11', 'admin@gmail.com', 'Nguyễn Văn Thanh', NULL, '$2a$10$fXEuMfWrjJFrOliG.oB1F.bP.S9ayC6RgxLJvebryhg2m.asq4aUe', '966228007', 'ROLE_ADMIN'),
(2, NULL, NULL, NULL, '2025-09-11', 'user1@example.com', 'User One', NULL, '$2a$10$80BpIRn4TrOM69Ip9eqE5uoORteq.0mZmkCOYLi9J2cerWjxuJTUu', NULL, 'ROLE_USER'),
(3, NULL, NULL, NULL, '2025-09-11', 'organizer@gmail.com', 'Organizer One', NULL, '$2a$10$Y5wm0rXZojevbcQ0qjhGpevp6EMwHTTnh9pI05UVpb0ngh6Mwc9zG', NULL, 'ROLE_USER,ROLE_ORGANIZER'),
(4, NULL, NULL, NULL, '2025-09-11', 'test1@gmail.com', 'User Two', NULL, '$2a$10$2HAy7saBT4AgI7lqXjZwRuzyPEDlBs8iQcBP9QVgyxe4J6ilNlNNq', NULL, 'ROLE_USER'),
(5, NULL, NULL, NULL, '2025-09-11', 'test3@gmail.com', 'User There', NULL, '$2a$10$GLkMq3VJS.BCqR00L29ZJOC.V7sqivZ68JD04.O8O6Jl0E7x64O2q', NULL, 'ROLE_USER'),
(6, NULL, NULL, NULL, '2025-09-11', 'organizer12@gmail.com', 'Organizer OneTwo', NULL, '$2a$10$tMYeUojAMEBuIDgDLZIX/.yOkssqiCO/rytxAib00x7x87YHV3jRW', NULL, 'ROLE_USER,ROLE_ORGANIZER'),
(7, NULL, NULL, NULL, '2025-09-11', 'test5@gmail.com', 'Gido', NULL, '$2a$10$AUgzoYuFKJuubHmykfL8Z.FUBVV3VVVe7NwW4SpwT/3RmEeFPJ77a', NULL, 'ROLE_USER,ROLE_ORGANIZER'),
(8, NULL, NULL, NULL, '2025-09-12', 'testemail@gmail.com', 'Test 123', NULL, '$2a$10$tb2orOREulS9DEymWj..hO68WOipjODAFOx0KpYpCrJcd65Bab9b2', NULL, 'ROLE_USER'),
(9, NULL, NULL, NULL, '2025-09-12', 'lthanhnguyen951@gmail.com', 'Nguyễn Thành Lâm', NULL, '$2a$10$.djL/BpBn9ev.KiACxDpyu7KK8r3AzjTxCvX1ANOZZh.zhsQpGi/u', NULL, 'ROLE_USER'),
(10, NULL, NULL, NULL, '2025-09-13', 'organizer1234@gmail.com', 'Organizer 1234', NULL, '$2a$10$3P0dj54NGPFFSxeEGi6JSuHYKt/LGauNQ0iUoZME/6obNf53DEc0O', NULL, 'ROLE_USER,ROLE_ORGANIZER'),
(11, NULL, NULL, NULL, '2025-09-13', 'ngay1309@gmail.com', '1309', NULL, '$2a$10$jwbc/ouiznSHsKgtmJlwH.z8Tj0YDRbkuZUXbZJDeLDoNwuURoHau', NULL, 'ROLE_USER'),
(12, NULL, NULL, NULL, '2025-09-13', 'organizer12345@gmail.com', 'Organizer 1234', NULL, '$2a$10$y/snAKRX6/aPuAZ98gTfKu4tVrAmJDQjwL2FDaQG3d3nfQ6QsMm62', NULL, 'ROLE_USER,ROLE_ORGANIZER'),
(13, NULL, NULL, NULL, '2025-09-13', 'ngay13092025@gmail.com', '13092025', NULL, '$2a$10$bdhp1ZoXzHDyZt891uINbezLRIWVcF5LV5cNoNUwg5a/NaIRvHTNy', NULL, 'ROLE_USER'),
(14, NULL, NULL, NULL, '2025-09-14', 'duytu@gmail.com', 'Le Duy Tu', NULL, '$2a$10$noi7uKbkTMEvAo//COQFKebFukkN84L5XrRQnfTHNBVWh9n.rt2Ka', NULL, 'ROLE_USER'),
(15, NULL, NULL, NULL, '2025-09-14', 'nguyena@gmail.com', 'nguyen van a', NULL, '$2a$10$yXU.x1PbIsZpsfEelPIs2OxGynKsKqK/F3PfipR.2UCziKIH5SJ1a', NULL, 'ROLE_USER'),
(16, NULL, NULL, NULL, '2025-09-14', 'nguyen@gmail.com', 'nguyen van b', NULL, '$2a$10$JF/oKT36R65x1jUbHGLjvOl4gsjrxTVuh/trhQuZkum37GEYzbJGi', NULL, 'ROLE_USER'),
(17, NULL, NULL, NULL, '2025-09-14', 'lamnguyen@gmail.com', 'nguyen thanh lam', NULL, '$2a$10$s/2H16FEzW91FHnmWYFJHu6xn0yJ1iEiIlStm6I/qC55r6pGHLWo.', NULL, 'ROLE_USER'),
(18, NULL, NULL, NULL, '2025-09-14', 'nguyenlam@gmail.com', 'lam nguyen', NULL, '$2a$10$h89WDAeBy0nBAkSA9hv1/umy8xqIIteYbiv6Ce1.52quhF0V2qpZi', NULL, 'ROLE_USER'),
(19, NULL, NULL, NULL, '2025-09-14', 'lamlam@gmail.com', 'lamlam', NULL, '$2a$10$i5AKbSywz1Mk2orTbV2JleOdydJcV4NLV5QfoZqNR7ZiqA0szH4Qy', NULL, 'ROLE_USER'),
(20, NULL, NULL, NULL, '2025-09-14', 'testter@gmail.com', 'test', NULL, '$2a$10$n/WoGQCBGgX8RD2VeE7U8elFD5QJO4eD2HOeHOWuHHILW4boNDAk6', NULL, 'ROLE_USER');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `events`
--

CREATE TABLE `events` (
  `event_id` bigint(20) NOT NULL,
  `category` varchar(50) DEFAULT NULL,
  `date` date NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `description` text DEFAULT NULL,
  `organizer_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `time` time(6) NOT NULL,
  `title` varchar(150) NOT NULL,
  `total_seats` int(11) DEFAULT NULL,
  `venue` varchar(100) DEFAULT NULL,
  `approved_at` datetime(6) DEFAULT NULL,
  `approved_by` bigint(20) DEFAULT NULL,
  `main_image_url` varchar(512) DEFAULT NULL,
  `approval_status` enum('APPROVED','DRAFT','PENDING_APPROVAL','REJECTED') NOT NULL,
  `seats_available` int(11) NOT NULL,
  `version` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `events`
--

INSERT INTO `events` (`event_id`, `category`, `date`, `start_date`, `end_date`, `description`, `organizer_id`, `created_at`, `updated_at`, `time`, `title`, `total_seats`, `venue`, `approved_at`, `approved_by`, `main_image_url`, `approval_status`, `seats_available`, `version`) VALUES
(22, 'Technical', '2025-08-20', '2025-08-20', '2025-08-20', 'Deep dive into microservices architecture, circuit breakers, and observability best practices.', 1, '2025-09-14 02:59:21', '2025-09-14 02:59:21', '09:00:00.000000', 'Microservices Summit 2025', 180, 'Auditorium A', '2025-09-14 02:59:21.000000', 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJyqsqUO4Eipavgu17FGjV9TaApBU8X4nXZl0z8ciqgMsYXluQXpvFtwbH8KL46mKZQuA&usqp=CAU', 'APPROVED', 180, 0),
(23, 'Cultural', '2025-07-10', '2025-07-10', '2025-07-12', 'A cultural night featuring traditional music, dance, and local cuisine.', 1, '2025-09-14 03:01:21', '2025-09-14 03:01:21', '18:30:00.000000', 'Heritage Night 2025', 400, 'Main Campus B', '2025-09-14 03:01:21.000000', 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR60urpHY_IdHY-JjCg8yLfTyHbCRbb79HCmg&s', 'APPROVED', 400, 0),
(25, 'Sports', '2025-09-14', '2025-09-14', '2025-09-16', 'Faculty teams compete in the annual football tournament.', 1, '2025-09-14 03:18:27', '2025-09-14 03:18:27', '15:00:00.000000', 'Interfaculty Football Cup', 800, 'Stadium Field 1', '2025-09-14 03:18:27.000000', 1, 'https://media.istockphoto.com/id/2230782361/vi/anh/building-10-killian-court-great-dome-massachusetts-institute-of-technology-mit-cambridge.jpg?s=612x612&w=0&k=20&c=JjfP4tx31DcCzqhQOVAf7cpgFP9ofAWFb2UA71Eb4Og=', 'APPROVED', 800, 0),
(26, 'Sports', '2025-09-19', '2025-09-19', '2025-09-20', 'Regional college basketball competition hosted on campus.', 1, '2025-09-14 03:19:02', '2025-09-14 11:43:16', '16:00:00.000000', 'Basketball Championship', 700, 'Indoor Gymnasium', '2025-09-14 03:19:02.000000', 1, 'https://media.istockphoto.com/id/2158881565/vi/anh/nam-sinh-ch%E1%BA%A1y-quanh-n%C3%B3n-l%C3%A1-tr%C3%AAn-s%C3%A2n-tr%C6%B0%E1%BB%9Dng.jpg?s=612x612&w=0&k=20&c=x6nq2Nw7ipsD8kNnvlZQdp2FwheqDCsJd-q2MfSMl2I=', 'APPROVED', 694, 0),
(27, 'Workshop', '2025-09-22', '2025-09-22', '2025-09-23', 'Workshop on securing cloud-native apps and zero-trust networking.', 1, '2025-09-14 03:19:35', '2025-09-14 03:19:35', '09:00:00.000000', 'Cloud Security Workshop', 50, 'Lab 5', '2025-09-14 03:19:35.000000', 1, 'https://media.istockphoto.com/id/2233783305/vi/anh/3-sinh-vi%C3%AAn-ch%C3%A2u-%C3%A1-d%C3%A0nh-th%E1%BB%9Di-gian-cho-m%E1%BB%99t-d%E1%BB%B1-%C3%A1n-s%E1%BB%AD-d%E1%BB%A5ng-m%C3%A1y-t%C3%ADnh-x%C3%A1ch-tay-nh%C6%B0-m%E1%BB%99t-c%C3%B4ng-c%E1%BB%A5-quan.jpg?s=612x612&w=0&k=20&c=FSMoo3wBrjDnLouzzO4sDmJvqYmjAMTdrmFGj9sD2os=', 'APPROVED', 50, 0),
(28, 'Workshop', '2025-09-25', '2025-09-25', '2025-09-26', 'Learn D3.js, Tableau, and storytelling with data.', 1, '2025-09-14 03:20:08', '2025-09-14 03:20:08', '14:00:00.000000', 'Data Visualization Bootcamp', 75, 'Computer Science Lab', '2025-09-14 03:20:08.000000', 1, 'https://media.istockphoto.com/id/2230771405/vi/anh/gi%C3%A1o-d%E1%BB%A5c-h%E1%BB%8Dc-sinh-v%C3%A0-nh%C3%B3m-trong-l%E1%BB%9Bp-h%E1%BB%8Dc-n%C3%B3i-chuy%E1%BB%87n-ho%E1%BA%B7c-chu%E1%BA%A9n-b%E1%BB%8B-cho-k%E1%BB%B3-thi-l%C3%B3a-%E1%BB%91ng-k%C3%ADnh-v%C3%A0.jpg?s=612x612&w=0&k=20&c=snT-xmE56iw1YAlyDUOuhvNOyxgmve5eHb21G5esHeM=', 'APPROVED', 75, 0),
(29, 'Cultural', '2025-09-14', '2025-09-14', '2025-09-14', 'A fair showcasing clubs, art exhibitions, and cultural exchange activities.', 12, '2025-09-14 03:22:20', '2025-09-14 04:12:13', '09:00:00.000000', 'Campus Culture Fair', 500, 'Central Plaza', '2025-09-14 04:12:13.000000', 1, 'https://media.istockphoto.com/id/1368007576/vi/anh/nh%E1%BB%AFng-ng%C6%B0%E1%BB%9Di-%C4%83n-m%E1%BA%B7c-h%E1%BA%A1nh-ph%C3%BAc-%C4%83n-m%E1%BB%ABng-t%E1%BA%A1i-b%E1%BB%AFa-ti%E1%BB%87c-l%E1%BB%85-h%E1%BB%99i-n%C3%A9m-hoa-gi%E1%BA%A5y-t%E1%BA%ADp-trung-ch%C3%ADnh-v%C3%A0o-khu%C3%B4n.jpg?s=612x612&w=0&k=20&c=HkEdfCyC6BEm0ScZ1TYALc_5Kv5iritJ9S5zpLQYNas=', 'APPROVED', 500, 1),
(30, 'Cultural', '2025-09-20', '2025-09-20', '2025-09-21', 'Live music from international bands and solo performers.', 12, '2025-09-14 03:23:38', '2025-09-14 04:23:57', '18:00:00.000000', 'International Music Festival', 1000, 'Open Air Stage', '2025-09-14 04:23:57.000000', 1, 'https://media.istockphoto.com/id/2192204480/vi/anh/n%E1%BB%AF-sinh-vi%C3%AAn-%C4%91%E1%BA%A1i-h%E1%BB%8Dc-tr%E1%BA%BB-m%E1%BB%89m-c%C6%B0%E1%BB%9Di-v%E1%BB%9Bi-m%C3%A1y-%E1%BA%A3nh-trong-khi-s%E1%BB%AD-d%E1%BB%A5ng-m%C3%A1y-t%C3%ADnh-x%C3%A1ch-tay-xung-quanh-l%C3%A0.jpg?s=612x612&w=0&k=20&c=Mvu5s2fT7x5OkaJdRrWebOY5-olRxEOOqTUug-FZeaM=', 'APPROVED', 1000, 1),
(31, 'Technical', '2025-08-20', '2025-08-20', '2025-08-20', 'Deep dive into microservices architecture, circuit breakers, and observability best practices.', 12, '2025-09-14 04:38:52', '2025-09-14 04:44:32', '09:00:00.000000', 'Microservices Summit 2025', 180, 'Auditorium A', '2025-09-14 04:44:32.000000', 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlL5vekRTHeIbs_xOhi29g-96ZV2r77tL7TQ&s', 'APPROVED', 180, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `feedback`
--

CREATE TABLE `feedback` (
  `feedback_id` bigint(20) NOT NULL,
  `comments` text DEFAULT NULL,
  `event_id` bigint(20) NOT NULL,
  `rating` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `submitted_on` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `feedback`
--

INSERT INTO `feedback` (`feedback_id`, `comments`, `event_id`, `rating`, `student_id`, `submitted_on`) VALUES
(3, 'Chỉnh sửa nội dung feedback', 1, 4, 1, '2025-09-11 03:41:58.000000'),
(4, NULL, 13, 5, 13, '2025-09-13 03:50:26.000000'),
(5, NULL, 12, 5, 13, '2025-09-13 03:50:47.000000'),
(6, NULL, 12, 5, 12, '2025-09-13 03:50:52.000000'),
(7, 'Sự kiện tổ chức tốt, check-in nhanh.', 12, 5, 12, '2025-09-13 03:51:13.000000');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `media_gallery`
--

CREATE TABLE `media_gallery` (
  `image_id` bigint(20) NOT NULL,
  `caption` varchar(150) DEFAULT NULL,
  `file_type` varchar(10) NOT NULL,
  `file_url` varchar(255) NOT NULL,
  `uploaded_on` datetime(6) NOT NULL,
  `event_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `qr_tickets`
--

CREATE TABLE `qr_tickets` (
  `ticket_id` bigint(20) NOT NULL,
  `event_id` bigint(20) NOT NULL,
  `expires_at` datetime(6) DEFAULT NULL,
  `issued_on` datetime(6) NOT NULL,
  `status` enum('ACTIVE','REDEEMED','REVOKED') NOT NULL,
  `student_id` int(11) NOT NULL,
  `token` varchar(64) NOT NULL,
  `updated_on` datetime(6) NOT NULL,
  `used_at` datetime(6) DEFAULT NULL,
  `used_by` bigint(20) DEFAULT NULL,
  `version` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `registrations`
--

CREATE TABLE `registrations` (
  `registration_id` bigint(20) NOT NULL,
  `event_id` bigint(20) NOT NULL,
  `registered_on` datetime(6) NOT NULL,
  `status` enum('CANCELLED','CONFIRMED','PENDING') NOT NULL,
  `student_id` bigint(20) NOT NULL,
  `updated_on` datetime(6) NOT NULL,
  `version` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `registrations`
--

INSERT INTO `registrations` (`registration_id`, `event_id`, `registered_on`, `status`, `student_id`, `updated_on`, `version`) VALUES
(14, 16, '2025-09-14 01:46:37.000000', 'CONFIRMED', 14, '2025-09-14 01:46:37.000000', 0),
(15, 26, '2025-09-14 04:07:45.000000', 'CONFIRMED', 15, '2025-09-14 04:07:45.000000', 0),
(16, 26, '2025-09-14 04:09:36.000000', 'CONFIRMED', 16, '2025-09-14 04:09:36.000000', 0),
(17, 26, '2025-09-14 04:21:00.000000', 'CONFIRMED', 17, '2025-09-14 04:21:00.000000', 0),
(18, 26, '2025-09-14 04:21:52.000000', 'CONFIRMED', 18, '2025-09-14 04:21:52.000000', 0),
(19, 26, '2025-09-14 04:22:45.000000', 'CONFIRMED', 19, '2025-09-14 04:22:45.000000', 0),
(20, 26, '2025-09-14 04:43:16.000000', 'CONFIRMED', 20, '2025-09-14 04:43:16.000000', 0);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`attendance_id`),
  ADD UNIQUE KEY `UKiksj96uyf0mhm13si5p1htyws` (`event_id`,`student_id`);

--
-- Chỉ mục cho bảng `entity_user`
--
ALTER TABLE `entity_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_entity_user_email` (`email`);

--
-- Chỉ mục cho bảng `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`event_id`),
  ADD KEY `idx_events_date_range` (`start_date`,`end_date`);

--
-- Chỉ mục cho bảng `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`feedback_id`);

--
-- Chỉ mục cho bảng `media_gallery`
--
ALTER TABLE `media_gallery`
  ADD PRIMARY KEY (`image_id`),
  ADD KEY `FKifec52ajatgkk21tx9t6mx4df` (`event_id`);

--
-- Chỉ mục cho bảng `qr_tickets`
--
ALTER TABLE `qr_tickets`
  ADD PRIMARY KEY (`ticket_id`),
  ADD UNIQUE KEY `UKdo3ax2e3lo1aqcpsdvgyyqrth` (`event_id`,`student_id`),
  ADD UNIQUE KEY `UK726s5gpi5ob1d9q6qlm48cvt3` (`token`);

--
-- Chỉ mục cho bảng `registrations`
--
ALTER TABLE `registrations`
  ADD PRIMARY KEY (`registration_id`),
  ADD UNIQUE KEY `UK7mqe6g11pupqpu0cw6cokbra9` (`event_id`,`student_id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `attendance`
--
ALTER TABLE `attendance`
  MODIFY `attendance_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `entity_user`
--
ALTER TABLE `entity_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT cho bảng `events`
--
ALTER TABLE `events`
  MODIFY `event_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT cho bảng `feedback`
--
ALTER TABLE `feedback`
  MODIFY `feedback_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `media_gallery`
--
ALTER TABLE `media_gallery`
  MODIFY `image_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `qr_tickets`
--
ALTER TABLE `qr_tickets`
  MODIFY `ticket_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT cho bảng `registrations`
--
ALTER TABLE `registrations`
  MODIFY `registration_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `media_gallery`
--
ALTER TABLE `media_gallery`
  ADD CONSTRAINT `FKifec52ajatgkk21tx9t6mx4df` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`);
--
-- Cơ sở dữ liệu: `phpmyadmin`
--
CREATE DATABASE IF NOT EXISTS `phpmyadmin` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `phpmyadmin`;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `pma__bookmark`
--

CREATE TABLE `pma__bookmark` (
  `id` int(10) UNSIGNED NOT NULL,
  `dbase` varchar(255) NOT NULL DEFAULT '',
  `user` varchar(255) NOT NULL DEFAULT '',
  `label` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `query` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Bookmarks';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `pma__central_columns`
--

CREATE TABLE `pma__central_columns` (
  `db_name` varchar(64) NOT NULL,
  `col_name` varchar(64) NOT NULL,
  `col_type` varchar(64) NOT NULL,
  `col_length` text DEFAULT NULL,
  `col_collation` varchar(64) NOT NULL,
  `col_isNull` tinyint(1) NOT NULL,
  `col_extra` varchar(255) DEFAULT '',
  `col_default` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Central list of columns';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `pma__column_info`
--

CREATE TABLE `pma__column_info` (
  `id` int(5) UNSIGNED NOT NULL,
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `column_name` varchar(64) NOT NULL DEFAULT '',
  `comment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `mimetype` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `transformation` varchar(255) NOT NULL DEFAULT '',
  `transformation_options` varchar(255) NOT NULL DEFAULT '',
  `input_transformation` varchar(255) NOT NULL DEFAULT '',
  `input_transformation_options` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Column information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `pma__designer_settings`
--

CREATE TABLE `pma__designer_settings` (
  `username` varchar(64) NOT NULL,
  `settings_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Settings related to Designer';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `pma__export_templates`
--

CREATE TABLE `pma__export_templates` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL,
  `export_type` varchar(10) NOT NULL,
  `template_name` varchar(64) NOT NULL,
  `template_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved export templates';

--
-- Đang đổ dữ liệu cho bảng `pma__export_templates`
--

INSERT INTO `pma__export_templates` (`id`, `username`, `export_type`, `template_name`, `template_data`) VALUES
(1, 'root', 'database', 'event2525', '{\"quick_or_custom\":\"quick\",\"what\":\"sql\",\"structure_or_data_forced\":\"0\",\"table_select[]\":[\"attendance\",\"entity_user\",\"events\",\"feedback\",\"media_gallery\",\"qr_tickets\",\"registrations\"],\"table_structure[]\":[\"attendance\",\"entity_user\",\"events\",\"feedback\",\"media_gallery\",\"qr_tickets\",\"registrations\"],\"table_data[]\":[\"attendance\",\"entity_user\",\"events\",\"feedback\",\"media_gallery\",\"qr_tickets\",\"registrations\"],\"aliases_new\":\"\",\"output_format\":\"sendit\",\"filename_template\":\"@DATABASE@\",\"remember_template\":\"on\",\"charset\":\"utf-8\",\"compression\":\"none\",\"maxsize\":\"\",\"codegen_structure_or_data\":\"data\",\"codegen_format\":\"0\",\"csv_separator\":\",\",\"csv_enclosed\":\"\\\"\",\"csv_escaped\":\"\\\"\",\"csv_terminated\":\"AUTO\",\"csv_null\":\"NULL\",\"csv_columns\":\"something\",\"csv_structure_or_data\":\"data\",\"excel_null\":\"NULL\",\"excel_columns\":\"something\",\"excel_edition\":\"win\",\"excel_structure_or_data\":\"data\",\"json_structure_or_data\":\"data\",\"json_unicode\":\"something\",\"latex_caption\":\"something\",\"latex_structure_or_data\":\"structure_and_data\",\"latex_structure_caption\":\"Cấu trúc của bảng @TABLE@\",\"latex_structure_continued_caption\":\"Cấu trúc của bảng @TABLE@ (còn nữa)\",\"latex_structure_label\":\"tab:@TABLE@-structure\",\"latex_relation\":\"something\",\"latex_comments\":\"something\",\"latex_mime\":\"something\",\"latex_columns\":\"something\",\"latex_data_caption\":\"Nội dung của bảng @TABLE@\",\"latex_data_continued_caption\":\"Nội dung của bảng @TABLE@ (còn nữa)\",\"latex_data_label\":\"tab:@TABLE@-data\",\"latex_null\":\"\\\\textit{NULL}\",\"mediawiki_structure_or_data\":\"structure_and_data\",\"mediawiki_caption\":\"something\",\"mediawiki_headers\":\"something\",\"htmlword_structure_or_data\":\"structure_and_data\",\"htmlword_null\":\"NULL\",\"ods_null\":\"NULL\",\"ods_structure_or_data\":\"data\",\"odt_structure_or_data\":\"structure_and_data\",\"odt_relation\":\"something\",\"odt_comments\":\"something\",\"odt_mime\":\"something\",\"odt_columns\":\"something\",\"odt_null\":\"NULL\",\"pdf_report_title\":\"\",\"pdf_structure_or_data\":\"structure_and_data\",\"phparray_structure_or_data\":\"data\",\"sql_include_comments\":\"something\",\"sql_header_comment\":\"\",\"sql_use_transaction\":\"something\",\"sql_compatibility\":\"NONE\",\"sql_structure_or_data\":\"structure_and_data\",\"sql_create_table\":\"something\",\"sql_auto_increment\":\"something\",\"sql_create_view\":\"something\",\"sql_procedure_function\":\"something\",\"sql_create_trigger\":\"something\",\"sql_backquotes\":\"something\",\"sql_type\":\"INSERT\",\"sql_insert_syntax\":\"both\",\"sql_max_query_size\":\"50000\",\"sql_hex_for_binary\":\"something\",\"sql_utc_time\":\"something\",\"texytext_structure_or_data\":\"structure_and_data\",\"texytext_null\":\"NULL\",\"xml_structure_or_data\":\"data\",\"xml_export_events\":\"something\",\"xml_export_functions\":\"something\",\"xml_export_procedures\":\"something\",\"xml_export_tables\":\"something\",\"xml_export_triggers\":\"something\",\"xml_export_views\":\"something\",\"xml_export_contents\":\"something\",\"yaml_structure_or_data\":\"data\",\"\":null,\"lock_tables\":null,\"as_separate_files\":null,\"csv_removeCRLF\":null,\"excel_removeCRLF\":null,\"json_pretty_print\":null,\"htmlword_columns\":null,\"ods_columns\":null,\"sql_dates\":null,\"sql_relation\":null,\"sql_mime\":null,\"sql_disable_fk\":null,\"sql_views_as_tables\":null,\"sql_metadata\":null,\"sql_create_database\":null,\"sql_drop_table\":null,\"sql_if_not_exists\":null,\"sql_simple_view_export\":null,\"sql_view_current_user\":null,\"sql_or_replace_view\":null,\"sql_truncate\":null,\"sql_delayed\":null,\"sql_ignore\":null,\"texytext_columns\":null}');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `pma__favorite`
--

CREATE TABLE `pma__favorite` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Favorite tables';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `pma__history`
--

CREATE TABLE `pma__history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db` varchar(64) NOT NULL DEFAULT '',
  `table` varchar(64) NOT NULL DEFAULT '',
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp(),
  `sqlquery` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='SQL history for phpMyAdmin';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `pma__navigationhiding`
--

CREATE TABLE `pma__navigationhiding` (
  `username` varchar(64) NOT NULL,
  `item_name` varchar(64) NOT NULL,
  `item_type` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Hidden items of navigation tree';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `pma__pdf_pages`
--

CREATE TABLE `pma__pdf_pages` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `page_nr` int(10) UNSIGNED NOT NULL,
  `page_descr` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='PDF relation pages for phpMyAdmin';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `pma__recent`
--

CREATE TABLE `pma__recent` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Recently accessed tables';

--
-- Đang đổ dữ liệu cho bảng `pma__recent`
--

INSERT INTO `pma__recent` (`username`, `tables`) VALUES
('root', '[{\"db\":\"event25\",\"table\":\"events\"},{\"db\":\"event25\",\"table\":\"attendance\"},{\"db\":\"event25\",\"table\":\"registrations\"},{\"db\":\"event25\",\"table\":\"qr_tickets\"},{\"db\":\"event25\",\"table\":\"media_gallery\"},{\"db\":\"event25\",\"table\":\"feedback\"},{\"db\":\"event25\",\"table\":\"entity_user\"}]');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `pma__relation`
--

CREATE TABLE `pma__relation` (
  `master_db` varchar(64) NOT NULL DEFAULT '',
  `master_table` varchar(64) NOT NULL DEFAULT '',
  `master_field` varchar(64) NOT NULL DEFAULT '',
  `foreign_db` varchar(64) NOT NULL DEFAULT '',
  `foreign_table` varchar(64) NOT NULL DEFAULT '',
  `foreign_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Relation table';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `pma__savedsearches`
--

CREATE TABLE `pma__savedsearches` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `search_name` varchar(64) NOT NULL DEFAULT '',
  `search_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved searches';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `pma__table_coords`
--

CREATE TABLE `pma__table_coords` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `pdf_page_number` int(11) NOT NULL DEFAULT 0,
  `x` float UNSIGNED NOT NULL DEFAULT 0,
  `y` float UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table coordinates for phpMyAdmin PDF output';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `pma__table_info`
--

CREATE TABLE `pma__table_info` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `display_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `pma__table_uiprefs`
--

CREATE TABLE `pma__table_uiprefs` (
  `username` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `prefs` text NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Tables'' UI preferences';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `pma__tracking`
--

CREATE TABLE `pma__tracking` (
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `version` int(10) UNSIGNED NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` datetime NOT NULL,
  `schema_snapshot` text NOT NULL,
  `schema_sql` text DEFAULT NULL,
  `data_sql` longtext DEFAULT NULL,
  `tracking` set('UPDATE','REPLACE','INSERT','DELETE','TRUNCATE','CREATE DATABASE','ALTER DATABASE','DROP DATABASE','CREATE TABLE','ALTER TABLE','RENAME TABLE','DROP TABLE','CREATE INDEX','DROP INDEX','CREATE VIEW','ALTER VIEW','DROP VIEW') DEFAULT NULL,
  `tracking_active` int(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Database changes tracking for phpMyAdmin';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `pma__userconfig`
--

CREATE TABLE `pma__userconfig` (
  `username` varchar(64) NOT NULL,
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `config_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User preferences storage for phpMyAdmin';

--
-- Đang đổ dữ liệu cho bảng `pma__userconfig`
--

INSERT INTO `pma__userconfig` (`username`, `timevalue`, `config_data`) VALUES
('root', '2025-09-14 04:49:44', '{\"Console\\/Mode\":\"collapse\",\"lang\":\"vi\"}');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `pma__usergroups`
--

CREATE TABLE `pma__usergroups` (
  `usergroup` varchar(64) NOT NULL,
  `tab` varchar(64) NOT NULL,
  `allowed` enum('Y','N') NOT NULL DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User groups with configured menu items';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `pma__users`
--

CREATE TABLE `pma__users` (
  `username` varchar(64) NOT NULL,
  `usergroup` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Users and their assignments to user groups';

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `pma__central_columns`
--
ALTER TABLE `pma__central_columns`
  ADD PRIMARY KEY (`db_name`,`col_name`);

--
-- Chỉ mục cho bảng `pma__column_info`
--
ALTER TABLE `pma__column_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `db_name` (`db_name`,`table_name`,`column_name`);

--
-- Chỉ mục cho bảng `pma__designer_settings`
--
ALTER TABLE `pma__designer_settings`
  ADD PRIMARY KEY (`username`);

--
-- Chỉ mục cho bảng `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_user_type_template` (`username`,`export_type`,`template_name`);

--
-- Chỉ mục cho bảng `pma__favorite`
--
ALTER TABLE `pma__favorite`
  ADD PRIMARY KEY (`username`);

--
-- Chỉ mục cho bảng `pma__history`
--
ALTER TABLE `pma__history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`,`db`,`table`,`timevalue`);

--
-- Chỉ mục cho bảng `pma__navigationhiding`
--
ALTER TABLE `pma__navigationhiding`
  ADD PRIMARY KEY (`username`,`item_name`,`item_type`,`db_name`,`table_name`);

--
-- Chỉ mục cho bảng `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  ADD PRIMARY KEY (`page_nr`),
  ADD KEY `db_name` (`db_name`);

--
-- Chỉ mục cho bảng `pma__recent`
--
ALTER TABLE `pma__recent`
  ADD PRIMARY KEY (`username`);

--
-- Chỉ mục cho bảng `pma__relation`
--
ALTER TABLE `pma__relation`
  ADD PRIMARY KEY (`master_db`,`master_table`,`master_field`),
  ADD KEY `foreign_field` (`foreign_db`,`foreign_table`);

--
-- Chỉ mục cho bảng `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_savedsearches_username_dbname` (`username`,`db_name`,`search_name`);

--
-- Chỉ mục cho bảng `pma__table_coords`
--
ALTER TABLE `pma__table_coords`
  ADD PRIMARY KEY (`db_name`,`table_name`,`pdf_page_number`);

--
-- Chỉ mục cho bảng `pma__table_info`
--
ALTER TABLE `pma__table_info`
  ADD PRIMARY KEY (`db_name`,`table_name`);

--
-- Chỉ mục cho bảng `pma__table_uiprefs`
--
ALTER TABLE `pma__table_uiprefs`
  ADD PRIMARY KEY (`username`,`db_name`,`table_name`);

--
-- Chỉ mục cho bảng `pma__tracking`
--
ALTER TABLE `pma__tracking`
  ADD PRIMARY KEY (`db_name`,`table_name`,`version`);

--
-- Chỉ mục cho bảng `pma__userconfig`
--
ALTER TABLE `pma__userconfig`
  ADD PRIMARY KEY (`username`);

--
-- Chỉ mục cho bảng `pma__usergroups`
--
ALTER TABLE `pma__usergroups`
  ADD PRIMARY KEY (`usergroup`,`tab`,`allowed`);

--
-- Chỉ mục cho bảng `pma__users`
--
ALTER TABLE `pma__users`
  ADD PRIMARY KEY (`username`,`usergroup`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `pma__column_info`
--
ALTER TABLE `pma__column_info`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `pma__history`
--
ALTER TABLE `pma__history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  MODIFY `page_nr` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- Cơ sở dữ liệu: `restaurant_db`
--
CREATE DATABASE IF NOT EXISTS `restaurant_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `restaurant_db`;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `admins`
--

CREATE TABLE `admins` (
  `id` bigint(20) NOT NULL,
  `password_hash` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `admins`
--

INSERT INTO `admins` (`id`, `password_hash`, `username`) VALUES
(1, '$2a$10$clQ7okDZ2RHPiOg7U3sH2.bgbjl1aFMtHjeNnEOhr30X3jNzQp5FG', 'admin');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `type` enum('FOOD','DRINK') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `categories`
--

INSERT INTO `categories` (`id`, `name`, `type`, `created_at`) VALUES
(1, 'Phở', 'FOOD', '2025-09-11 16:14:05'),
(2, 'Nước uống', 'DRINK', '2025-09-11 16:14:05'),
(3, 'Cơm Rang', 'FOOD', '2025-09-11 16:35:12');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `menu_items`
--

CREATE TABLE `menu_items` (
  `id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `price` decimal(38,2) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `menu_items`
--

INSERT INTO `menu_items` (`id`, `category_id`, `name`, `price`, `image_url`, `active`, `created_at`) VALUES
(1, 1, 'Phở Bò Tái', 45000.00, NULL, 1, '2025-09-11 16:14:07'),
(2, 1, 'Phở Gà', 40000.00, NULL, 1, '2025-09-11 16:14:07'),
(3, 1, 'Phở Đặc Biệt', 60000.00, NULL, 1, '2025-09-11 16:14:07'),
(4, 2, 'Trà Đá', 5000.00, NULL, 1, '2025-09-11 16:14:07'),
(5, 2, 'Coca-Cola', 15000.00, NULL, 1, '2025-09-11 16:14:07'),
(6, 2, 'Bia Hà Nội', 20000.00, NULL, 1, '2025-09-11 16:14:07'),
(7, 3, 'Cơm Rang Thập Cẩm', 35000.00, NULL, 1, '2025-09-11 16:35:27'),
(9, 1, 'Phở Tái Gầu', 60000.00, NULL, 1, '2025-09-11 16:36:38');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) NOT NULL,
  `table_id` int(11) NOT NULL,
  `status` enum('PENDING','IN_PROGRESS','COMPLETED','CANCELLED') NOT NULL DEFAULT 'PENDING',
  `opened_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `closed_at` timestamp NULL DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `total_amount` bigint(20) DEFAULT 0,
  `customer_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `orders`
--

INSERT INTO `orders` (`id`, `table_id`, `status`, `opened_at`, `closed_at`, `note`, `total_amount`, `customer_name`) VALUES
(2, 2, 'COMPLETED', '2025-09-11 16:16:05', '2025-09-11 16:16:36', NULL, 400000, NULL),
(3, 2, 'COMPLETED', '2025-09-11 16:17:00', '2025-09-11 16:17:17', NULL, 245000, NULL),
(4, 3, 'COMPLETED', '2025-09-11 16:17:20', '2025-09-11 16:17:29', NULL, 290000, NULL),
(5, 3, 'COMPLETED', '2025-09-11 16:17:34', '2025-09-11 16:34:54', NULL, 290000, NULL),
(6, 2, 'COMPLETED', '2025-09-11 16:36:41', '2025-09-11 16:37:05', NULL, 240000, NULL),
(7, 2, 'COMPLETED', '2025-09-11 16:37:07', '2025-09-11 16:37:17', NULL, 205000, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_items`
--

CREATE TABLE `order_items` (
  `id` bigint(20) NOT NULL,
  `order_id` bigint(20) NOT NULL,
  `menu_item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `unit_price` bigint(20) NOT NULL,
  `note` varchar(255) DEFAULT NULL,
  `printed_to_kitchen` tinyint(1) NOT NULL DEFAULT 0,
  `printed_to_bar` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `menu_item_id`, `quantity`, `unit_price`, `note`, `printed_to_kitchen`, `printed_to_bar`, `created_at`) VALUES
(1, 2, 1, 3, 45000, NULL, 1, 0, '2025-09-11 16:16:08'),
(2, 2, 3, 2, 60000, NULL, 1, 0, '2025-09-11 16:16:10'),
(3, 2, 4, 2, 5000, NULL, 0, 1, '2025-09-11 16:16:15'),
(4, 2, 5, 2, 15000, NULL, 0, 1, '2025-09-11 16:16:15'),
(5, 2, 6, 1, 20000, NULL, 0, 1, '2025-09-11 16:16:16'),
(6, 2, 1, 1, 45000, NULL, 0, 0, '2025-09-11 16:16:33'),
(7, 2, 2, 1, 40000, NULL, 0, 0, '2025-09-11 16:16:34'),
(8, 3, 1, 1, 45000, NULL, 1, 0, '2025-09-11 16:17:02'),
(9, 3, 2, 1, 40000, NULL, 1, 0, '2025-09-11 16:17:03'),
(10, 3, 3, 1, 60000, NULL, 1, 0, '2025-09-11 16:17:03'),
(11, 3, 2, 1, 40000, NULL, 1, 0, '2025-09-11 16:17:11'),
(12, 3, 3, 1, 60000, NULL, 1, 0, '2025-09-11 16:17:12'),
(13, 4, 2, 1, 40000, NULL, 1, 0, '2025-09-11 16:17:20'),
(14, 4, 3, 1, 60000, NULL, 1, 0, '2025-09-11 16:17:21'),
(15, 4, 1, 1, 45000, NULL, 1, 0, '2025-09-11 16:17:21'),
(16, 4, 2, 1, 40000, NULL, 0, 0, '2025-09-11 16:17:27'),
(17, 4, 1, 1, 45000, NULL, 0, 0, '2025-09-11 16:17:27'),
(18, 4, 3, 1, 60000, NULL, 0, 0, '2025-09-11 16:17:28'),
(19, 5, 1, 1, 45000, NULL, 1, 0, '2025-09-11 16:34:37'),
(20, 5, 2, 1, 40000, NULL, 1, 0, '2025-09-11 16:34:37'),
(21, 5, 3, 1, 60000, NULL, 1, 0, '2025-09-11 16:34:38'),
(22, 5, 2, 1, 40000, NULL, 1, 0, '2025-09-11 16:34:45'),
(23, 5, 3, 1, 60000, NULL, 1, 0, '2025-09-11 16:34:46'),
(24, 5, 1, 1, 45000, NULL, 1, 0, '2025-09-11 16:34:46'),
(25, 6, 1, 1, 45000, NULL, 1, 0, '2025-09-11 16:36:42'),
(26, 6, 2, 1, 40000, NULL, 1, 0, '2025-09-11 16:36:42'),
(27, 6, 9, 1, 60000, NULL, 1, 0, '2025-09-11 16:36:43'),
(28, 6, 3, 1, 60000, NULL, 1, 0, '2025-09-11 16:36:43'),
(29, 6, 7, 1, 35000, NULL, 1, 0, '2025-09-11 16:36:44'),
(30, 7, 2, 1, 40000, NULL, 1, 0, '2025-09-11 16:37:07'),
(31, 7, 9, 1, 60000, NULL, 1, 0, '2025-09-11 16:37:08'),
(32, 7, 3, 1, 60000, NULL, 1, 0, '2025-09-11 16:37:08'),
(33, 7, 1, 1, 45000, NULL, 1, 0, '2025-09-11 16:37:08');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tables_pho`
--

CREATE TABLE `tables_pho` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `status` enum('AVAILABLE','OCCUPIED') NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `customer_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tables_pho`
--

INSERT INTO `tables_pho` (`id`, `name`, `status`, `active`, `created_at`, `customer_name`) VALUES
(1, 'Bàn 1', 'AVAILABLE', 1, '2025-09-11 16:13:04', NULL),
(2, 'Bàn 2', 'AVAILABLE', 1, '2025-09-11 16:13:09', NULL),
(3, 'Bàn 3', 'AVAILABLE', 1, '2025-09-11 16:13:14', NULL);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UKmi8vkhus4xbdbqcac2jm4spvd` (`username`);

--
-- Chỉ mục cho bảng `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_categories_name` (`name`);

--
-- Chỉ mục cho bảng `menu_items`
--
ALTER TABLE `menu_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_cat_name` (`category_id`,`name`);

--
-- Chỉ mục cho bảng `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_orders_table_status` (`table_id`,`status`),
  ADD KEY `idx_orders_opened_at` (`opened_at`);

--
-- Chỉ mục cho bảng `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_oi_menu` (`menu_item_id`),
  ADD KEY `idx_oi_order` (`order_id`);

--
-- Chỉ mục cho bảng `tables_pho`
--
ALTER TABLE `tables_pho`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `admins`
--
ALTER TABLE `admins`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `menu_items`
--
ALTER TABLE `menu_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT cho bảng `tables_pho`
--
ALTER TABLE `tables_pho`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `menu_items`
--
ALTER TABLE `menu_items`
  ADD CONSTRAINT `fk_menu_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_order_table` FOREIGN KEY (`table_id`) REFERENCES `tables_pho` (`id`);

--
-- Các ràng buộc cho bảng `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_oi_menu` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_oi_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
--
-- Cơ sở dữ liệu: `test`
--
CREATE DATABASE IF NOT EXISTS `test` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `test`;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
