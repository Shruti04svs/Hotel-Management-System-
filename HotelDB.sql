CREATE DATABASE HotelDB;
USE HotelDB;

CREATE TABLE Hotels (
  hotel_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  address VARCHAR(255),
  city VARCHAR(50),
  rating DECIMAL(2,1) CHECK (rating <= 5),
  contact_no VARCHAR(15)
);

CREATE TABLE Rooms (
  room_id INT AUTO_INCREMENT PRIMARY KEY,
  hotel_id INT,
  room_no VARCHAR(10) NOT NULL,
  room_type VARCHAR(50) NOT NULL,
  price_per_night DECIMAL(10,2) CHECK (price_per_night > 0),
  status ENUM('Available','Booked') DEFAULT 'Available',
  FOREIGN KEY (hotel_id) REFERENCES Hotels(hotel_id)
);

CREATE TABLE Guests (
  guest_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  phone VARCHAR(15),
  email VARCHAR(100),
  address VARCHAR(255),
  id_proof VARCHAR(50)
);

CREATE TABLE Bookings (
  booking_id INT AUTO_INCREMENT PRIMARY KEY,
  guest_id INT,
  room_id INT,
  check_in_date DATE,
  check_out_date DATE,
  booking_status ENUM('Booked','CheckedOut','Cancelled') DEFAULT 'Booked',
  FOREIGN KEY (guest_id) REFERENCES Guests(guest_id),
  FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
  CHECK (check_out_date > check_in_date)
);

CREATE TABLE Payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  booking_id INT,
  amount DECIMAL(10,2) CHECK (amount>0),
  mode ENUM('Cash','Card','UPI','NetBanking'),
  payment_date DATE,
  FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);

-- Hotels (5 rows)
INSERT INTO Hotels (name,address,city,rating,contact_no) VALUES
('The Grand Palace','123 MG Road','Mumbai',4.5,'9876543210'),
('Sea View Resort','Beach Road','Goa',4.2,'9822334455'),
('Hilltop Inn','Main Street','Manali',4.0,'9911223344'),
('Urban Stay','Sector 18','Delhi',3.8,'9898989898'),
('Royal Heritage','Old City','Jaipur',4.3,'9765432109');

-- Rooms (7 rows)
INSERT INTO Rooms (hotel_id,room_no,room_type,price_per_night,status) VALUES
(1,'101','Deluxe',5500.00,'Available'),
(1,'102','Suite',8000.00,'Booked'),
(2,'201','Standard',3500.00,'Available'),
(2,'202','Deluxe',5000.00,'Booked'),
(3,'301','Standard',3000.00,'Available'),
(4,'401','Deluxe',4500.00,'Available'),
(5,'501','Suite',9000.00,'Booked');

-- Guests (6 rows)
INSERT INTO Guests (name,phone,email,address,id_proof) VALUES
('Amit Sharma','9876541111','amit@gmail.com','Mumbai','AADHAR1234'),
('Priya Verma','9123456780','priya@yahoo.com','Delhi','AADHAR5678'),
('John Smith','9911002200','john@outlook.com','London','PASSPORT789'),
('Kiran Nair','9898980000','kiran@gmail.com','Kochi','AADHAR2222'),
('Neha Patil','9988776655','neha@gmail.com','Pune','AADHAR3333'),
('Rahul Desai','9090909090','rahul@abc.com','Ahmedabad','AADHAR4444');

-- Bookings (5 rows)
INSERT INTO Bookings (guest_id,room_id,check_in_date,check_out_date,booking_status) VALUES
(1,2,'2024-10-01','2024-10-05','Booked'),
(2,4,'2024-11-10','2024-11-15','Booked'),
(3,7,'2024-09-20','2024-09-25','CheckedOut'),
(4,3,'2024-12-01','2024-12-03','Booked'),
(5,1,'2024-08-05','2024-08-08','Cancelled');

-- Payments (5 rows)
INSERT INTO Payments (booking_id,amount,mode,payment_date) VALUES
(1,32000.00,'Card','2024-09-30'),
(2,25000.00,'UPI','2024-11-09'),
(3,45000.00,'Cash','2024-09-19'),
(4,6000.00,'NetBanking','2024-11-30'),
(5,5000.00,'UPI','2024-08-04');

-- WHERE CLAUSE
-- IN
-- Question - Find all guests from Mumbai, Delhi or Pune
SELECT * FROM Guests 
WHERE address IN ('Mumbai','Delhi','Pune');

-- BETWEEN
-- Question - List rooms priced between ₹3,000 and ₹6,000
SELECT * FROM Rooms 
WHERE price_per_night BETWEEN 3000 AND 6000;

-- LIKE
-- Find all payments where the mode contains the word “Card”:
SELECT * FROM Payments
WHERE mode LIKE '%Card%';

-- Question: Show the 5 latest bookings
SELECT booking_id, guest_id, check_in_date, check_out_date FROM Bookings
ORDER BY check_in_date DESC
LIMIT 5;

-- Hotel + Total Bookings (join + group by)
SELECT h.name AS Hotel, COUNT(b.booking_id) AS Total_Bookings FROM Hotels h
JOIN Rooms r ON h.hotel_id=r.hotel_id
JOIN Bookings b ON r.room_id=b.room_id
GROUP BY h.name;

-- WINDOW FUNCTION
-- Question - Rank the rooms in each hotel based on their price per night (highest price = rank 1) using DENSE_RANK() with PARTITION BY.
SELECT h.name AS Hotel_Name,r.room_no,r.room_type,r.price_per_night,
  DENSE_RANK() OVER (PARTITION BY h.hotel_id ORDER BY r.price_per_night DESC) AS Price_Rank FROM Rooms r
JOIN Hotels h ON r.hotel_id = h.hotel_id;

-- Subquery Example
-- Question- Find all hotels that have rooms priced above the average room price across all hotels.
SELECT name, city, rating FROM Hotels
WHERE hotel_id IN (SELECT hotel_id FROM Rooms
WHERE price_per_night > (SELECT AVG(price_per_night) FROM Rooms)
);




