-- ====================================================================
-- Eventify Studio - Database Schema & Sample Records (MySQL / PostgreSQL)
-- Project: Eventify Studio - Event & Venue Booking Platform
-- Architecture: Relational SQL Database (RDBMS)
-- ====================================================================

CREATE DATABASE IF NOT EXISTS eventify_db;
USE eventify_db;

-- --------------------------------------------------------------------
-- 1. USERS TABLE (Attendee & Member Accounts)
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS venues;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    wallet_balance DECIMAL(10, 2) DEFAULT 0.00,
    role VARCHAR(20) DEFAULT 'attendee',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seed Initial Users
INSERT INTO users (full_name, phone_number, password_hash, wallet_balance, role) VALUES
('Rahul Sharma', '9876543210', 'Password@123', 500.00, 'attendee'),
('Priya Patel', '9123456780', 'Eventify@2026', 350.00, 'attendee'),
('Aarav Mehta', '9823456789', 'AaravPass@2026', 200.00, 'attendee');

-- --------------------------------------------------------------------
-- 2. EVENTS TABLE (Concerts, Standup Shows & Recitals)
-- --------------------------------------------------------------------
CREATE TABLE events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    artist_name VARCHAR(100) NOT NULL,
    category ENUM('singing', 'dance', 'comedy') NOT NULL,
    venue_name VARCHAR(150) NOT NULL,
    event_date DATE NOT NULL,
    event_time VARCHAR(20) NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL,
    total_capacity INT DEFAULT 50,
    pre_occupied_seats INT DEFAULT 10,
    venue_type VARCHAR(50) DEFAULT 'Outdoor',
    rating DECIMAL(2, 1) DEFAULT 4.8,
    reviews_count INT DEFAULT 1200,
    status ENUM('active', 'completed', 'cancelled') DEFAULT 'active'
);

-- Seed Events
INSERT INTO events (title, artist_name, category, venue_name, event_date, event_time, base_price, total_capacity, pre_occupied_seats, venue_type, rating, reviews_count) VALUES
('AP Dhillon - One Out Of One Tour', 'AP Dhillon', 'singing', 'Amanora Mall Ground, Pune', '2026-11-12', '7:00 PM', 2499.00, 50, 12, 'Outdoor', 4.9, 1200),
('Arijit Singh - Soulful Symphony', 'Arijit Singh', 'singing', 'Pandit Farms, DP Road, Pune', '2026-12-24', '6:00 PM', 2999.00, 50, 16, 'Outdoor', 5.0, 2800),
('Anuv Jain - Live in Concert', 'Anuv Jain', 'singing', 'JW Marriott Ballroom, Pune', '2026-12-18', '6:30 PM', 1499.00, 50, 8, 'Indoor', 4.8, 950),
('Nora Fatehi - Dance Fever Live', 'Nora Fatehi', 'dance', 'Phoenix Marketcity Courtyard, Pune', '2026-11-28', '6:30 PM', 1999.00, 50, 9, 'Outdoor', 4.7, 1100),
('Bharatnatyam - Classical Dance Night', 'Bharatnatyam Group', 'dance', 'Grand Orchid Hall, Viman Nagar, Pune', '2026-12-10', '5:30 PM', 699.00, 50, 6, 'Indoor', 4.9, 450),
('KR$NA Rap Concert Show', 'KR$NA', 'singing', 'JW Marriott Ballroom, SB Road, Pune', '2026-12-15', '6:00 PM', 1199.00, 50, 10, 'Indoor', 4.8, 1400),
('Karan Aujla - Making Memories Tour', 'Karan Aujla', 'singing', 'Roots9 Arena, Baner, Pune', '2026-11-20', '7:30 PM', 2199.00, 50, 14, 'Outdoor', 4.9, 2100),
('Pranit More Comedy Live', 'Pranit More', 'comedy', 'Roots9 Arena, Baner, Pune', '2026-12-08', '8:00 PM', 599.00, 50, 7, 'Indoor', 4.6, 680),
('Samay Raina - Unfiltered Comedy', 'Samay Raina', 'comedy', 'JW Marriott Auditorium, Pune', '2026-12-05', '8:00 PM', 799.00, 50, 11, 'Indoor', 4.9, 1850);

-- --------------------------------------------------------------------
-- 3. VENUES TABLE (Luxury Lawns & Banquet Venues)
-- --------------------------------------------------------------------
CREATE TABLE venues (
    venue_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    location VARCHAR(150) NOT NULL,
    price_per_day DECIMAL(10, 2) NOT NULL,
    price_per_hour DECIMAL(10, 2) NOT NULL,
    capacity INT NOT NULL,
    venue_type VARCHAR(50) NOT NULL,
    rating DECIMAL(2, 1) DEFAULT 4.8,
    status ENUM('available', 'maintenance') DEFAULT 'available'
);

-- Seed Venues
INSERT INTO venues (name, location, price_per_day, price_per_hour, capacity, venue_type, rating) VALUES
('The Royal Palace Lawn & Ballroom', 'Baner, Pune', 150000.00, 15000.00, 1200, 'Lawn + Banquet', 4.9),
('Grand Orchid Hall', 'Viman Nagar, Pune', 90000.00, 9500.00, 600, 'Indoor Banquet', 4.8),
('JW Grand Ballroom', 'Senapati Bapat Road, Pune', 250000.00, 25000.00, 1500, '5-Star Luxury Hall', 5.0),
('Amanora Arena Grounds', 'Hadapsar, Pune', 350000.00, 35000.00, 5000, 'Open-Air Amphitheater', 4.9),
('Pandit Farms Eco Grounds', 'Karve Nagar / DP Road, Pune', 180000.00, 18000.00, 2500, 'Lush Green Open Lawn', 4.8),
('Phoenix Marketcity Courtyard', 'Viman Nagar, Pune', 120000.00, 12000.00, 1000, 'Urban Open Courtyard', 4.7),
('Roots9 Arena & Banquet', 'Baner, Pune', 80000.00, 8500.00, 450, 'Acoustic Comedy Club', 4.7),
('Blue Diamond Terrace Pavilion', 'Koregaon Park, Pune', 110000.00, 11000.00, 350, 'Rooftop Lounge', 4.8);

-- --------------------------------------------------------------------
-- 4. BOOKINGS TABLE (Tickets & Venue Reservations)
-- --------------------------------------------------------------------
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    booking_ref VARCHAR(50) UNIQUE NOT NULL,
    booking_type ENUM('event_ticket', 'venue_rental') NOT NULL,
    item_title VARCHAR(150) NOT NULL,
    venue_name VARCHAR(150) NOT NULL,
    event_date DATE NOT NULL,
    event_time VARCHAR(20),
    rental_hours INT DEFAULT NULL,
    attendee_name VARCHAR(100) NOT NULL,
    attendee_phone VARCHAR(15) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('paid', 'pending', 'refunded') DEFAULT 'paid',
    qr_code_id VARCHAR(100) NOT NULL,
    booking_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- Seed Initial Bookings
INSERT INTO bookings (user_id, booking_ref, booking_type, item_title, venue_name, event_date, event_time, attendee_name, attendee_phone, total_amount, payment_status, qr_code_id) VALUES
(1, 'EVT-2026-98124', 'event_ticket', 'Arijit Singh - Soulful Symphony', 'Pandit Farms, DP Road, Pune', '2026-12-24', '6:00 PM', 'Rahul Sharma', '9876543210', 4999.00, 'paid', 'QR-ARJ-2026-98124'),
(1, 'EVT-2026-34781', 'event_ticket', 'AP Dhillon - One Out Of One Tour', 'Amanora Mall Ground, Pune', '2026-11-12', '7:00 PM', 'Rahul Sharma', '9876543210', 2999.00, 'paid', 'QR-APD-2026-34781'),
(2, 'VNU-2026-88129', 'venue_rental', 'The Royal Palace Lawn & Ballroom', 'Baner, Pune', '2026-11-15', 'Full Day (24h)', 'Priya Patel', '9123456780', 150000.00, 'paid', 'QR-VNU-2026-88129');

-- --------------------------------------------------------------------
-- 5. TICKETS & SEATS TABLE (Itemized Tiered Seating)
-- --------------------------------------------------------------------
CREATE TABLE tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    tier_name ENUM('VIP', 'Premium', 'Gold', 'Silver') NOT NULL,
    tier_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE
);

-- Seed Tickets for Booking #1 & #2
INSERT INTO tickets (booking_id, seat_number, tier_name, tier_price) VALUES
(1, 'A2', 'VIP', 4999.00),
(2, 'B3', 'Premium', 2999.00);

-- ====================================================================
-- USEFUL QUERIES FOR FACULTY DEMO:
--
-- 1. View all registered users:
--    SELECT user_id, full_name, phone_number, role, created_at FROM users;
--
-- 2. View all upcoming events and their capacity:
--    SELECT title, category, event_date, base_price, total_capacity - pre_occupied_seats AS available_seats FROM events;
--
-- 3. View confirmed user bookings with tickets:
--    SELECT b.booking_ref, b.attendee_name, b.item_title, b.total_amount, b.payment_status, t.seat_number, t.tier_name
--    FROM bookings b
--    LEFT JOIN tickets t ON b.booking_id = t.booking_id;
-- ====================================================================
