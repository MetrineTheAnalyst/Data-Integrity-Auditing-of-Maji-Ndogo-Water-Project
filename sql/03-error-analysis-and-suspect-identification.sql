/* 03-error-analysis-and-suspect-identification.sql
   Purpose: Quantify and investigate data entry errors to detect possible misconduct.
*/

USE md_water_services;

-- Create a CTE to store mismatched records for reuse
WITH incorrect_records AS (
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
        AND audit.true_water_source_score != water_quality.subjective_quality_score
)
SELECT DISTINCT
    employee_name,
    COUNT(employee_name) AS incorrect_entries
FROM 
    incorrect_records
GROUP BY 
    employee_name
ORDER BY 
    incorrect_entries DESC;

-- Find employees with above-average mistake counts
WITH incorrect_records AS (
    SELECT 
        audit.location_id,
        visits.record_id,
        audit.true_water_source_score,
        water_quality.subjective_quality_score,
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
        AND audit.true_water_source_score != water_quality.subjective_quality_score
),
employee_errorcount AS (
    SELECT 
        employee_name,
        COUNT(employee_name) AS incorrect_entries
    FROM 
        incorrect_records
    GROUP BY employee_name
)
SELECT 
    employee_name,
    incorrect_entries
FROM 
    employee_errorcount
WHERE 
    incorrect_entries > (
        SELECT AVG(incorrect_entries) FROM employee_errorcount
    );

-- Create a reusable view to store incorrect record details
CREATE VIEW incorrect_record AS
SELECT 
    audit.location_id AS location,
    visits.record_id AS record_id,
    audit.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score,
    employee.employee_name,
    audit.statements
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

-- Identify suspect employees (more than 6 errors)
WITH suspect_list AS (
    SELECT 
        employee_name,
        COUNT(employee_name) AS incorrect_entries
    FROM 
        incorrect_record
    GROUP BY employee_name
    HAVING incorrect_entries > 6
)
SELECT * FROM suspect_list;

-- Investigate suspect employees' statements for suspicious remarks
WITH suspect_list AS (
    SELECT 
        employee_name,
        COUNT(employee_name) AS incorrect_entries
    FROM 
        incorrect_record
    GROUP BY employee_name
    HAVING incorrect_entries > 6
)
SELECT 
    employee_name,
    statements
FROM 
    incorrect_record
WHERE 
    employee_name IN (SELECT employee_name FROM suspect_list)
    AND statements LIKE "%suspicion%";
