-- A database for an online library where users can either loan or buy books.
-- Represents users accounts and user informations
CREATE TABLE `users`(
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(34) NOT NULL,
    `last_name` VARCHAR(34) NOT NULL,
    `username` VARCHAR(64) NOT NULL UNIQUE,
    `email` VARCHAR(128) NOT NULL UNIQUE,
    `password_hash` VARCHAR(128) NOT NULL,
    `country` VARCHAR(64),
    `address` VARCHAR(128) ,
    `phone_number` VARCHAR(15) DEFAULT NULL,
    INDEX `username_index` (`username`),  -- Create index on username and email address for easy query
    INDEX `user_email_index` (`email`)
);

-- Represents all the books within the library
CREATE TABLE `books` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(64) NOT NULL,
    `price` DECIMAL (10, 2) DEFAULT NULL,
    INDEX `book_title_index` (`name`) -- Create index on book name for easy lookup
);

-- Inventory for the books
CREATE TABLE `inventory` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `book_id` INT NOT NULL,
    `stock_for_sale` TINYINT NOT NULL DEFAULT 0,
    `stock_for_loan` TINYINT NOT NULL DEFAULT 0,
    FOREIGN KEY (`book_id`) REFERENCES `books`(`id`) ON DELETE CASCADE,
    INDEX `inventory_book_id_index` (`book_id`)
);

-- Represents the authors of the books
CREATE TABLE `authors` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `birth_year` SMALLINT(4) NOT NULL,
    `name` VARCHAR(64) NOT NULL,        -- author name
    INDEX `book_author_index` (`name`)  -- Create index on authors name for faster query
);

-- Many-to-Many relationship for book authors
CREATE TABLE `book_author` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `book_id` INT,
    `author_id` INT,      -- a book can have more than one author
    FOREIGN KEY (`book_id`) REFERENCES `books`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`author_id`) REFERENCES `authors`(`id`) ON DELETE CASCADE,
    INDEX `book_author_book_id_index` (`book_id`),
    INDEX `book_author_id_index` (`author_id`)
);

-- Represents book genres
CREATE TABLE `genres` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `genre` VARCHAR(64) NOT NULL UNIQUE,
    INDEX `book_genre_index` (`genre`) -- Create index on genre for easy filtering
);

-- Many-to-Many relationship representing book genres
CREATE TABLE `book_genre` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `book_id` INT NOT NULL,
    `genre_id` INT NOT NULL,       -- a book can have multiple genres
    FOREIGN KEY (`book_id`) REFERENCES `books`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`genre_id`) REFERENCES `genres`(`id`) ON DELETE CASCADE,
    INDEX `book_genre_genre_id` (`genre_id`),
    INDEX `book_genre_book_id` (`book_id`)
);

-- Represents the history of all the transactions (sold, bought)
CREATE TABLE `acquisitions` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `book_id` INT NOT NULL,
    `for_sale` BOOLEAN NOT NULL DEFAULT FALSE,       -- speciefies wheter the book was bought to be sold
    `for_loan` BOOLEAN NOT NULL DEFAULT FALSE,     -- or for loaning purposes
    `amount` TINYINT NOT NULL DEFAULT 0,    -- how many books were bought
    `datetime` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`book_id`) REFERENCES `books`(`id`)  ON DELETE CASCADE,
    INDEX `book_id_aquisition_index` (`book_id`)
);

-- Represents the loans history
CREATE TABLE `loans` ( 
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `book_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `loan_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,     -- the date when the book was borrowed
    `return_date` TIMESTAMP DEFAULT NULL,   -- the date when the book was returned
    `returned` BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (`book_id`) REFERENCES `books`(`id`)  ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)  ON DELETE CASCADE,
    INDEX `user_id_book_id_loan_history_index` (`user_id`, `book_id`)
);

-- Represents the purchase history
CREATE TABLE `purchases` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `book_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `purchase_date` TIMESTAMP DEFAULT NULL,     -- the date when the book was purchased
    FOREIGN KEY (`book_id`) REFERENCES `books`(`id`)  ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)  ON DELETE CASCADE,
    INDEX `user_id_book_id_purchase_history_index` (`user_id`, `book_id`)
);

-- Represents the user reviews
CREATE TABLE `reviews` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `book_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `stars` TINYINT NOT NULL CHECK(`stars` BETWEEN 1 AND 5),
    `comment` TEXT DEFAULT NULL,
    `datetime` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`book_id`) REFERENCES `books`(`id`)  ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)  ON DELETE CASCADE,
    INDEX `user__book_id_review_index` (`user_id`, `book_id`)
);

-- Represents recommandations for users based on past prefferences
CREATE TABLE `recommendations` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `book_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    FOREIGN KEY (`book_id`) REFERENCES `books`(`id`)  ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)  ON DELETE CASCADE
);

-- Add triggers

-- Change the delimiter
DELIMITER //

-- Updates the inventary table when books are acquisitioned
CREATE TRIGGER `after_acquisition_insert_trigger`
AFTER INSERT ON `acquisitions`
FOR EACH ROW
BEGIN
    -- If the book already exists in the inventary, update the stock
    DECLARE book_exists INT;
    SELECT COUNT(*) INTO book_exists FROM `inventory` WHERE `book_id` = NEW.book_id;

    IF book_exists > 0 THEN
        UPDATE `inventory`
        SET
        `stock_for_sale` = `stock_for_sale` + IF(NEW.for_sale, NEW.amount, 0),  -- if the book is for sale, this value is changed
        `stock_for_loan` = `stock_for_loan` + IF(NEW.for_loan, NEW.amount, 0)  -- if the book is for loan, this value is changed
        WHERE `book_id` = NEW.book_id;
    ELSE
    -- If the book does not exist in the inventory, insert a new record
        INSERT INTO `inventory`(`book_id`, `stock_for_sale`, `stock_for_loan`)
        VALUES (NEW.book_id,
                IF(NEW.for_sale, NEW.amount, 0),    -- if the book is for sale, this value is changed
                IF(NEW.for_loan, NEW.amount, 0)
                );    -- if the book is for loan, this value is changed
    END IF;
END //


-- Updates the inventary table when books are sold
CREATE TRIGGER `after_purchase_insert_trigger`
AFTER INSERT ON `purchases`
FOR EACH ROW
BEGIN
    UPDATE `inventory`
    SET
    `stock_for_sale` = `stock_for_sale` - 1
    WHERE `book_id` = NEW.book_id AND `stock_for_sale` > 0;
END //


-- A trigger that prevents book purchases if the stock is 0
CREATE TRIGGER `before_purchase_insert_trigger`
BEFORE INSERT ON `purchases`
FOR EACH ROW
BEGIN
    -- initialize a variable
    DECLARE available_stock INT;

    -- SELECT the current stock for sale
    SELECT `stock_for_sale` INTO available_stock FROM `inventory` WHERE `book_id` = NEW.book_id;

    -- If there are no books available, raise an error
    IF available_stock = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The selected book is out of stock.';
    END IF;
END //


-- Updates the inventary table when books are loaned
CREATE TRIGGER `after_loan_insert_trigger`
AFTER INSERT ON `loans`
FOR EACH ROW
BEGIN
    UPDATE `inventory`
    SET
    `stock_for_loan` = `stock_for_loan` - 1
    WHERE `book_id` = NEW.book_id AND `stock_for_loan` > 0;
END //


-- A trigger that prevents book loans if the stock is 0
CREATE TRIGGER `before_purchase_insert_trigger`
BEFORE INSERT ON `loans`
FOR EACH ROW
BEGIN
    -- initialize a variable
    DECLARE available_stock INT;

    -- SELECT the current stock for sale
    SELECT `stock_for_loan` INTO available_stock FROM `inventory` WHERE `book_id` = NEW.book_id;

    -- If there are no books available, raise an error
    IF available_stock = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The selected book is out of stock.';
    END IF;
END //


-- Update the inventory table when a book is returned
CREATE TRIGGER `after_loan_update_trigger`
AFTER UPDATE ON `loans`
FOR EACH ROW
BEGIN
    -- only update stock if the book is marked as returned
    IF OLD.returned = FALSE AND NEW.returned = TRUE THEN
        UPDATE `inventory`
        SET
        `stock_for_loan` = `stock_for_loan` + 1
        WHERE `book_id` = NEW.book_id;
    END IF;
END //

-- Change back the delimiter
DELIMITER ;


-- Create view with all the available books
CREATE VIEW `available_books` AS
SELECT
    `books`.`id` AS `id`,
    `books`.`name` AS `title`,
    `books`.`price` AS `price`,
    GROUP_CONCAT(DISTINCT `authors`.`name` SEPARATOR ', ') AS `authors`,
    GROUP_CONCAT(DISTINCT `genres`.`genre` SEPARATOR ', ') AS `genres`,
    COALESCE(`inventory`.`stock_for_sale`, 0) AS `available_for_sale`,
    COALESCE(`inventory`.`stock_for_loan`, 0) AS `available_for_loan`
FROM `books`
LEFT JOIN `inventory` ON `books`.`id` = `inventory`.`book_id`
LEFT JOIN `book_author` ON `books`.`id` = `book_author`.`book_id`
LEFT JOIN `authors` ON `book_author`.`author_id` = `authors`.`id`
LEFT JOIN `book_genre` ON `books`.`id` = `book_genre`.`book_id`
LEFT JOIN `genres` ON `book_genre`.`genre_id` = `genres`.`id`
WHERE COALESCE(`inventory`.`stock_for_loan`, 0) > 0 OR COALESCE(`inventory`.`stock_for_sale`, 0) > 0
GROUP BY `books`.`id`, `books`.`name`, `books`.`price`, COALESCE(`inventory`.`stock_for_sale`, 0), COALESCE(`inventory`.`stock_for_loan`, 0);
