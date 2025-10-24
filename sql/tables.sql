-- ===============================================
-- 1️⃣ USERS TABLE (common for all roles)
-- ===============================================
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    phone VARCHAR(15),
    role VARCHAR(20) CHECK (role IN ('parent', 'employer', 'authority', 'citizen', 'admin')),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'banned')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================================
-- 2️⃣ PARENT / GUARDIAN PROFILE
-- ===============================================
CREATE TABLE parent_profiles (
    parent_id INT PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
    skills TEXT NOT NULL,
    availability VARCHAR(100),
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50)
);

-- ===============================================
-- 3️⃣ EMPLOYER PROFILE
-- ===============================================
CREATE TABLE employer_profiles (
    employer_id INT PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
    company_name VARCHAR(100),
    location VARCHAR(100),
    contact_person VARCHAR(100)
);

-- ===============================================
-- 4️⃣ JOBS (Posted by Employers)
-- ===============================================
CREATE TABLE jobs (
    job_id SERIAL PRIMARY KEY,
    employer_id INT REFERENCES employer_profiles(employer_id) ON DELETE CASCADE,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    work_type VARCHAR(50),
    location VARCHAR(100),
    timings VARCHAR(100),
    verified BOOLEAN DEFAULT FALSE,
    status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open', 'closed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================================
-- 5️⃣ JOB APPLICATIONS (by Parents)
-- ===============================================
CREATE TABLE applications (
    application_id SERIAL PRIMARY KEY,
    job_id INT REFERENCES jobs(job_id) ON DELETE CASCADE,
    parent_id INT REFERENCES parent_profiles(parent_id) ON DELETE CASCADE,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected'))
);

-- ===============================================
-- 6️⃣ REPORTS (Child Labour Reports by Citizens)
-- ===============================================
CREATE TABLE complaints (
    complaint_id SERIAL PRIMARY KEY,
    reported_by INT REFERENCES users(user_id) ON DELETE SET NULL,
    location VARCHAR(150),
    description TEXT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'under_review', 'resolved')),
    reported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================================
-- 7️⃣ AUTHORITIES / NGOs (Handle Reports)
-- ===============================================
CREATE TABLE authorities (
    authority_id INT PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
    organization_name VARCHAR(100),
    designation VARCHAR(100),
    office_location VARCHAR(100)
);

-- ===============================================
-- 8️⃣ ACTIONS TAKEN (by Authorities on Reports)
-- ===============================================
CREATE TABLE actions_taken (
    action_id SERIAL PRIMARY KEY,
    complaint_id INT REFERENCES complaints(complaint_id) ON DELETE CASCADE,
    authority_id INT REFERENCES authorities(authority_id) ON DELETE SET NULL,
    action_description TEXT,
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ===============================================
-- 🔟 ADMIN ACTIVITY LOGS
-- ===============================================
CREATE TABLE admin_logs (
    log_id SERIAL PRIMARY KEY,
    admin_id INT REFERENCES admin_profiles(admin_id) ON DELETE SET NULL,
    action_performed TEXT NOT NULL,
    target_table VARCHAR(50),
    target_id INT,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================================
-- 1️⃣1️⃣ FAQ SECTION
-- ===============================================
CREATE TABLE faq (
    faq_id SERIAL PRIMARY KEY,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    category VARCHAR(50),  -- e.g., 'parents', 'employers', 'reports', 'general'
    created_by INT REFERENCES users(user_id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================================
-- 1️⃣2️⃣ FAQ FEEDBACK (Optional)
-- ===============================================
CREATE TABLE faq_feedback (
    feedback_id SERIAL PRIMARY KEY,
    faq_id INT REFERENCES faq(faq_id) ON DELETE CASCADE,
    user_id INT REFERENCES users(user_id) ON DELETE SET NULL,
    is_helpful BOOLEAN,
    feedback_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
