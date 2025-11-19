-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: mysql:3306
-- Generation Time: Nov 19, 2025 at 06:45 PM
-- Server version: 8.0.42
-- PHP Version: 8.3.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `work_allocation`
--

-- --------------------------------------------------------

--
-- Table structure for table `assignment_log`
--

CREATE TABLE `assignment_log` (
  `log_id` int NOT NULL,
  `work_id` varchar(10) NOT NULL,
  `resource_id` varchar(10) NOT NULL,
  `assignment_timestamp` datetime NOT NULL,
  `match_score` float DEFAULT NULL,
  `reasoning` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `assignment_log`
--

INSERT INTO `assignment_log` (`log_id`, `work_id`, `resource_id`, `assignment_timestamp`, `match_score`, `reasoning`) VALUES
(1, 'W023', 'R005', '2025-11-19 18:42:03', 94, 'Dr. Sarah Chen (R005) is the best match for work W023 with a score of 94, demonstrating an exceptional fit based on her specialty as a Neurologist, high skill level, and extensive experience. Her high availability and perfect role match, alongside a reasonable current workload, further solidify this assignment, despite a moderate workload score.'),
(2, 'W024', 'R001', '2025-11-19 18:43:13', 92, 'Dr. John Smith (R001) is the best match for work W024 with a score of 92, driven by a perfect role match as a General Radiologist, high skill level, and extensive experience. His good availability and manageable current workload further solidify this optimal assignment.'),
(3, 'W025', 'R012', '2025-11-19 18:44:06', 86, 'Dr. David Lee (R012) is the best match for work W025 with a score of 86, largely due to his perfect role match as a Musculoskeletal Specialist, high skill level, and extensive experience. Although his availability score is lower, his strong performance in other critical areas makes him the most suitable candidate for this specialized x-ray.');

-- --------------------------------------------------------

--
-- Table structure for table `resources`
--

CREATE TABLE `resources` (
  `resource_id` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  `specialty` varchar(50) NOT NULL,
  `skill_level` int NOT NULL,
  `total_cases_handled` int DEFAULT '0'
) ;

--
-- Dumping data for table `resources`
--

INSERT INTO `resources` (`resource_id`, `name`, `specialty`, `skill_level`, `total_cases_handled`) VALUES
('R001', 'Dr. John Smith', 'General_Radiologist', 4, 178),
('R002', 'Dr. Emily Brown', 'General_Radiologist', 3, 100),
('R003', 'Dr. Michael Davis', 'General_Radiologist', 3, 172),
('R004', 'Dr. Alex Johnson', 'General_Radiologist', 4, 217),
('R005', 'Dr. Sarah Chen', 'Neurologist', 5, 345),
('R006', 'Dr. James Wilson', 'Neurologist', 2, 33),
('R007', 'Dr. Maria Garcia', 'Neurologist', 4, 226),
('R008', 'Dr. Kevin Park', 'Neurologist', 4, 279),
('R009', 'Dr. Robert Johnson', 'Cardiologist', 4, 189),
('R010', 'Dr. Lisa Anderson', 'Cardiologist', 3, 100),
('R011', 'Dr. Thomas White', 'Cardiologist', 3, 179),
('R012', 'Dr. David Lee', 'Musculoskeletal_Specialist', 5, 385),
('R013', 'Dr. Jennifer Martinez', 'Musculoskeletal_Specialist', 1, 61),
('R014', 'Dr. Patricia Taylor', 'Breast_Imaging_Specialist', 3, 94),
('R015', 'Dr. William Moore', 'Breast_Imaging_Specialist', 5, 374);

-- --------------------------------------------------------

--
-- Table structure for table `resource_calendar`
--

CREATE TABLE `resource_calendar` (
  `calendar_id` varchar(10) NOT NULL,
  `resource_id` varchar(10) NOT NULL,
  `date` date NOT NULL,
  `available_from` time NOT NULL,
  `available_to` time NOT NULL,
  `current_workload` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `resource_calendar`
--

INSERT INTO `resource_calendar` (`calendar_id`, `resource_id`, `date`, `available_from`, `available_to`, `current_workload`) VALUES
('C001', 'R001', '2024-11-10', '07:00:00', '19:00:00', 5),
('C002', 'R001', '2024-11-11', '09:00:00', '17:00:00', 3),
('C003', 'R001', '2024-11-12', '08:00:00', '13:00:00', 4),
('C004', 'R002', '2024-11-10', '13:00:00', '18:00:00', 2),
('C005', 'R002', '2024-11-11', '08:00:00', '13:00:00', 8),
('C006', 'R002', '2024-11-12', '09:00:00', '17:00:00', 8),
('C007', 'R003', '2024-11-10', '13:00:00', '18:00:00', 6),
('C008', 'R003', '2024-11-11', '07:00:00', '19:00:00', 8),
('C009', 'R003', '2024-11-12', '13:00:00', '18:00:00', 3),
('C010', 'R004', '2024-11-10', '08:00:00', '13:00:00', 9),
('C011', 'R004', '2024-11-11', '08:00:00', '13:00:00', 10),
('C012', 'R004', '2024-11-12', '09:00:00', '17:00:00', 4),
('C013', 'R005', '2024-11-10', '09:00:00', '17:00:00', 4),
('C014', 'R005', '2024-11-11', '09:00:00', '17:00:00', 4),
('C015', 'R005', '2024-11-12', '09:00:00', '17:00:00', 1),
('C016', 'R006', '2024-11-10', '09:00:00', '17:00:00', 0),
('C017', 'R006', '2024-11-11', '13:00:00', '18:00:00', 1),
('C018', 'R006', '2024-11-12', '09:00:00', '17:00:00', 4),
('C019', 'R007', '2024-11-10', '08:00:00', '13:00:00', 6),
('C020', 'R007', '2024-11-11', '09:00:00', '17:00:00', 8),
('C021', 'R007', '2024-11-12', '13:00:00', '18:00:00', 7),
('C022', 'R008', '2024-11-10', '09:00:00', '17:00:00', 8),
('C023', 'R008', '2024-11-11', '09:00:00', '17:00:00', 10),
('C024', 'R008', '2024-11-12', '09:00:00', '17:00:00', 2),
('C025', 'R009', '2024-11-10', '09:00:00', '17:00:00', 6),
('C026', 'R009', '2024-11-11', '09:00:00', '17:00:00', 6),
('C027', 'R009', '2024-11-12', '09:00:00', '17:00:00', 7),
('C028', 'R010', '2024-11-10', '09:00:00', '17:00:00', 3),
('C029', 'R010', '2024-11-11', '13:00:00', '18:00:00', 1),
('C030', 'R010', '2024-11-12', '09:00:00', '17:00:00', 8),
('C031', 'R011', '2024-11-10', '09:00:00', '17:00:00', 8),
('C032', 'R011', '2024-11-11', '13:00:00', '18:00:00', 1),
('C033', 'R011', '2024-11-12', '07:00:00', '19:00:00', 3),
('C034', 'R012', '2024-11-10', '09:00:00', '17:00:00', 9),
('C035', 'R012', '2024-11-11', '09:00:00', '17:00:00', 7),
('C036', 'R012', '2024-11-12', '09:00:00', '17:00:00', 3),
('C037', 'R013', '2024-11-10', '09:00:00', '17:00:00', 7),
('C038', 'R013', '2024-11-11', '09:00:00', '17:00:00', 8),
('C039', 'R013', '2024-11-12', '08:00:00', '13:00:00', 7),
('C040', 'R014', '2024-11-10', '09:00:00', '17:00:00', 4),
('C041', 'R014', '2024-11-11', '09:00:00', '17:00:00', 0),
('C042', 'R014', '2024-11-12', '09:00:00', '17:00:00', 8),
('C043', 'R015', '2024-11-10', '09:00:00', '17:00:00', 6),
('C044', 'R015', '2024-11-11', '09:00:00', '17:00:00', 10),
('C045', 'R015', '2024-11-12', '07:00:00', '19:00:00', 9);

-- --------------------------------------------------------

--
-- Table structure for table `specialty_mapping`
--

CREATE TABLE `specialty_mapping` (
  `work_type` varchar(50) NOT NULL,
  `required_specialty` varchar(50) NOT NULL,
  `alternate_specialty` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `specialty_mapping`
--

INSERT INTO `specialty_mapping` (`work_type`, `required_specialty`, `alternate_specialty`) VALUES
('CT_Scan_Brain', 'Neurologist', 'General_Radiologist'),
('CT_Scan_Chest', 'General_Radiologist', NULL),
('Mammography', 'Breast_Imaging_Specialist', 'General_Radiologist'),
('MRI_Brain', 'Neurologist', 'General_Radiologist'),
('MRI_Cardiac', 'Cardiologist', 'General_Radiologist'),
('Ultrasound_Abdomen', 'General_Radiologist', NULL),
('X_Ray_Bone', 'Musculoskeletal_Specialist', 'General_Radiologist'),
('X_Ray_Chest', 'General_Radiologist', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `work_requests`
--

CREATE TABLE `work_requests` (
  `work_id` varchar(10) NOT NULL,
  `work_type` varchar(50) NOT NULL,
  `description` text,
  `priority` int NOT NULL,
  `timestamp` datetime NOT NULL,
  `status` varchar(20) DEFAULT 'pending',
  `assigned_to` varchar(10) DEFAULT NULL
) ;

--
-- Dumping data for table `work_requests`
--

INSERT INTO `work_requests` (`work_id`, `work_type`, `description`, `priority`, `timestamp`, `status`, `assigned_to`) VALUES
('W001', 'CT_Scan_Chest', 'Lung nodule - URGENT', 4, '2024-11-12 07:17:00', 'pending', NULL),
('W002', 'MRI_Brain', 'Acute stroke evaluation - URGENT', 4, '2024-11-12 03:47:00', 'completed', 'R011'),
('W003', 'CT_Scan_Chest', 'Cancer staging', 1, '2024-11-10 13:13:00', 'pending', NULL),
('W004', 'CT_Scan_Brain', 'Head trauma assessment', 3, '2024-11-12 04:34:00', 'pending', NULL),
('W005', 'Mammography', 'Annual screening', 3, '2024-11-10 08:48:00', 'assigned', 'R015'),
('W006', 'Ultrasound_Abdomen', 'Kidney stone suspected', 2, '2024-11-10 21:48:00', 'pending', NULL),
('W007', 'CT_Scan_Chest', 'Cancer staging', 1, '2024-11-11 06:38:00', 'pending', NULL),
('W008', 'CT_Scan_Brain', 'Post-surgery follow-up', 2, '2024-11-11 08:05:00', 'pending', NULL),
('W009', 'X_Ray_Bone', 'Joint pain evaluation', 3, '2024-11-10 10:42:00', 'pending', NULL),
('W010', 'X_Ray_Chest', 'Annual checkup', 3, '2024-11-10 14:24:00', 'pending', NULL),
('W011', 'X_Ray_Bone', 'Joint pain evaluation', 2, '2024-11-10 21:42:00', 'pending', NULL),
('W012', 'CT_Scan_Chest', 'COVID complications', 2, '2024-11-10 23:10:00', 'pending', NULL),
('W013', 'X_Ray_Chest', 'Cough and fever', 3, '2024-11-10 11:14:00', 'assigned', 'R009'),
('W014', 'X_Ray_Bone', 'Arthritis follow-up', 2, '2024-11-10 21:58:00', 'completed', 'R013'),
('W015', 'X_Ray_Bone', 'Joint pain evaluation', 3, '2024-11-11 09:56:00', 'completed', 'R005'),
('W016', 'Mammography', 'Follow-up abnormal mammogram', 2, '2024-11-10 23:47:00', 'pending', NULL),
('W017', 'X_Ray_Chest', 'Follow-up pneumonia', 3, '2024-11-11 09:23:00', 'pending', NULL),
('W018', 'MRI_Brain', 'Neurological symptoms', 1, '2024-11-10 11:55:00', 'pending', NULL),
('W019', 'MRI_Brain', 'Neurological symptoms', 2, '2024-11-11 08:24:00', 'pending', NULL),
('W020', 'Mammography', 'Annual screening', 3, '2024-11-10 08:43:00', 'assigned', 'R013'),
('W021', 'MRI_Brain', 'Stroke protocol - CRITICAL', 5, '2024-11-12 14:30:00', 'pending', NULL),
('W022', 'MRI_Cardiac', 'Post-heart attack - CRITICAL', 5, '2024-11-12 15:45:00', 'pending', NULL),
('W023', 'MRI_Brain', 'Urgent brain MRI for suspected stroke patient', 5, '2024-11-10 09:30:00', 'assigned', 'R005'),
('W024', 'Ultrasound_Abdomen', 'Kidney stone suspected, routine ultrasound required', 2, '2024-11-11 14:00:00', 'assigned', 'R001'),
('W025', 'X_Ray_Bone', 'Specialized x-ray for joint pain evaluation', 3, '2024-11-12 08:15:00', 'assigned', 'R012');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assignment_log`
--
ALTER TABLE `assignment_log`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `work_id` (`work_id`),
  ADD KEY `resource_id` (`resource_id`);

--
-- Indexes for table `resources`
--
ALTER TABLE `resources`
  ADD PRIMARY KEY (`resource_id`);

--
-- Indexes for table `resource_calendar`
--
ALTER TABLE `resource_calendar`
  ADD PRIMARY KEY (`calendar_id`),
  ADD KEY `resource_id` (`resource_id`);

--
-- Indexes for table `specialty_mapping`
--
ALTER TABLE `specialty_mapping`
  ADD PRIMARY KEY (`work_type`);

--
-- Indexes for table `work_requests`
--
ALTER TABLE `work_requests`
  ADD PRIMARY KEY (`work_id`),
  ADD KEY `assigned_to` (`assigned_to`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `assignment_log`
--
ALTER TABLE `assignment_log`
  MODIFY `log_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assignment_log`
--
ALTER TABLE `assignment_log`
  ADD CONSTRAINT `assignment_log_ibfk_1` FOREIGN KEY (`work_id`) REFERENCES `work_requests` (`work_id`),
  ADD CONSTRAINT `assignment_log_ibfk_2` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`resource_id`);

--
-- Constraints for table `resource_calendar`
--
ALTER TABLE `resource_calendar`
  ADD CONSTRAINT `resource_calendar_ibfk_1` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`resource_id`);

--
-- Constraints for table `work_requests`
--
ALTER TABLE `work_requests`
  ADD CONSTRAINT `work_requests_ibfk_1` FOREIGN KEY (`assigned_to`) REFERENCES `resources` (`resource_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
