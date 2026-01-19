# Activity: Advanced PL/pgSQL for Airline Management

## Objective
Apply your knowledge of PL/pgSQL functions, procedures, control flow, and loops to build backend logic for a simple airline management system.

## Prerequisites
Before you begin, you must load the airline database schema and data. Execute the entire `airline_dataset.sql` script in your PostgreSQL database.

---

### Activity 1: Calculate Flight Duration (Function)

**Goal:** Create a SQL function that calculates the duration of a flight.

**Task:**
Write a PL/pgSQL function called `get_flight_duration` that accepts a flight ID and returns the flight's duration as an `INTERVAL`.

```sql
CREATE OR REPLACE FUNCTION get_flight_duration(p_flight_id INT)
RETURNS INTERVAL AS $$
-- Your code here
$$ LANGUAGE plpgsql;
```

**How to Test:**
You can call your function in a `SELECT` statement:
```sql
SELECT flight_number, get_flight_duration(flight_id) AS duration
FROM flights
WHERE flight_number = 'SA201';
-- Expected output for SA201 should be '12 hours'
```

---

### Activity 2: Categorize Flight Prices (Control Flow)

**Goal:** Use an `IF` statement to categorize flights based on their price.

**Task:**
Write a function called `get_price_category` that takes a flight ID, checks its `base_price`, and returns a `TEXT` category:
-   `'Budget'` if the price is less than $300.
-   `'Standard'` if the price is between $300 and $800 (inclusive).
-   `'Premium'` if the price is more than $800.

```sql
CREATE OR REPLACE FUNCTION get_price_category(p_flight_id INT)
RETURNS TEXT AS $$
-- Your code here
$$ LANGUAGE plpgsql;
```

**How to Test:**
```sql
SELECT flight_number, base_price, get_price_category(flight_id)
FROM flights;
```

---

### Activity 3: Book a Flight (Procedure)

**Goal:** Create a procedure to handle the action of booking a flight for a passenger.

**Task:**
Write a procedure `book_flight` that takes a passenger ID, a flight ID, and a desired seat number. The procedure should insert a new record into the `bookings` table with a 'Confirmed' status and the current date.

**Hint:** Unlike a function, a procedure does not return a value. It is called using the `CALL` command.

```sql
CREATE OR REPLACE PROCEDURE book_flight(
    p_passenger_id INT,
    p_flight_id INT,
    p_seat_number VARCHAR
) AS $$
-- Your code here
$$ LANGUAGE plpgsql;
```

**How to Test:**
```sql
-- First, check the number of bookings for flight 1
SELECT COUNT(*) FROM bookings WHERE flight_id = 1;
-- Then, call the procedure to book a new seat
CALL book_flight(3, 1, '14C');
-- Finally, check the count again to see if it increased
SELECT COUNT(*) FROM bookings WHERE flight_id = 1;
```

---

### Activity 4: Update Prices by Airline (Loop)

**Goal:** Use a `FOR` loop to iterate through a query's results and perform an update.

**Task:**
Create a procedure `increase_prices_for_airline` that accepts an airline ID and a percentage increase. The procedure should find all flights belonging to that airline and increase their `base_price` by the given percentage.

**Hint:** You can declare a record variable to hold each row from the `SELECT` query inside the loop.

```sql
CREATE OR REPLACE PROCEDURE increase_prices_for_airline(
    p_airline_id INT,
    p_percentage_increase NUMERIC
) AS $$
-- Your code here
$$ LANGUAGE plpgsql;
```

**How to Test:**
```sql
-- View prices for Gemini Air (airline_id = 1) before the change
SELECT flight_number, base_price FROM flights WHERE airline_id = 1;

-- Apply a 10% price increase
CALL increase_prices_for_airline(1, 10.0);

-- View the prices again to confirm they have been updated
SELECT flight_number, base_price FROM flights WHERE airline_id = 1;
```

---

## Additional Hints & Concepts Not Covered in Slides

*   **Data Types:** While the slides use `NUMERIC`, `TEXT`, `DATE`, and `INT`, PostgreSQL offers many more. Try using `VARCHAR(n)` for fixed-length strings, `BOOLEAN` for true/false flags, or `TIMESTAMP` for date and time. The `INTERVAL` type used in Activity 1 is perfect for representing durations.
*   **Debugging:** Inside a function or procedure, you can print messages to the server log using `RAISE NOTICE 'My message here: %', some_variable;`. This is incredibly useful for debugging your logic.
*   **Parameters:** Functions can have `IN` (default), `OUT`, and `INOUT` parameters. `OUT` parameters are another way for a function to return multiple values.
*   **Records:** The `RECORD` type is a placeholder for a row result. You can also create your own composite `TYPE` if you need a specific structure for a variable.