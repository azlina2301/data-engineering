CREATE TABLE enrollment (
  enrollment_id SERIAL PRIMARY KEY,
  student_id INT REFERENCES student(student_id) NOT NULL,
  class_id INT REFERENCES class(class_id) NOT NULL,
  enrollment_date date,
  grade varchar(2),
  created_at timestamp DEFAULT CURRENT_TIMESTAMP
);