CREATE OR REPLACE FUNCTION compare_planet_color()
RETURNS TRIGGER AS $$
BEGIN
    DECLARE
        old_color TEXT;
        new_color TEXT;
    BEGIN
        old_color := (SELECT planet_color FROM Observation WHERE id = OLD.id);
        new_color := (SELECT planet_color FROM Observation WHERE id = NEW.id);

        IF old_color <> new_color THEN
            INSERT INTO Action (description, observation_id)
            VALUES ('Цвет планеты изменился', NEW.id);
        END IF;
        
        RETURN NEW;
    END;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER compare_color_trigger
AFTER UPDATE OF planet_color ON Observation
FOR EACH ROW
EXECUTE FUNCTION compare_planet_color();
