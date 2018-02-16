DROP TABLE tickets;
DROP TABLE customers;
DROP TABLE screenings;
DROP TABLE films;

CREATE TABLE films(
  id SERIAL4 PRIMARY KEY,
  title VARCHAR(255)
);

CREATE TABLE screenings(
  id SERIAL4 PRIMARY KEY,
  time VARCHAR(255),
  price INT4,
  capacity INT4,
  film_id INT4 REFERENCES films(id)
);

CREATE TABLE customers(
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255),
  funds INT4
);

CREATE TABLE tickets(
  id SERIAL4 PRIMARY KEY,
  screening_id INT4 REFERENCES screenings(id),
  customer_id INT4 REFERENCES customers(id)
);
