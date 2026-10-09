-- ============================================
-- EduGuru Database Schema for PostgreSQL
-- ============================================

-- Create Users Table
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(255) PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    role VARCHAR(50) DEFAULT 'GURU',
    avatar TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Classes Table
CREATE TABLE IF NOT EXISTS classes (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    grade INTEGER,
    user_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create Students Table
CREATE TABLE IF NOT EXISTS students (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    nis VARCHAR(50),
    class_id VARCHAR(255),
    user_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE SET NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create Journals Table
CREATE TABLE IF NOT EXISTS journals (
    id VARCHAR(255) PRIMARY KEY,
    date DATE NOT NULL,
    class_id VARCHAR(255),
    subject VARCHAR(255),
    start_time VARCHAR(50),
    learning_objective TEXT,
    materials TEXT,
    method VARCHAR(100),
    activities TEXT,
    reflection TEXT,
    engagement_level VARCHAR(100),
    user_id VARCHAR(255),
    created_at BIGINT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create Attendance Table
CREATE TABLE IF NOT EXISTS attendance (
    id VARCHAR(255) PRIMARY KEY,
    date DATE NOT NULL,
    student_id VARCHAR(255),
    class_id VARCHAR(255),
    subject VARCHAR(255),
    status VARCHAR(10),
    user_id VARCHAR(255),
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create Scores Table
CREATE TABLE IF NOT EXISTS scores (
    id VARCHAR(255) PRIMARY KEY,
    student_id VARCHAR(255),
    class_id VARCHAR(255),
    subject VARCHAR(255),
    type VARCHAR(50),
    score INTEGER,
    assessment_title VARCHAR(255),
    date DATE,
    notes TEXT,
    user_id VARCHAR(255),
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create Counseling Table
CREATE TABLE IF NOT EXISTS counseling (
    id VARCHAR(255) PRIMARY KEY,
    student_id VARCHAR(255),
    date DATE,
    type VARCHAR(50),
    notes TEXT,
    follow_up TEXT,
    ai_suggestion TEXT,
    is_private BOOLEAN DEFAULT FALSE,
    user_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create Subjects Table
CREATE TABLE IF NOT EXISTS subjects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    user_id VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE(name, user_id)
);

-- Indexes for Optimal Performance
CREATE INDEX IF NOT EXISTS idx_journals_user ON journals(user_id);
CREATE INDEX IF NOT EXISTS idx_attendance_user ON attendance(user_id);
CREATE INDEX IF NOT EXISTS idx_scores_user ON scores(user_id);
CREATE INDEX IF NOT EXISTS idx_students_class ON students(class_id);
CREATE INDEX IF NOT EXISTS idx_classes_user ON classes(user_id);
CREATE INDEX IF NOT EXISTS idx_counseling_user ON counseling(user_id);

-- ============================================
-- Demo Account Seed (Password: demo123)
-- Hash: $2b$10$w09Zq8zF9J5YtWn... generated with bcrypt
-- ============================================
INSERT INTO users (id, username, password, name, role, avatar)
VALUES (
    'user_demo_eduguru',
    'demo@eduguru.id',
    '$2b$10$f94dZtz9r2K2EaJj7P1XnOyO.LzL4K9C052sXp6E6yI6K6qVp6M7m',
    'Guru Demo, S.Pd.',
    'GURU',
    'https://ui-avatars.com/api/?name=Guru+Demo&background=10b981&color=fff'
)
ON CONFLICT (username) DO NOTHING;
