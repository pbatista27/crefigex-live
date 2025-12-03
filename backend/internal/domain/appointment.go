package domain

import "time"

type Appointment struct {
	ID          string
	ServiceID   string
	CustomerID  string
	VendorID    string
	ScheduledAt time.Time
	Status      string
	CreatedAt   time.Time
}
