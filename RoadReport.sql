CREATE DATABASE RoadReport
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Indonesian_Indonesia.1252'
    LC_CTYPE = 'Indonesian_Indonesia.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

--A table to store user details
CREATE TABLE Users (
	id SERIAL PRIMARY KEY,
  	username VARCHAR,
  	password VARCHAR,
	created_at TIMESTAMP
);

--A table to store route information
CREATE TABLE Routes (
	id SERIAL PRIMARY KEY,
	user_id INTEGER REFERENCES users(id),
	name VARCHAR(255),
	distance FLOAT,
	start_elevation INTEGER,
	end_elevation INTEGER
);

--A table to store the photo information associated with the routes
CREATE TABLE RoutePhotos (
	id SERIAL PRIMARY KEY,
	route_id INTEGER REFERENCES routes(id),
  	filename VARCHAR,
  	caption VARCHAR
);

--A table to store information about the regions
CREATE TABLE regions (
    id SERIAL PRIMARY KEY,
    name VARCHAR,
    description TEXT
);

--REGION_ID to link routes with associated regions
ALTER TABLE routes ADD COLUMN region_id INTEGER REFERENCES regions(id);

--CREATE INDEX idx_routes_region_id ON routes(region_id);

--A tabel to store route difficulty level details
CREATE TABLE levels (
    id SERIAL PRIMARY KEY,
    name VARCHAR,
    description TEXT
);
--LEVEL_ID to associate each route with the corresponding difficulty level
ALTER TABLE routes ADD COLUMN level_id INTEGER REFERENCES levels(id);

--store procedure
CREATE OR REPLACE PROCEDURE InsertRouteWithPhotos(
    p_route_name VARCHAR,
    p_route_length DECIMAL(9, 2),
    p_starting_elevation DECIMAL(9, 2),
    p_ending_elevation DECIMAL(9, 2),
    p_region_id INTEGER,
    p_level_id INTEGER,
    p_photos JSON[]
)
LANGUAGE plpgsql
AS $$
DECLARE
    route_id INTEGER;
BEGIN
    -- Insert data into 'routes' table
    INSERT INTO routes (route_name, route_length, starting_elevation, ending_elevation, region_id, level_id)
    VALUES (p_route_name, p_route_length, p_starting_elevation, p_ending_elevation, p_region_id, p_level_id)
    RETURNING id INTO route_id;

    -- Insert data into 'photos' table for the corresponding route_id
    IF array_length(p_photos, 1) IS NOT NULL THEN
        FOR i IN 1..array_length(p_photos, 1) LOOP
            INSERT INTO photos (route_id, filename, caption)
            VALUES (route_id, p_photos[i]->>'filename', p_photos[i]->>'caption');
        END LOOP;
    END IF;
END;
$$;

CALL InsertRouteWithPhotos(
    'Rute Mendaki Gunung XYZ',
    10.5,
    800,
    2000,
    1, -- region_id
    2, -- level_id
    '[{"filename": "foto1.jpg", "caption": "Pemandangan indah di puncak"}, {"filename": "foto2.jpg", "caption": "Istirahat di pos 1"}]'
);

CREATE OR REPLACE FUNCTION update_last_updated()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_updated = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER routes_update_last_updated
BEFORE UPDATE ON routes
FOR EACH ROW
EXECUTE FUNCTION update_last_updated();



