-- name: GetAnimalType :one
SELECT
    *
FROM
    animal_types
WHERE
    id = $1;

-- name: CreateAnimalType :one
INSERT INTO animal_types(animal_type)
    VALUES ($1)
RETURNING
    *;

-- name: UpdateAnimalType :one
UPDATE
    animal_types
SET
    animal_type = $1
WHERE
    id = $2
RETURNING
    *;

-- name: DeleteAnimalType :exec
DELETE FROM animal_types
WHERE id = $1;

