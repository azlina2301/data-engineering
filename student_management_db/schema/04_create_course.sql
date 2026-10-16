CREATE TABLE course (
  course_id SERIAL PRIMARY KEY,
  course_code varchar(20) NOT NULL UNIQUE,
  name varchar(100) NOT NULL,
  description text,
  credits integer,
  department_id INT REFERENCES department(department_id),
  created_at timestamp DEFAULT CURRENT_TIMESTAMP
);