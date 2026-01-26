### Task 1: Create the Trigger Function

CREATE OR REPLACE FUNCTION log_product_changes()
RETURNS trigger AS $$
BEGIN
    -- Handle INSERT operations
    IF TG_OP = 'INSERT' THEN
        INSERT INTO products_audit (product_id, change_type, new_name, new_price)
        VALUES (NEW.product_id, 'INSERT', NEW.name, NEW.price);
        RETURN NEW;
    END IF;

    -- Handle DELETE operations
    IF TG_OP = 'DELETE' THEN
        INSERT INTO products_audit (product_id, change_type, old_name, old_price)
        VALUES (OLD.product_id, 'DELETE', OLD.name, OLD.price);
        RETURN OLD;
    END IF;

    -- Handle UPDATE operations
    IF TG_OP = 'UPDATE' THEN
        -- Only log if the name or price has changed
        IF NEW.name IS DISTINCT FROM OLD.name OR NEW.price IS DISTINCT FROM OLD.price THEN
            INSERT INTO products_audit (
                product_id,
                change_type,
                old_name,
                new_name,
                old_price,
                new_price
            ) VALUES (
                OLD.product_id,
                'UPDATE',
                OLD.name,
                NEW.name,
                OLD.price,
                NEW.price
            );
        END IF;
        RETURN NEW;
    END IF;

    -- Should never reach here
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;



### Task 2: Create the Trigger Definition

CREATE TRIGGER product_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON products
FOR EACH ROW
EXECUTE FUNCTION log_product_changes();



### Task 3: Test Your Trigger

INSERT INTO products (name, description, price, stock_quantity)
VALUES ('Miniature Thingamabob', 'A very small thingamabob.', 4.99, 500);

UPDATE products
SET price = 225.00, name = 'Mega Gadget v2'
WHERE name = 'Mega Gadget';

UPDATE products
SET description = 'An even simpler gizmo for all your daily tasks.'
WHERE name = 'Basic Gizmo';

DELETE FROM products
WHERE name = 'Super Widget';

SELECT * FROM products_audit ORDER BY audit_id;



### Task 4: Verify the Results

SELECT * FROM products_audit ORDER BY audit_id;



-- BONUS CHALLENGE

1. 

CREATE OR REPLACE FUNCTION set_last_modified()
RETURNS trigger AS $$
BEGIN
    -- Update the last_modified column to the current timestamp
    NEW.last_modified := NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


2. 

CREATE TRIGGER set_last_modified_trigger
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION set_last_modified();


3. 

-- Check current last_modified values
SELECT product_id, name, last_modified FROM products;

-- Update a product
UPDATE products
SET price = 250.00
WHERE name = 'Mega Gadget v2';

-- Check that last_modified is updated automatically
SELECT product_id, name, price, last_modified FROM products;



