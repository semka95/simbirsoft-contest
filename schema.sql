CREATE TABLE accounts(
  id bigserial PRIMARY KEY,
  first_name varchar(30) NOT NULL,
  last_name varchar(30) NOT NULL,
  email varchar(20) UNIQUE NOT NULL,
  password VARCHAR(30) NOT NULL
);

CREATE INDEX accounts_first_name_idx ON accounts(first_name);

CREATE INDEX accounts_last_name_idx ON accounts(last_name);

CREATE INDEX accounts_email_idx ON accounts(email);

CREATE TABLE locations(
  id bigserial PRIMARY KEY,
  lattitude double precision NOT NULL,
  longitude double precision NOT NULL
);

ALTER TABLE locations
  ADD CONSTRAINT unique_lattitude_and_longitude UNIQUE (lattitude, longitude);

CREATE TABLE animal_types(
  id bigserial PRIMARY KEY,
  animal_type varchar(30) UNIQUE NOT NULL
);

CREATE TYPE animal_gender AS ENUM(
  'MALE',
  'FEMALE',
  'OTHER'
);

CREATE TYPE animal_life_status AS ENUM(
  'ALIVE',
  'DEAD'
);

CREATE TABLE animals(
  id bigserial PRIMARY KEY,
  weight double precision NOT NULL,
  length double precision NOT NULL,
  height double precision NOT NULL,
  gender animal_gender NOT NULL,
  life_status animal_life_status NOT NULL DEFAULT 'ALIVE' CHECK (status <> 'DEAD' OR (status = 'DEAD' AND old.status = 'ALIVE')),
  chipping_date_time timestamp NOT NULL DEFAULT NOW(),
  chipper_id bigint NOT NULL REFERENCES accounts ON DELETE RESTRICT,
  chipping_location_id bigint NOT NULL REFERENCES locations ON DELETE RESTRICT,
  death_date_time timestamp
);

CREATE INDEX animals_chipping_date_time_idx ON animals(chipping_date_time);

CREATE INDEX animals_chipper_id_fk_idx ON animals(chipper_id);

CREATE INDEX animals_chipping_location_id_fk_idx ON animals(chipping_location_id);

CREATE INDEX animals_life_status_idx ON animals(life_status);

CREATE INDEX animals_gender_idx ON animals(gender);

CREATE OR REPLACE FUNCTION set_death_time()
  RETURNS TRIGGER
  AS $$
BEGIN
  IF NEW.life_status = 'DEAD' THEN
    NEW.death_time = NOW();
  END IF;
  RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER set_death_time_trigger
  BEFORE UPDATE ON animals
  FOR EACH ROW
  WHEN(OLD.life_status = 'ALIVE' AND NEW.life_status = 'DEAD')
  EXECUTE FUNCTION set_death_time();

CREATE TABLE animals_animal_types(
  animal_id bigint NOT NULL REFERENCES animals,
  animal_type_id bigint NOT NULL REFERENCES animal_types ON DELETE RESTRICT
);

-- CREATE INDEX animals_animal_types_animal_id_fk_idx ON accounts (animal_id);
-- CREATE INDEX animals_animal_types_animal_type_id_fk_idx ON accounts (animal_type_id);
CREATE INDEX animals_animal_types_animal_id_animal_type_id_fk_idx ON animals_animal_types(animal_id, animal_type_id);

ALTER TABLE animals_animal_types
  ADD CONSTRAINT unique_animal_type_per_animal UNIQUE (animal_id, animal_type_id);

CREATE TABLE animals_visited_locations(
  id bigserial PRIMARY KEY,
  date_time_of_visit_location_point timestamp NOT NULL DEFAULT NOW(),
  location_point_id bigint NOT NULL REFERENCES locations,
  animal_id bigint NOT NULL REFERENCES animals
);

CREATE INDEX animals_visited_locations_date_time_of_visit_location_point_idx ON animals_visited_locations(date_time_of_visit_location_point);

CREATE INDEX animals_visited_locations_animal_id_fk_idx ON animals_visited_locations(animal_id);

-- on insert triggers
CREATE OR REPLACE FUNCTION prevent_add_visited_location_point_for_dead_animal()
  RETURNS TRIGGER
  AS $$
BEGIN
  IF EXISTS(
    SELECT
      1
    FROM
      animals
    WHERE
      id = NEW.animal_id
      AND life_status = 'DEAD') THEN
  RAISE EXCEPTION 'Cannot add location point for dead animal';
END IF;
  RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER prevent_add_location_point_for_dead_animal_trigger
  BEFORE INSERT ON animals_visited_locations
  FOR EACH ROW
  EXECUTE FUNCTION prevent_add_visited_location_point_for_dead_animal();

CREATE OR REPLACE FUNCTION prevent_add_visited_location_point_if_location_point_is_chipping_location()
  RETURNS TRIGGER
  AS $$
BEGIN
  IF NOT EXISTS(
    SELECT
      1
    FROM
      animals_visited_locations
    WHERE
      animal_id = NEW.animal_id)
    AND EXISTS(
      SELECT
        1
      FROM
        animals
      WHERE
        id = NEW.animal_id
        AND NEW.location_point_id = chipping_location_id) THEN
    RAISE EXCEPTION 'Cannot add location point for animal that did not move from chipping location point';
END IF;
  RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER prevent_add_visited_location_point_if_location_point_is_chipping_location_trigger
  BEFORE INSERT ON animals_visited_locations
  FOR EACH ROW
  EXECUTE FUNCTION prevent_add_visited_location_point_if_location_point_is_chipping_location();

CREATE OR REPLACE FUNCTION prevent_add_visited_location_point_as_current_location_point()
  RETURNS TRIGGER
  AS $$
BEGIN
  IF EXISTS(
    SELECT
      1
    FROM
      animals_visited_locations
    WHERE
      NEW.location_point_id = location_point_id
    ORDER BY
      date_time_of_visit_location_point DESC
    LIMIT 1;
) THEN
RAISE EXCEPTION 'Cannot add location point for animal that is the same as current location point';
END IF;
  RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER prevent_add_visited_location_point_as_current_location_point_trigger
  BEFORE INSERT ON animals_visited_locations
  FOR EACH ROW
  EXECUTE FUNCTION prevent_add_visited_location_point_as_current_location_point();

-- update triggers
CREATE OR REPLACE FUNCTION prevent_update_first_visited_location_point_to_chipping_location()
  RETURNS TRIGGER
  AS $$
BEGIN
  IF EXISTS(
    SELECT
      1
    FROM
      animals_visited_locations
    WHERE
      NEW.location_point_id =(
        SELECT
          chipping_location_id
        FROM
          animals
        WHERE
          id = NEW.animal_id)
      ORDER BY
        date_time_of_visit_location_point DESC
      LIMIT 1;
) THEN
RAISE EXCEPTION 'Cannot update first location point for animal that is the same as chipping location';
END IF;
  RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER prevent_update_first_visited_location_point_to_chipping_location_trigger
  BEFORE UPDATE ON animals_visited_locations
  FOR EACH ROW
  EXECUTE FUNCTION prevent_update_first_visited_location_point_to_chipping_location();

CREATE OR REPLACE FUNCTION prevent_update_visited_location_point_to_current_location_point()
  RETURNS TRIGGER
  AS $$
BEGIN
  IF(OLD.animals_visited_locations = NEW.animals_visited_locations) THEN
    RAISE EXCEPTION 'Cannot update location point for animal that is the same as current location point';
  END IF;
  RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER prevent_update_visited_location_point_to_current_location_point_trigger
  BEFORE UPDATE ON animals_visited_locations
  FOR EACH ROW
  WHEN(OLD.animals_visited_locations = NEW.animals_visited_locations)
  EXECUTE FUNCTION prevent_update_visited_location_point_to_current_location_point();

CREATE OR REPLACE FUNCTION prevent_update_visited_location_point_to_previous_or_next_location_point()
  RETURNS TRIGGER
  AS $$
DECLARE
  prev_location_id bigint;
  next_location_id bigint;
BEGIN
  SELECT
    location_point_id INTO prev_location_id
  FROM (
    SELECT
      location_point_id
    FROM
      animals_visited_locations
    WHERE
      animal_id = NEW.animal_id
      AND date_time_of_visit_location_point < NEW.date_time_of_visit_location_point
    ORDER BY
      date_time_of_visit_location_point DESC
    LIMIT 1) AS prev_location;
  IF (NEW.location_point_id = prev_location_id) THEN
    RAISE EXCEPTION 'New location point must be different from both previous location point.';
    RETURN NEW;
  END IF;
  SELECT
    location_point_id INTO next_location_id
  FROM (
    SELECT
      location_point_id
    FROM
      animals_visited_locations
    WHERE
      animal_id = NEW.animal_id
      AND date_time_of_visit_location_point > NEW.date_time_of_visit_location_point
    ORDER BY
      date_time_of_visit_location_point ASC
    LIMIT 1) AS next_location;
  IF (NEW.location_point_id = next_location_id) THEN
    RAISE EXCEPTION 'New location point must be different from next location point.';
  END IF;
  RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER prevent_update_visited_location_point_to_previous_or_next_location_point_trigger
  BEFORE UPDATE ON animals_visited_locations
  FOR EACH ROW
  EXECUTE FUNCTION prevent_update_visited_location_point_to_previous_or_next_location_point();

