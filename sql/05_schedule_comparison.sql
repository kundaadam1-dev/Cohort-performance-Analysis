-- 05_schedule_comparison.sql
--
-- Question:
-- does the number of training days per week affect attendance?
-- cohort 2 to 5 used a three_day a week (MWF), while cohort 6 
-- used a five_day week (MTWTF).

SELECT 
	c.schedule,
    ROUND(100 * SUM(a.status IN ('present', 'late')) / COUNT(*), 1
    ) AS attendance_rate,
    COUNT(*) AS n 
FROM attendance a 
JOIN enrolments e ON a.enrolment_id = e.enrolment_id
JOIN cohorts c ON e.cohort_id = c.cohort_id

WHERE a.status <> 'Not Recorded'
GROUP BY c.schedule;

-- Result:
-- attendance is almost the same under both schedules:
-- 58.0% for the  five day week and 58.9% for the three day week 
-- the difference is less than one percentage point, suggesting 
-- that the change in weekly schedule had little difference
