-- Run this in MySQL before starting the backend.
-- mysql -u root -p < schema.sql

CREATE DATABASE IF NOT EXISTS uddshare CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE uddshare;

CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(36) PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    hashed_password VARCHAR(255) NOT NULL,
    display_name VARCHAR(255),
    career VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS listings (
    id VARCHAR(36) PRIMARY KEY,
    seller_id VARCHAR(36),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    item_condition VARCHAR(50) NOT NULL,
    status VARCHAR(50) DEFAULT 'active',
    image_url VARCHAR(500),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (seller_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_listings_seller (seller_id),
    INDEX idx_listings_status (status)
);

CREATE TABLE IF NOT EXISTS notes (
    id VARCHAR(36) PRIMARY KEY,
    uploader_id VARCHAR(36),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    career VARCHAR(255) NOT NULL,
    course VARCHAR(255) NOT NULL,
    semester VARCHAR(50),
    file_url VARCHAR(500) NOT NULL,
    file_type VARCHAR(50),
    download_count INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (uploader_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_notes_career (career),
    INDEX idx_notes_course (course)
);
