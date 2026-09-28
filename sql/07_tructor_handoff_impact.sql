-- 07_instructor_handoff_impact.sql
-- purpose for the course/cohort pairing where the instructor changed
-- mid-run, compare attendance before and after the handoff

-- Step find every course/cohort pairing with more than one instructor
-- assignment meaning a handoff happened

WITH multiple_instructors AS(
	SELECT
    course_id,
    cohort_id,
    c.course_name,
    COUNT(*) AS assignments
    FROM instructor_assin
    JOIN courses c USING(course_id)
    GROUP BY course_id, cohort_id, course_name
    HAVING COUNT(*) > 1
    
    )
-- Attendance rate per instructor before and after the handoff.
SELECT
i.instructor_id,
i.start_date,
i.end_date,
ROUND(
	SUM(a.status IN('Present', 'Late')) / COUNT(*) * 100, 1
    ) AS attendance_rate,
    COUNT(*) sessions
    FROM instructor_assin i
    JOIN enrolments e ON i.course_id= e.course_id AND i.cohort_id= e.cohort_id
    
    JOIN attendance a ON e.enrolment_id= a.enrolment_id
    AND a.session_date BETWEEN i.start_date AND i.end_date
    
WHERE (i.course_id, i.cohort_id) IN(SELECT course_id, cohort_id FROM multiple_instructors)
	AND a.status <> 'Not Recorded'
    GROUP BY i.instructor_id, i.start_date, i.end_date
    ORDER BY start_date;
    
-- Data Analysis expriences a sharp drop in attendance after the change
-- in Instructor (from 63.9%