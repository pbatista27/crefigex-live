package domain

import "time"

type Product struct {
	ID          string
	VendorID    string
	Name        string
	Description string
	Price       int64
	Currency    string
	Active      bool
	CategoryID  string
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

type Service struct {
	ID          string
	VendorID    string
	Name        string
	Description string
	Price       int64
	Currency    string
	Active      bool
	ServiceType string
	CreatedAt   time.Time
	UpdatedAt   time.Time
}
