-- 1. users
CREATE TABLE `users` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `login_id` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL DEFAULT '',
  `password` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL DEFAULT '',
  `nickname` VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL DEFAULT '',
  `phone` VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`login_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 2. shelter_missing_animals (보호소 실종동물 공고)
CREATE TABLE `shelter_missing_animals` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '식별자',
  `announcement_no` varchar(50) NOT NULL COMMENT '공고번호',
  `animal_type` varchar(20) NOT NULL COMMENT '동물종류',
  `breed` varchar(50) NOT NULL COMMENT '품종',
  `coat_color` varchar(100) NOT NULL COMMENT '털색',
  `gender` enum('수컷','암컷','미상') NOT NULL COMMENT '성별',
  `neutered` enum('예','아니오') NOT NULL DEFAULT '아니오' COMMENT '중성화 여부',
  `characteristics` text DEFAULT NULL COMMENT '특징',
  `rescue_date` date NOT NULL COMMENT '구조일',
  `rescue_reason` varchar(200) DEFAULT NULL COMMENT '구조사유',
  `rescue_location` varchar(200) NOT NULL COMMENT '구조장소',
  `announce_start` date NOT NULL COMMENT '공고 시작일',
  `announce_end` date NOT NULL COMMENT '공고 종료일',
  `shelter_name` varchar(100) NOT NULL COMMENT '보호센터명',
  `representative` varchar(50) NOT NULL COMMENT '대표자',
  `address` varchar(255) NOT NULL COMMENT '주소',
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `phone` varchar(20) NOT NULL COMMENT '전화번호',
  `remarks` text DEFAULT NULL COMMENT '그 밖의 사항',
  `image_url` varchar(255) DEFAULT NULL COMMENT '이미지 URL',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2791 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='유기 동물 공고 정보';

-- 3. shelter_adoption_animals (보호소 입양동물)
CREATE TABLE `shelter_adoption_animals` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '식별자',
  `announcement_no` varchar(50) NOT NULL COMMENT '공고번호',
  `animal_reg_no` varchar(50) DEFAULT NULL COMMENT '동물등록번호',
  `breed` varchar(100) NOT NULL COMMENT '품종',
  `color` varchar(100) NOT NULL COMMENT '색상',
  `gender` enum('수컷','암컷','미상') NOT NULL COMMENT '성별',
  `neutered` enum('예','아니오') NOT NULL DEFAULT '아니오' COMMENT '중성화 여부',
  `age_weight` varchar(100) NOT NULL COMMENT '나이/체중',
  `rescue_characteristics` text DEFAULT NULL COMMENT '구조 시 특징',
  `social_characteristics` text DEFAULT NULL COMMENT '특징(사회성)',
  `health_characteristics` text DEFAULT NULL COMMENT '특징(건강)',
  `health_checkup` text DEFAULT NULL COMMENT '건강검진 결과',
  `vaccination_status` text DEFAULT NULL COMMENT '접종 상태',
  `occurrence_place` varchar(200) DEFAULT NULL COMMENT '발생장소',
  `reception_datetime` datetime NOT NULL COMMENT '접수일시',
  `other_notes` text DEFAULT NULL COMMENT '기타사항',
  `jurisdiction` varchar(100) DEFAULT NULL COMMENT '관할기관',
  `status` varchar(50) NOT NULL COMMENT '상태',
  `shelter_name` varchar(100) DEFAULT NULL COMMENT '보호센터명',
  `shelter_contact` varchar(20) DEFAULT NULL COMMENT '보호센터 연락처',
  `protection_location` varchar(200) DEFAULT NULL COMMENT '보호장소',
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `adoption_procedure` text DEFAULT NULL COMMENT '입양 절차',
  `adoption_support` text DEFAULT NULL COMMENT '입양 지원',
  `volunteer_info` text DEFAULT NULL COMMENT '봉사 안내',
  `event_info` text DEFAULT NULL COMMENT '행사 안내',
  `image_urls` text DEFAULT NULL COMMENT '이미지 URL 목록 (세미콜론 구분)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1398 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='보호소에서 입양 보낼 동물 정보';

-- 4. pet (반려동물 등록)
CREATE TABLE `pet` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `photo_path` VARCHAR(500) NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `breed` VARCHAR(50) NOT NULL,
  `coat_color` VARCHAR(50),
  `gender` varchar(10) DEFAULT NULL,
  `is_neutered` TINYINT(1) NOT NULL DEFAULT 0,
  `date_of_birth` DATE NOT NULL,
  `age` INT,
  `weight` DECIMAL(5,2),
  `registration_number` VARCHAR(100) DEFAULT NULL UNIQUE,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
);

-- 5. missing_posts (실종/목격 게시물)
CREATE TABLE `missing_posts` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `pet_id` INT DEFAULT NULL,
  `post_type` ENUM('missing','witness') NOT NULL DEFAULT 'missing',
  `photo_url` VARCHAR(500),
  `missing_datetime` DATETIME NOT NULL,
  `missing_location` VARCHAR(255) NOT NULL,
  `latitude` DOUBLE,     
  `longitude` DOUBLE,     
  `detail_description` TEXT,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  FOREIGN KEY (`pet_id`) REFERENCES `pet`(`id`)
);

-- 6. adopt_posts (입양 게시판)
CREATE TABLE `adopt_posts` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `pet_id` INT DEFAULT NULL,
  `photo_path` VARCHAR(500),
  `name` VARCHAR(50),
  `breed` VARCHAR(50),
  `coat_color` VARCHAR(100),          
  `gender` VARCHAR(10),
  `is_neutered` TINYINT(1) DEFAULT 0,
  `date_of_birth` DATE,
  `age` INT,
  `weight` DECIMAL(5,2),
  `registration_number` VARCHAR(100) DEFAULT NULL,
  `title` VARCHAR(200) NOT NULL,
  `is_vet_verified` TINYINT(1) NOT NULL DEFAULT 0,
  `comments` TEXT,
  `adopt_location` VARCHAR(255) NOT NULL,  
  `latitude` DECIMAL(10, 6),              
  `longitude` DECIMAL(10, 6),              
  `status` ENUM('분양중', '분양완료') DEFAULT '분양중',  
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  FOREIGN KEY (`pet_id`) REFERENCES `pet`(`id`) ON DELETE SET NULL
);

-- 7. animal_hospitals (동물병원 정보)
CREATE TABLE `animal_hospitals` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '고유 ID',
  `name` varchar(200) NOT NULL COMMENT '병원명',
  `phone` varchar(20) DEFAULT NULL COMMENT '전화번호',
  `address` varchar(255) DEFAULT NULL COMMENT '소재지',
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `license_number` varchar(50) NOT NULL COMMENT '인허가번호',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT '등록일시',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '수정일시',
  PRIMARY KEY (`id`),
  UNIQUE KEY `license_number` (`license_number`)
) ENGINE=InnoDB AUTO_INCREMENT=5290 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='동물병원 정보';

--8. missing_post_comments(실종 / 목격 게시글 댓글)
CREATE TABLE `missing_post_comments` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `post_id` BIGINT NOT NULL COMMENT '실종/목격 게시글 ID',
  `user_id` INT NOT NULL COMMENT '작성자 ID',
  `parent_comment_id` BIGINT DEFAULT NULL COMMENT '부모 댓글 ID (NULL이면 원댓글)',
  `content` TEXT NOT NULL COMMENT '댓글 내용',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`post_id`) REFERENCES `missing_posts`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`parent_comment_id`) REFERENCES `missing_post_comments`(`id`) ON DELETE CASCADE
);

--9. 채팅방 정보 테이블
CREATE TABLE chat_rooms (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  user1_id int(11) NOT NULL,
  user2_id int(11) NOT NULL,
  type enum('ADOPTION','VET') NOT NULL,
  related_id bigint(20) NOT NULL,
  created_at datetime DEFAULT current_timestamp(),
  PRIMARY KEY (id),
  UNIQUE KEY unique_chat (user1_id,user2_id,type,related_id),
  KEY user2_id (user2_id),
  CONSTRAINT chat_rooms_ibfk_1 FOREIGN KEY (user1_id) REFERENCES users (id),
  CONSTRAINT chat_rooms_ibfk_2 FOREIGN KEY (user2_id) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--10. 채팅 메세지 저장 테이블 
CREATE TABLE chat_messages (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  room_id bigint(20) NOT NULL,
  sender_id int(11) NOT NULL,
  message text NOT NULL,
  sent_at datetime DEFAULT current_timestamp(),
  PRIMARY KEY (id),
  KEY room_id (room_id),
  KEY sender_id (sender_id),
  CONSTRAINT chat_messages_ibfk_1 FOREIGN KEY (room_id) REFERENCES chat_rooms (id),
  CONSTRAINT chat_messages_ibfk_2 FOREIGN KEY (sender_id) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--11. ai 예측 테이블
CREATE TABLE ai_predictions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    post_type VARCHAR(20) NOT NULL, -- 'missing' 또는 'witness'
    post_id BIGINT NOT NULL,        -- 실제 게시글의 id
    pet_id BIGINT,
    predicted_breed VARCHAR(50),
    predicted_color VARCHAR(50),
    breed_score FLOAT,
    color_score FLOAT,
    model_version VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- ✅ 복잡한 FK 대신 설명용 인덱스만 추가
    INDEX idx_post_type_id (post_type, post_id),

    -- ✅ missing_posts.id만 FK로 연결 (witness_posts는 별도 처리 필요)
    CONSTRAINT fk_ai_predictions_post
        FOREIGN KEY (post_id)
        REFERENCES missing_posts(id)
        ON DELETE CASCADE
);
