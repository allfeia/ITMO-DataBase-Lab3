CREATE OR REPLACE FUNCTION compare_planet_color()
RETURNS TRIGGER AS $$
BEGIN
    DECLARE
        exist_color TEXT;

    BEGIN
        FOR exist_color IN
            SELECT planet_color FROM Observation WHERE id == NEW.id - 1
        LOOP
            IF exist_color <> NEW.planet_color THEN
                INSERT INTO Action (description, observation_id)
                VALUES ('Цвет планеты изменился', NEW.id);
                EXIT;
            END IF;
        END LOOP;

        RETURN NEW;
    END;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER compare_color_trigger
AFTER INSERT ON Observation
FOR EACH ROW
EXECUTE FUNCTION compare_planet_color();
