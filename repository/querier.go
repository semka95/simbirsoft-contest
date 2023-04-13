// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.17.2

package repository

import (
	"context"
)

type Querier interface {
	AddAnimalAnimalType(ctx context.Context, arg AddAnimalAnimalTypeParams) error
	CreateAccount(ctx context.Context, arg CreateAccountParams) (CreateAccountRow, error)
	CreateAnimal(ctx context.Context, arg CreateAnimalParams) (Animal, error)
	CreateAnimalAnimalType(ctx context.Context, arg CreateAnimalAnimalTypeParams) error
	CreateAnimalType(ctx context.Context, animalType string) (AnimalType, error)
	CreateLocation(ctx context.Context, arg CreateLocationParams) (Location, error)
	CreateVisitedLocation(ctx context.Context, arg CreateVisitedLocationParams) (CreateVisitedLocationRow, error)
	DeleteAccount(ctx context.Context, id int64) error
	DeleteAnimal(ctx context.Context, id int64) error
	DeleteAnimalAnimalType(ctx context.Context, arg DeleteAnimalAnimalTypeParams) error
	DeleteAnimalType(ctx context.Context, id int64) error
	DeleteLocation(ctx context.Context, id int64) error
	DeleteVisitedLocation(ctx context.Context, arg DeleteVisitedLocationParams) error
	GetAccount(ctx context.Context, id int64) (GetAccountRow, error)
	GetAnimal(ctx context.Context, animalID int64) (GetAnimalRow, error)
	GetAnimalType(ctx context.Context, id int64) (AnimalType, error)
	GetLocation(ctx context.Context, id int64) (Location, error)
	SearchAccount(ctx context.Context, arg SearchAccountParams) ([]SearchAccountRow, error)
	SearchAnimal(ctx context.Context, arg SearchAnimalParams) ([]SearchAnimalRow, error)
	SearchVisitedLocation(ctx context.Context, arg SearchVisitedLocationParams) ([]SearchVisitedLocationRow, error)
	UpdateAccount(ctx context.Context, arg UpdateAccountParams) (UpdateAccountRow, error)
	UpdateAnimal(ctx context.Context, arg UpdateAnimalParams) (UpdateAnimalRow, error)
	UpdateAnimalAnimalType(ctx context.Context, arg UpdateAnimalAnimalTypeParams) error
	UpdateAnimalType(ctx context.Context, arg UpdateAnimalTypeParams) (AnimalType, error)
	UpdateLocation(ctx context.Context, arg UpdateLocationParams) (Location, error)
	UpdateVisitedLocation(ctx context.Context, arg UpdateVisitedLocationParams) (UpdateVisitedLocationRow, error)
}

var _ Querier = (*Queries)(nil)