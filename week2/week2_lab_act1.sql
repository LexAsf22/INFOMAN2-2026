-- Activity 1: Calculate Flight Duration (Function)

CREATE FUNCTION get_flight_duration_bench(p_flight_id INT)
RETURNS INTERVAL AS $$
DECLARE
    v_duration INTERVAL;
BEGIN
    SELECT arrival_time - departure_time
    INTO v_duration
    FROM flights
    WHERE flight_id = p_flight_id;

    RETURN v_duration;
END;
$$ LANGUAGE plpgsql;


SELECT flight_number,
       get_flight_duration_bench(flight_id) AS duration
FROM flights
WHERE flight_number = 'SA201';


-- Activity 2: Categorize Flight Prices (Control Flow)

CREATE OR REPLACE FUNCTION get_price_category(p_flight_id INT)
RETURNS TEXT AS $$
DECLARE
    v_price NUMERIC;
BEGIN
    SELECT base_price
    INTO v_price
    FROM flights
    WHERE flight_id = p_flight_id;

    IF v_price < 300 THEN
        RETURN 'Budget';
    ELSIF v_price BETWEEN 300 AND 800 THEN
        RETURN 'Standard';
    ELSE
        RETURN 'Premium';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT flight_number,
       base_price,
       get_price_category(flight_id) AS price_category
FROM flights;


-- Activity 3: Book a Flight (Procedure)

CREATE OR REPLACE PROCEDURE book_flight(
    p_passenger_id INT,
    p_flight_id INT,
    p_seat_number VARCHAR
)
AS $$
BEGIN
    INSERT INTO bookings (
        passenger_id,
        flight_id,
        seat_number,
        status,
        booking_date
    )
    VALUES (
        p_passenger_id,
        p_flight_id,
        p_seat_number,
        'Confirmed',
        CURRENT_DATE
    );
END;
$$ LANGUAGE plpgsql;

SELECT COUNT(*) FROM bookings WHERE flight_id = 1;

CALL book_flight(3, 1, '14C');

SELECT COUNT(*) FROM bookings WHERE flight_id = 1;


-- Activity 4: Update Prices by Airline (Loop)

CREATE OR REPLACE PROCEDURE increase_prices_for_airline(
    p_airline_id INT,
    p_percentage_increase NUMERIC
)
AS $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN
        SELECT flight_id, base_price
        FROM flights
        WHERE airline_id = p_airline_id
    LOOP
        UPDATE flights
        SET base_price = rec.base_price * (1 + p_percentage_increase / 100)
        WHERE flight_id = rec.flight_id;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


-- Before
SELECT flight_number, base_price
FROM flights
WHERE airline_id = 1;

-- Apply 10% increase
CALL increase_prices_for_airline(1, 10);

-- After
SELECT flight_number, base_price
FROM flights
WHERE airline_id = 1;