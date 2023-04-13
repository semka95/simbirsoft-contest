-- name: AddAnimalAnimalType :exec
INSERT INTO animals_animal_types(animal_id, animal_type_id)
    VALUES ($1, $2);

-- name: UpdateAnimalAnimalType :exec
UPDATE
    animals_animal_types
SET
    animal_type_id = $1
WHERE
    animal_id = $2
    AND animal_type_id = $3;

-- name: DeleteAnimalAnimalType :exec
DELETE FROM animals_animal_types
WHERE animal_id = $1
    AND animal_type_id = $2;

-- name: CreateAnimalAnimalType :exec
INSERT INTO animals_animal_types(animal_id, animal_type_id)
SELECT
    $1,
    unnest($2::bigint[]);

