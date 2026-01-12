-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- Add a new user
INSERT INTO `users`(`first_name`, `last_name`, `username`, `email`, `password_hash`, `country`, `address`, `phone_number`)
VALUES
    ('John', 'Doe', 'johndoe', 'john.doe@example.com', 'hashed_password_1', 'USA', '123 Main St, New York', '+1-555-1010');

-- Find all the available books in the library
SELECT * FROM `available_books`;

-- Add a new book in the book table
INSERT INTO `books`(`name`, `price`)
VALUES ('Good Omens', 15.99);

-- Add authors
INSERT INTO `authors`(`name`, `birth_year`)
VALUES ('Neil Gaiman', 1960),
       ('Terry Pratchett', 1948)
ON DUPLICATE KEY UPDATE `name` = `name`;

-- Ascociate the book with the authors
INSERT INTO `book_author`(`book_id`, `author_id`)
VALUES
((SELECT `id` FROM `books` WHERE `name` = 'Good Omens'),
 (SELECT `id` FROM `authors` WHERE `name` = 'Neil Gaiman')
),
((SELECT `id` FROM `books` WHERE `name` = 'Good Omens'),
 (SELECT `id` FROM `authors` WHERE `name` = 'Terry Pratchett')
);

-- Add new genres
INSERT INTO `genres`(`genre`)
VALUES
('Fantasy'),
('Comedy')
ON DUPLICATE KEY UPDATE `genre` = `genre`;

-- Asociate the book with it's genre/genres
INSERT INTO `book_genre`(`book_id`, `genre_id`)
VALUES
((SELECT `id` FROM `books` WHERE `name` = 'Good Omens'),
 (SELECT `id` FROM `genres` WHERE `genre` = 'Fantasy')
),
((SELECT `id` FROM `books` WHERE `name` = 'Good Omens'),
 (SELECT `id` FROM `genres` WHERE `genre` = 'Comedy')
);

-- Insert the aquisition record
INSERT INTO `acquisitions`(`book_id`, `for_sale`, `amount`)
VALUES
((SELECT `id` FROM `books` WHERE `name` = 'Good Omens'),
 TRUE, -- the book is purchased for selling purposes
 10  -- the stock that was bought
);

-- Find all purchases given user username
SELECT * FROM `purchases`
WHERE `user_id` = (
    SELECT `id` FROM `users`
    WHERE `username` = 'johndoe'
);

-- Find all the books a user has bought or loaned
SELECT `books`.`name` FROM `books`
JOIN `loans` ON `books`.`id` = `loans`.`book_id`
JOIN `purchases` ON `books`.`id` = `purchases`.`book_id`
WHERE `loans`.`user_id` =  (
    SELECT `id` FROM `users`
    WHERE `username` = 'alicej'
) OR `purchases`.`user_id` = (
    SELECT `id` FROM `users`
    WHERE `username` = 'alicej'
);

-- Find the genre/genres of a given book
SELECT `title`, `genres` FROM `available_books`
WHERE `title` = 'Pride and Prejudice';

-- Find the author/authors of a given book
SELECT `title`, `authors` FROM `available_books`
WHERE `title` = 'Good Omens';

-- Find all the reviews for a given book
SELECT `books`.`name` AS `title`, `reviews`.`stars` AS `rating`, `reviews`.`comment` AS `opinion` FROM `books`
JOIN `reviews` ON `books`.`id` = `reviews`.`book_id`
WHERE `books`.`id` = (
    SELECT `id` FROM `books`
    WHERE `name` = '1984'
);


-- Book recomendation based on past purchases
SELECT `books`.`name` AS `book_recommandation` FROM  `books`
JOIN `book_genre` ON `books`.`id` = `book_genre`.`book_id`
JOIN `genres` ON `book_genre`.`genre_id` =  `genres`.`id`
WHERE `books`.`name` NOT IN (
        SELECT `books`.`name` AS `title` FROM `books`
        JOIN `loans` ON `books`.`id` = `loans`.`book_id`
        JOIN `purchases` ON `books`.`id` = `purchases`.`book_id`
        WHERE `loans`.`user_id` =  (
            SELECT `id` FROM `users`
            WHERE `username` = 'alicej'
        ) OR `purchases`.`user_id` = (
            SELECT `id` FROM `users`
            WHERE `username` = 'alicej'
        )
)
AND `book_genre`.`book_id` IN (
        SELECT `books`.`id` AS `id` FROM `books`
        JOIN `loans` ON `books`.`id` = `loans`.`book_id`
        JOIN `purchases` ON `books`.`id` = `purchases`.`book_id`
        WHERE `loans`.`user_id` =  (
            SELECT `id` FROM `users`
            WHERE `username` = 'alicej'
        ) OR `purchases`.`user_id` = (
            SELECT `id` FROM `users`
            WHERE `username` = 'alicej'
        )
);
