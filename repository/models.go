// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.17.2

package repository

import (
	"database/sql"
	"database/sql/driver"
	"fmt"
	"time"
)

type AnimalGender string

const (
	AnimalGenderMALE   AnimalGender = "MALE"
	AnimalGenderFEMALE AnimalGender = "FEMALE"
	AnimalGenderOTHER  AnimalGender = "OTHER"
)

func (e *AnimalGender) Scan(src interface{}) error {
	switch s := src.(type) {
	case []byte:
		*e = AnimalGender(s)
	case string:
		*e = AnimalGender(s)
	default:
		return fmt.Errorf("unsupported scan type for AnimalGender: %T", src)
	}
	return nil
}

type NullAnimalGender struct {
	AnimalGender AnimalGender
	Valid        bool // Valid is true if AnimalGender is not NULL
}

// Scan implements the Scanner interface.
func (ns *NullAnimalGender) Scan(value interface{}) error {
	if value == nil {
		ns.AnimalGender, ns.Valid = "", false
		return nil
	}
	ns.Valid = true
	return ns.AnimalGender.Scan(value)
}

// Value implements the driver Valuer interface.
func (ns NullAnimalGender) Value() (driver.Value, error) {
	if !ns.Valid {
		return nil, nil
	}
	return string(ns.AnimalGender), nil
}

type AnimalLifeStatus string

const (
	AnimalLifeStatusALIVE AnimalLifeStatus = "ALIVE"
	AnimalLifeStatusDEAD  AnimalLifeStatus = "DEAD"
)

func (e *AnimalLifeStatus) Scan(src interface{}) error {
	switch s := src.(type) {
	case []byte:
		*e = AnimalLifeStatus(s)
	case string:
		*e = AnimalLifeStatus(s)
	default:
		return fmt.Errorf("unsupported scan type for AnimalLifeStatus: %T", src)
	}
	return nil
}

type NullAnimalLifeStatus struct {
	AnimalLifeStatus AnimalLifeStatus
	Valid            bool // Valid is true if AnimalLifeStatus is not NULL
}

// Scan implements the Scanner interface.
func (ns *NullAnimalLifeStatus) Scan(value interface{}) error {
	if value == nil {
		ns.AnimalLifeStatus, ns.Valid = "", false
		return nil
	}
	ns.Valid = true
	return ns.AnimalLifeStatus.Scan(value)
}

// Value implements the driver Valuer interface.
func (ns NullAnimalLifeStatus) Value() (driver.Value, error) {
	if !ns.Valid {
		return nil, nil
	}
	return string(ns.AnimalLifeStatus), nil
}

type Account struct {
	ID        int64
	FirstName string
	LastName  string
	Email     string
	Password  string
}

type Animal struct {
	ID                 int64
	Weight             float64
	Length             float64
	Height             float64
	Gender             AnimalGender
	LifeStatus         AnimalLifeStatus
	ChippingDateTime   time.Time
	ChipperID          int64
	ChippingLocationID int64
	DeathDateTime      sql.NullTime
}

type AnimalType struct {
	ID         int64
	AnimalType string
}

type AnimalsAnimalType struct {
	AnimalID     int64
	AnimalTypeID int64
}

type AnimalsVisitedLocation struct {
	ID                           int64
	DateTimeOfVisitLocationPoint time.Time
	LocationPointID              int64
	AnimalID                     int64
}

type Location struct {
	ID        int64
	Lattitude float64
	Longitude float64
}
