CREATE OR REPLACE FUNCTION new_observation()
RETURNS TRIGGER AS $new_observation$
BEGIN
INSERT INTO Observation (time, view_id, planet_color)
SELECT NOW(), View.id, Planet.name
FROM View
JOIN Place ON Place.id = View.place_id
JOIN Planet ON Place.description = NEW.description
WHERE View.field_of_view = NEW.field_of_view;
RETURN NEW;
END;
$new_observation$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER after_action
AFTER INSERT ON action
FOR EACH ROW EXECUTE FUNCTION new_observation();
