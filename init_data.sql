-- Place for any init data you wish to have when container starts

CREATE DATABASE test_optimized_db;
USE test_optimized_db;

CREATE TABLE users (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

