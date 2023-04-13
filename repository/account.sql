-- name: CreateAccount :one
INSERT INTO accounts(first_name, last_name, email, PASSWORD)
    VALUES ($1, $2, $3, $4)
RETURNING
    id, first_name, last_name, email;

-- name: GetAccount :one
SELECT
    id,
    first_name,
    last_name,
    email
FROM
    accounts
WHERE
    id = $1;

-- name: SearchAccount :many
SELECT
    id,
    first_name,
    last_name,
    email
FROM
    accounts
WHERE
    id > $1
    AND first_name ILIKE '%' || @first_name::string || '%'
    AND last_name ILIKE '%' || @last_name::string || '%'
    AND email ILIKE '%' || @email::string || '%'
ORDER BY
    id ASC
LIMIT $2;

-- name: UpdateAccount :one
UPDATE
    accounts
SET
    first_name = $1,
    last_name = $2,
    email = $3,
    PASSWORD = $4
WHERE
    id = $5
RETURNING
    id,
    first_name,
    last_name,
    email;

-- name: DeleteAccount :exec
DELETE FROM accounts
WHERE id = $1;

