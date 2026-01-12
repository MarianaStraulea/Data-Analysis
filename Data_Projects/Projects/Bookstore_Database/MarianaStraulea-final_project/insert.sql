INSERT INTO `users` (`first_name`, `last_name`, `username`, `email`, `password_hash`, `country`, `address`, `phone_number`)
VALUES
    ('Alice', 'Johnson', 'alicej', 'alice.johnson@example.com', 'hashed_password_1', 'USA', '123 Main St, New York', '+1234567890'),
    ('Bob', 'Smith', 'bobsmith', 'bob.smith@example.com', 'hashed_password_2', 'UK', '456 High St, London', '+447700900800'),
    ('Charlie', 'Brown', 'charlieb', 'charlie.brown@example.com', 'hashed_password_3', 'Canada', '789 Maple St, Toronto', '+14165551234'),
    ('Diana', 'Evans', 'dianae', 'diana.evans@example.com', 'hashed_password_4', 'Germany', '123 Berliner Str, Berlin', '+4915112345678'),
    ('Ethan', 'Miller', 'ethanm', 'ethan.miller@example.com', 'hashed_password_5', 'France', '78 Rue Lafayette, Paris', '+33123456789');

INSERT INTO `books` (`name`, `price`)
VALUES
    ('The Great Gatsby', 12.99),
    ('1984', 9.99),
    ('To Kill a Mockingbird', 14.50),
    ('Moby-Dick', 18.75),
    ('Pride and Prejudice', 11.25);

INSERT INTO `authors` (`name`, `birth_year`)
VALUES
    ('F. Scott Fitzgerald', 1896),
    ('George Orwell', 1903),
    ('Harper Lee', 1926),
    ('Herman Melville', 1819),
    ('Jane Austen', 1775);


INSERT INTO `book_author` (`book_id`, `author_id`)
VALUES
    (1, 1),  -- The Great Gatsby by F. Scott Fitzgerald
    (2, 2),  -- 1984 by George Orwell
    (3, 3),  -- To Kill a Mockingbird by Harper Lee
    (4, 4),  -- Moby-Dick by Herman Melville
    (5, 5);  -- Pride and Prejudice by Jane Austen


INSERT INTO `genres` (`genre`)
VALUES
    ('Classic'),
    ('Dystopian'),
    ('Historical Fiction'),
    ('Adventure'),
    ('Romance');


INSERT INTO `book_genre` (`book_id`, `genre_id`)
VALUES
    (1, 1),  -- The Great Gatsby is a Classic
    (2, 2),  -- 1984 is Dystopian
    (3, 3),  -- To Kill a Mockingbird is Historical Fiction
    (4, 4),  -- Moby-Dick is an Adventure
    (5, 5);  -- Pride and Prejudice is Romance


INSERT INTO `inventory` (`book_id`, `stock_for_sale`, `stock_for_loan`)
VALUES
    (1, 10, 5),  -- 10 copies for sale, 5 for loan
    (2, 8, 4),
    (3, 12, 6),
    (4, 5, 3),
    (5, 15, 7);


INSERT INTO `acquisitions` (`book_id`, `for_sale`, `for_loan`, `amount`)
VALUES
    (1, TRUE, FALSE, 10),
    (2, TRUE, FALSE, 8),
    (3, TRUE, TRUE, 12),
    (4, FALSE, TRUE, 5),
    (5, TRUE, TRUE, 15);


INSERT INTO `loans` (`book_id`, `user_id`, `loan_date`, `returned`)
VALUES
    (1, 1, NOW(), FALSE),
    (2, 2, NOW(), FALSE),
    (3, 3, NOW(), TRUE),
    (4, 4, NOW(), FALSE),
    (5, 5, NOW(), TRUE);


INSERT INTO `purchases` (`book_id`, `user_id`, `purchase_date`)
VALUES
    (1, 2, NOW()),
    (2, 3, NOW()),
    (3, 4, NOW()),
    (4, 5, NOW()),
    (5, 1, NOW());


INSERT INTO `reviews` (`book_id`, `user_id`, `stars`, `comment`)
VALUES
    (1, 1, 5, 'A timeless classic!'),
    (2, 2, 4, 'A must-read dystopian novel.'),
    (3, 3, 5, 'A very impactful book.'),
    (4, 4, 3, 'A bit long, but a great adventure.'),
    (5, 5, 5, 'A beautiful romance.');


INSERT INTO `recommendations` (`book_id`, `user_id`)
VALUES
    (1, 3),
    (2, 4),
    (3, 5),
    (4, 1),
    (5, 2);
