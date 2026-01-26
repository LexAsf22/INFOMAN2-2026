# Week 1 Lab Activity: MySQL to PostgreSQL Migration

## Objective
This lab will guide you through the process of migrating a simple database schema from MySQL to PostgreSQL. You will adapt the schema, create the tables in PostgreSQL using the `psql` command-line tool, and load it with initial data.

---

### Part 1: The Scenario

You are tasked with migrating a small blog's database from a MySQL server to a new PostgreSQL server. You have been provided with the original MySQL schema and the data to be inserted.

---

### Part 2: The Original MySQL Schema

Below is the script used to create the tables in MySQL. Notice the use of `AUTO_INCREMENT` and the `DATETIME` data type.

```sql
-- Original MySQL Schema
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    comment TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

---

### Part 3: Your Task - Migration to PostgreSQL

Create a new file named `blog_schema_postgres.sql`. In this file, you will write the equivalent schema for PostgreSQL.

**Key changes to make:**

1.  **Auto-incrementing Keys**: PostgreSQL does not have `AUTO_INCREMENT`. The equivalent is the `SERIAL` data type. Change `INT AUTO_INCREMENT PRIMARY KEY` to `SERIAL PRIMARY KEY`.
2.  **Date and Time**: The standard SQL data type for date and time is `TIMESTAMP`. Replace all instances of `DATETIME` with `TIMESTAMP`.

Your task is to rewrite the schema from Part 2, applying these changes to make it compatible with PostgreSQL.

---

### Part 4: Creating the Database and Importing the Schema

You will use the PostgreSQL command-line interface, `psql`, to perform these steps.

**Step 4.1: Create the Database**

First, open your terminal and create a new database. You can name it `week1_lab`.

```bash
# Make sure your postgres server is running
createdb week1_lab
```
*If the `createdb` command is not available in your path, you can use `psql` to run the command:*
```bash
psql -U your_username -c "CREATE DATABASE week1_lab;"
```

**Step 4.2: Import the SQL File with psql**

Once you have your `blog_schema_postgres.sql` file ready, you can execute it against your new database. This command connects to the `week1_lab` database and runs the script from your file.

```bash
# General syntax: psql -d database_name -f /path/to/your/file.sql
psql -d week1_lab -f blog_schema_postgres.sql
```
This will create the `users`, `posts`, and `comments` tables inside your `week1_lab` database. You can verify this by connecting to the database (`psql -d week1_lab`) and using the `\dt` command to list the tables.

---

### Part 5: Loading the Data

After creating the schema, you need to populate the tables. Add the following `INSERT` statements to the **end** of your `blog_schema_postgres.sql` file and re-run the import command from Step 4.2.

```sql
-- Data for the tables
INSERT INTO users (username) VALUES ('alice'), ('bob');

INSERT INTO posts (user_id, title, body) VALUES
(1, 'First Post!', 'This is the body of the first post.'),
(2, 'Bob''s Thoughts', 'A penny for my thoughts.');

INSERT INTO comments (post_id, user_id, comment) VALUES
(1, 2, 'Great first post, Alice!'),
(2, 1, 'Interesting thoughts, Bob.');

```

### Deliverable
A single SQL file named `blog_schema_postgres.sql` containing the corrected `CREATE TABLE` statements for PostgreSQL and the `INSERT` statements for populating the data.