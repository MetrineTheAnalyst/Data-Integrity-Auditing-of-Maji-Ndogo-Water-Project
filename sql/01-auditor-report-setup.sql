/* 01-auditor-report-setup.sql
   Purpose: Prepare and inspect the auditor's dataset before analysis.
*/

-- Select database
USE md_water_services;

/* 
Instructions:
- To get the ERD of the database:
  Database tab >> Reverse engineer >> Choose the project >> Choose the database
  >> Follow execution commands >> Finish 

- To change table relationships:
  Right click on relationship line >> Edit relationship >> Foreign key >> change cardinality
*/

-- Drop any previous auditor_report table and create a new one
DROP TABLE IF EXISTS `auditor_report`;
CREATE TABLE `auditor_report` (
    `location_id` VARCHAR(32),
    `type_of_water_source` VARCHAR(64),
    `true_water_source_score` INT DEFAULT NULL,
    `statements` VARCHAR(255)
);

/*
To load data into the auditor_report table from the provided CSV file:
Right click on the table >> Table Data Import Wizard >>
Select 'Use existing table' >> Choose CSV file >> Follow prompts >> Finish
*/

-- Preview a few rows
SELECT 
    location_id, 
    true_water_source_score
FROM 
    auditor_report
LIMIT 5;
