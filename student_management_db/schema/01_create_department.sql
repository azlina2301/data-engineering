CREATE TABLE department (
  department_id SERIAL PRIMARY KEY,
  name varchar(50) NOT NULL,
  buiding varchar(50),
  created_at timestamp DEFAULT CURRENT_TIMESTAMP
);