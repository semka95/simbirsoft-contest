-- name: GetLocation :one
SELECT
    *
FROM
    locations
WHERE
    id = $1;

-- name: CreateLocation :one
INSERT INTO locations(lattitude, longitude)
    VALUES ($1, $2)
RETURNING
    *;

-- name: UpdateLocation :one
UPDATE
    locations
SET
    lattitude = $1,
    longitude = $2
WHERE
    id = $3
RETURNING
    *;

-- name: DeleteLocation :exec
DELETE FROM locations
WHERE id = $1;

