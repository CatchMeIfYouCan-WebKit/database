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

-- 2. shelter_animal_announcements (보호소 실종동물 공고)
CREATE TABLE `shelter_animal_announcements` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '식별자',
  `announcement_no` VARCHAR(50) NOT NULL COMMENT '공고번호',
  `animal_type` VARCHAR(20) NOT NULL COMMENT '동물종류',
  `breed` VARCHAR(50) NOT NULL COMMENT '품종',
  `coat_color` VARCHAR(100) NOT NULL COMMENT '털색',
  `gender` ENUM('수컷','암컷','미상') NOT NULL COMMENT '성별',
  `neutered` ENUM('예','아니오') NOT NULL DEFAULT '아니오' COMMENT '중성화 여부',
  `characteristics` TEXT COMMENT '특징',
  `rescue_date` DATE NOT NULL COMMENT '구조일',
  `rescue_reason` VARCHAR(200) DEFAULT NULL COMMENT '구조사유',
  `rescue_location` VARCHAR(200) NOT NULL COMMENT '구조장소',
  `announce_start` DATE NOT NULL COMMENT '공고 시작일',
  `announce_end` DATE NOT NULL COMMENT '공고 종료일',
  `shelter_name` VARCHAR(100) NOT NULL COMMENT '보호센터명',
  `representative` VARCHAR(50) NOT NULL COMMENT '대표자',
  `address` VARCHAR(255) NOT NULL COMMENT '주소',
  `phone` VARCHAR(20) NOT NULL COMMENT '전화번호',
  `remarks` TEXT COMMENT '그 밖의 사항',
  `image_url` VARCHAR(255) COMMENT '이미지 URL',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_announcement_no` (`announcement_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='유기 동물 공고 정보';

-- 3. shelter_adoption_animals (보호소 입양동물)
CREATE TABLE `shelter_adoption_animals` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '식별자',
  `announcement_no` VARCHAR(50) NOT NULL COMMENT '공고번호',
  `animal_reg_no` VARCHAR(50) DEFAULT NULL COMMENT '동물등록번호',
  `breed` VARCHAR(100) NOT NULL COMMENT '품종',
  `color` VARCHAR(100) NOT NULL COMMENT '색상',
  `gender` ENUM('수컷','암컷','미상') NOT NULL COMMENT '성별',
  `neutered` ENUM('예','아니오') NOT NULL DEFAULT '아니오' COMMENT '중성화 여부',
  `age_weight` VARCHAR(100) NOT NULL COMMENT '나이/체중',
  `rescue_characteristics` TEXT COMMENT '구조 시 특징',
  `social_characteristics` TEXT COMMENT '특징(사회성)',
  `health_characteristics` TEXT COMMENT '특징(건강)',
  `health_checkup` TEXT COMMENT '건강검진 결과',
  `vaccination_status` TEXT COMMENT '접종 상태',
  `occurrence_place` VARCHAR(200) COMMENT '발생장소',
  `reception_datetime` DATETIME NOT NULL COMMENT '접수일시',
  `other_notes` TEXT COMMENT '기타사항',
  `jurisdiction` VARCHAR(100) COMMENT '관할기관',
  `status` VARCHAR(50) NOT NULL COMMENT '상태',
  `shelter_name` VARCHAR(100) COMMENT '보호센터명',
  `shelter_contact` VARCHAR(20) COMMENT '보호센터 연락처',
  `protection_location` VARCHAR(200) COMMENT '보호장소',
  `adoption_procedure` TEXT COMMENT '입양 절차',
  `adoption_support` TEXT COMMENT '입양 지원',
  `volunteer_info` TEXT COMMENT '봉사 안내',
  `event_info` TEXT COMMENT '행사 안내',
  `image_urls` TEXT COMMENT '이미지 URL 목록 (세미콜론 구분)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_announcement_no` (`announcement_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='보호소에서 입양 보낼 동물 정보';

-- 4. pet (반려동물 등록)
CREATE TABLE `pet` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `photo_path` VARCHAR(500) NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `breed` VARCHAR(50) NOT NULL,
  `coat_color` VARCHAR(50),
  `is_neutered` TINYINT(1) NOT NULL DEFAULT 0,
  `date_of_birth` DATE NOT NULL,
  `age` INT,
  `weight` DECIMAL(5,2),
  `registration_number` VARCHAR(100) NOT NULL UNIQUE,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
);

-- 5. missing_posts (실종/목격 게시물)
CREATE TABLE `missing_posts` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `pet_id` INT NOT NULL,
  `post_type` ENUM('missing','witness') NOT NULL DEFAULT 'missing',
  `photo_url` VARCHAR(255),
  `missing_datetime` DATETIME NOT NULL,
  `missing_location` VARCHAR(255) NOT NULL,
  `detail_description` TEXT,
  `comments` TEXT,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  FOREIGN KEY (`pet_id`) REFERENCES `pet`(`id`)
);

-- 6. adopt_posts (입양 게시판)
CREATE TABLE `adopt_posts` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `pet_id` INT NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `is_vet_verified` TINYINT(1) NOT NULL DEFAULT 0,
  `comments` TEXT,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  FOREIGN KEY (`pet_id`) REFERENCES `pet`(`id`)
);

-- 7. animal_hospitals (동물병원 정보)
CREATE TABLE `animal_hospitals` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '고유 ID',
  `name` VARCHAR(200) NOT NULL COMMENT '병원명',
  `phone` VARCHAR(20) COMMENT '전화번호',
  `address` VARCHAR(255) COMMENT '소재지',
  `license_number` VARCHAR(50) NOT NULL UNIQUE COMMENT '인허가번호',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='동물병원 정보';
