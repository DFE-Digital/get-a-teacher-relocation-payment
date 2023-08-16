SELECT 
  applications.*,
  dup_email.email_address AS duplicate_email
FROM
  applications
INNER JOIN 
  applicants
ON
  applications.applicant_id = applicants.id
INNER JOIN 
  (
    SELECT 
      email_address,
      COUNT(email_address)
    FROM 
      applicants 
    GROUP BY 
      email_address
    HAVING 
      COUNT(email_address) > 1
  ) dup_email 
ON 
  applicants.email_address = dup_email.email_address
UNION
SELECT 
  applications.*,
  dup_phone.phone_number AS duplicate_phone
FROM
  applications
INNER JOIN 
  applicants
ON
  applications.applicant_id = applicants.id
INNER JOIN 
  (
    SELECT 
      phone_number,
      COUNT(phone_number)
    FROM 
      applicants 
    GROUP BY 
      phone_number
    HAVING 
      COUNT(phone_number) > 1
  ) dup_phone 
ON 
  applicants.phone_number = dup_phone.phone_number
UNION
SELECT 
  applications.*,
  dup_passport.passport_number AS duplicate_passport
FROM
  applications
INNER JOIN 
  applicants
ON
  applications.applicant_id = applicants.id
INNER JOIN 
  (
    SELECT 
      passport_number,
      COUNT(passport_number)
    FROM 
      applicants 
    GROUP BY 
      passport_number
    HAVING 
      COUNT(passport_number) > 1
  ) dup_passport 
ON 
  applicants.passport_number = dup_passport.passport_number
