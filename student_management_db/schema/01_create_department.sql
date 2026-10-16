CREATE TABLE department (
  department_id SERIAL PRIMARY KEY,
  buiding varchar(50),
  created_at timestamp DEFAULT CURRENT_TIMESTAMP
);