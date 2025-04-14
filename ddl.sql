-- 1. 사용자 관련 테이블
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,           -- 암호화된 비밀번호
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. 문제 테이블 (객관식 문제, 태그/챕터/난이도를 내부에 포함)
CREATE TABLE problems (
    id INT PRIMARY KEY AUTO_INCREMENT,
    description TEXT NOT NULL,             -- 문제 설명
    options TEXT NOT NULL,                 -- 객관식 보기 (백엔드에서 파싱 후 긴 문자열로 저장)
    answer TEXT NOT NULL,                  -- 정답 (예: 'C')
    explanation TEXT,                      -- 해설
    tag_name VARCHAR(100) NOT NULL,        -- 문제 생성 시 정해진 태그명 (예: "컴퓨터네트워크")
    chapter_title VARCHAR(255) NOT NULL,   -- 문제 생성 시 정해진 챕터명 (예: "네트워크 기초")
    difficulty VARCHAR(50) NOT NULL,               -- 난이도 (예: 하 ~ 상)
    type VARCHAR(50) DEFAULT 'tag',        -- 문제 유형: 'tag'(기본 문제) 또는 'wrong_chapter'(오답 기반 문제)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    url VARCHAR(255) 
);

-- 3. 사용자 문제 풀이 기록 테이블
CREATE TABLE user_problem_attempts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    problem_id INT NOT NULL,
    user_answer TEXT,                      -- 사용자가 제출한 답안
    is_correct BOOLEAN,                    -- 정답 여부
    attempted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (problem_id) REFERENCES problems(id)
);

-- 4. 북마크 테이블 (사용자가 나중에 다시 풀 문제 저장)
CREATE TABLE bookmarks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    problem_id INT NOT NULL,
    bookmarked_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (problem_id) REFERENCES problems(id)
);

-- 5. 사용자 오답 문제 테이블 (틀린 문제만 별도로 기록)
CREATE TABLE user_wrong_problems (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    problem_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (problem_id) REFERENCES problems(id)
);

-- 6. 사용자 퀴즈 관련 테이블
-- 6.1. 사용자 퀴즈 기본정보
CREATE TABLE user_quizzes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 6.2. 사용자 퀴즈 상세 기록 (퀴즈에 포함된 문제와 답안)
CREATE TABLE user_quiz_details (
    id INT PRIMARY KEY AUTO_INCREMENT,
    quiz_id INT NOT NULL,
    problem_id INT NOT NULL,
    user_answer TEXT,
    is_correct BOOLEAN,
    answered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (quiz_id) REFERENCES user_quizzes(id),
    FOREIGN KEY (problem_id) REFERENCES problems(id)
);

-- 7. RSS 뉴스 테이블 (최신 뉴스 링크 및 관련 정보 저장)
CREATE TABLE rss_news (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    link VARCHAR(500) NOT NULL,
    description TEXT,
    published_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
