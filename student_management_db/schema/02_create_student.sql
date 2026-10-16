CREATE TABLE student (
  student_id SERIAL PRIMARY KEY,
  first_name varchar(50) NOT NULL,
  last_name varchar(50) NOT NULL,
  email varchar(100) NOT NULL UNIQUE,
  date_of_birth date,
  enrolment_date date DEFAULT CURRENT_DATE,
  department_id INT REFERENCES department(department_id),
  is_active boolean DEFAULT TRUE,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP
);