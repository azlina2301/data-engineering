CREATE TABLE instructor (
  instructor_id SERIAL PRIMARY KEY,
  first_name varchar(50) NOT NULL,
  last_name varchar(50) NOT NULL,
  email varchar(100) NOT NULL UNIQUE,
  phone varchar(20),
  date_of_birth date,
  hire_date date DEFAULT CURRENT_DATE,
  salary numeric(10, 2),
  department_id INT REFERENCES department(department_id),
  created_at timestamp DEFAULT CURRENT_TIMESTAMP
);