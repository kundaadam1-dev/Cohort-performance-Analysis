-- 01_data_quality_checks.sql

-- Enrolments per status --- How large is unknown
SELECT status, COUNT(*) AS total_enrolments
FROM enrolments
GROUP BY status
ORDER BY total_enrolments DESC;

-- 31.5% (178) of the enrolments records are unknown

-- what share of students records are missing contact information
SELECT 
	SUM(email = '') missing_email,
    SUM(phone = '') missing_phone
FROM students;

-- 75% of students have missing contact details

-- How many attendance sessions have no status recorded at all 
SELECT status, COUNT(*) AS n
FROM attendance
GROUP BY status 
ORDER BY n DESC;

-- 
SELECT 
	ROUND(100.0 * SUM(status = 'not recorded') / COUNT(*), 2) AS p
FROM attendance;

-- Decision made from these resuits, applied in every query from here
-- * not recorded attendance rows are excluded from attendance 
-- (neither counted as attended nor as absent)
-- * unknown enrolments status is kept as its own category

