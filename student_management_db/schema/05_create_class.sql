CREATE TABLE class (
  class_id SERIAL PRIMARY KEY,
  course_id INT REFERENCES course(course_id) NOT NULL,
  instructor_id INT REFERENCES instructor(instructor_id),
  semester varchar(20) NOT NULL,
  year INT NOT NULL,
  max_student INT,
  schedule varchar(100),
  created_at timestamp DEFAULT CURRENT_TIMESTAMP
);