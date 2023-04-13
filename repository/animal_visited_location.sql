-- name: SearchVisitedLocation :many
SELECT
    id,
    date_time_of_visit_location_point,
    location_point_id
FROM
    animals_visited_locations
WHERE
    id > $1
    AND animal_id = $2
    AND date_time_of_visit_location_point BETWEEN $3 AND $4
ORDER BY
    id ASC
LIMIT $5;

-- name: CreateVisitedLocation :one
INSERT INTO animals_visited_locations(animal_id, location_point_id)
    VALUES ($1, $2)
RETURNING
    id, date_time_of_visit_location_point, location_point_id;

-- name: UpdateVisitedLocation :one
UPDATE
    animals_visited_locations
SET
    location_point_id = $1,
    date_time_of_visit_location_point = NOW()
WHERE
    id = $2
    AND animal_id = $3
RETURNING
    id,
    date_time_of_visit_location_point,
    location_point_id;

-- name: DeleteVisitedLocation :exec
DELETE FROM animals_visited_locations
WHERE id = $1
    AND animal_id = $2;

