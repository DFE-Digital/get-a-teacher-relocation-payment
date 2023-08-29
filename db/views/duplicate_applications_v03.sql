-- db/views/duplicate_applications_v04.sql
SELECT * FROM (
  SELECT
    applications.*,
    CASE 
      WHEN COUNT(*) OVER (PARTITION BY applicants.email_address) > 1 THEN applicants.email_address
      ELSE NULL
    END AS duplicate_email,
    CASE 
      WHEN COUNT(*) OVER (PARTITION BY applicants.phone_number) > 1 THEN applicants.phone_number
      ELSE NULL
    END AS duplicate_phone,
    CASE 
      WHEN COUNT(*) OVER (PARTITION BY applicants.passport_number) > 1 THEN applicants.passport_number
      ELSE NULL
    END AS duplicate_passport
  FROM
    applications
  INNER JOIN
    applicants
  ON
    applications.applicant_id = applicants.id
  WHERE
    applications.urn IS NOT NULL
  GROUP BY
    applications.id, applicants.email_address, applicants.phone_number, applicants.passport_number
) AS sub_query
WHERE 
  sub_query.duplicate_email IS NOT NULL OR
  sub_query.duplicate_phone IS NOT NULL OR
  sub_query.duplicate_passport IS NOT NULL
ORDER BY
  sub_query.created_at DESC;
