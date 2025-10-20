/* 02-compare-audit-survey.sql
   Purpose: Compare auditor’s data with survey data to detect inconsistencies.
*/

USE md_water_services;

/* 
There is no direct link between auditor_report and water_quality.
We use the visits table as a bridge to connect them via record_id.
*/

-- Step 1: Join auditor_report and visits
SELECT 
    audit.location_id AS audit_location,
    audit.true_water_source_score,
    visits.location_id AS visit_location,
    visits.record_id AS record_id
FROM 
    auditor_report AS audit
INNER JOIN 
    visits ON visits.location_id = audit.location_id
LIMIT 5;

-- Step 2: Join auditor_report, visits, and water_quality
SELECT 
    audit.location_id AS location,
    visits.record_id AS record_id,
    audit.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score
FROM 
    auditor_report AS audit
INNER JOIN 
    visits ON visits.location_id = audit.location_id
INNER JOIN 
    water_quality ON water_quality.record_id = visits.record_id
LIMIT 5;

-- Step 3: Identify mismatched scores for one visit per location
SELECT 
    audit.location_id AS location,
    visits.record_id AS record_id,
    audit.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score
FROM 
    auditor_report AS audit
INNER JOIN 
    visits ON visits.location_id = audit.location_id
INNER JOIN 
    water_quality ON water_quality.record_id = visits.record_id
WHERE 
    visits.visit_count = 1
    AND audit.true_water_source_score != water_quality.subjective_quality_score;

-- Step 4: Compare water sources to confirm mismatch validity
SELECT 
    audit.location_id AS location,
    visits.record_id AS record_id,
    audit.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score,
    audit.type_of_water_source AS auditor_source,
    water_source.type_of_water_source AS survey_source
FROM 
    auditor_report AS audit
INNER JOIN 
    visits ON visits.location_id = audit.location_id
INNER JOIN 
    water_quality ON water_quality.record_id = visits.record_id
INNER JOIN 
    water_source ON water_source.source_id = visits.source_id
WHERE 
    visits.visit_count = 1
    AND audit.true_water_source_score != water_quality.subjective_quality_score;

-- Step 5: Add employee data to find who collected the inconsistent surveys
SELECT 
    audit.location_id AS location,
    visits.record_id AS record_id,
    audit.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score,
    employee.employee_name
FROM 
    auditor_report AS audit
INNER JOIN 
    visits ON visits.location_id = audit.location_id
INNER JOIN 
    water_quality ON water_quality.record_id = visits.record_id
INNER JOIN 
    employee ON employee.assigned_employee_id = visits.assigned_employee_id
WHERE 
    visits.visit_count = 1
    AND audit.true_water_source_score != water_quality.subjective_quality_score;
