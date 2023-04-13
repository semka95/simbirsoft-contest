-- name: GetAnimal :one
SELECT
    id,
    ARRAY (
        SELECT
            animal_type_id
        FROM
            animals_animal_types
        WHERE
            animals_animal_types.animal_id = $1)::bigint[] AS animal_types,
    weight,
    length,
    height,
    gender,
    life_status,
    chipping_date_time,
    chipper_id,
    chipping_location_id,
    ARRAY (
        SELECT
            id
        FROM
            animals_visited_locations
        WHERE
            animals_visited_locations.animal_id = $1)::bigint[] AS visited_locations,
    death_date_time
FROM
    animals
WHERE
    animals.id = $1;

-- name: SearchAnimal :many
SELECT
    id,
    ARRAY (
        SELECT
            animal_type_id
        FROM
            animals_animal_types
        WHERE
            animals_animal_types.animal_id = animals.id)::bigint[] AS animal_types,
    weight,
    length,
    height,
    gender,
    life_status,
    chipping_date_time,
    chipper_id,
    chipping_location_id,
    ARRAY (
        SELECT
            id
        FROM
            animals_visited_locations
        WHERE
            animals_visited_locations.animal_id = animals.id)::bigint[] AS visited_locations,
    death_date_time
FROM
    animals
WHERE
    animals.id > $1
    AND chipping_date_time BETWEEN sqlc.narg(start_date_time)::timestamp AND sqlc.narg(end_date_time)::timestamp
    AND chipper_id = COALESCE(sqlc.narg('chipper_id')::bigint, chipper_id)
    AND chipping_location_id = COALESCE(sqlc.narg('chipping_location_id')::bigint, chipping_location_id)
    AND life_status = COALESCE(sqlc.narg('life_status')::animal_life_status, life_status)
    AND gender = COALESCE(sqlc.narg('gender')::animal_gender, gender)
ORDER BY
    id ASC
LIMIT $2;

-- name: CreateAnimal :one
INSERT INTO animals(weight, length, height, gender, chipper_id, chipping_location_id)
    VALUES ($1, $2, $3, $4, $5, $6)
RETURNING
    *;

-- name: UpdateAnimal :one
UPDATE
    animals
SET
    weight = $1,
    length = $2,
    height = $3,
    gender = $4,
    life_status = $5,
    chipper_id = $6,
    chipping_location_id = $7
WHERE
    animals.id = $8
RETURNING
    *,
    ARRAY (
        SELECT
            id
        FROM
            animals_visited_locations
        WHERE
            animals_visited_locations.animal_id = $8)::bigint[] AS visited_locations;

-- name: DeleteAnimal :exec
DELETE FROM animals
WHERE id = $1;

