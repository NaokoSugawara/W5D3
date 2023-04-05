PRAGMA foreign_keys = ON;

-- dropping any existing tables
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;


CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    follower_id INTEGER NOT NULL,
    question_followed_id INTEGER NOT NULL,

    FOREIGN KEY (follower_id) REFERENCES users(id)
    FOREIGN KEY (question_followed_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    reply TEXT NOT NULL,
    subject_question_id INTEGER NOT NULL,
    parent_reply_id INTEGER,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    liked_user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id)
    FOREIGN KEY (liked_user_id) REFERENCES users(id)
);


INSERT INTO 
    users (fname, lname)
VALUES
    ('Minion', 'Kevin'),
    ('Bobs', 'Tim'),
    ('Bello', 'Bob');

INSERT INTO 
    questions (title, body, author_id)
VALUES
    ('SQL', 'I dont know how to use sql!', 1),
    ('Rails', 'Is this about train rails?', 2),
    ('Rails2', 'Shou shou po pooo ~', 2);

INSERT INTO
    question_follows (follower_id, question_followed_id)
VALUES
    (3, 2),
    (2, 1);

INSERT INTO
    replies (reply, subject_question_id, parent_reply_id, author_id)
VALUES
    ("Of course. It's about trains^o^", 2, NULL,3),
    ("Nooooo. It's NOT about trains!!", 2, 1, 1),
    ("Hmmmm, do you is it a new name for Bananas?", 2, 1, 2);
    
INSERT INTO
    question_likes (question_id, liked_user_id)
VALUES
    (2, 2),
    (3, 1);