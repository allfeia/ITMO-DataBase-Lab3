CREATE OR REPLACE FUNCTION compare_planet_color()
RETURNS TRIGGER AS $$
BEGIN
    DECLARE
        exist_color TEXT;

    BEGIN
        SELECT planet_color INTO exist_color
        FROM Observation
        WHERE time < NEW.time
        ORDER BY time DESC;

        IF exist_color <> NEW.planet_color THEN
            INSERT INTO Action (description, observation_id)
            VALUES ('Цвет планеты изменился', NEW.id);
        END IF;

        RETURN NEW;
    END;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER compare_color_trigger
AFTER INSERT ON Observation
FOR EACH ROW
EXECUTE FUNCTION compare_planet_color();
