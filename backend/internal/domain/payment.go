package domain

import "time"

type Payment struct {
	ID            string
	OrderID       string
	InstallmentID string
	Amount        int64
	Method        string
	Reference     string
	BankOrigin    string
	BankDest      string
	CreatedAt     time.Time
}

type PaymentPlan struct {
	ID                string
	Name              string
	InitialPercentage float64
	Installments      int
	DaysBetween       int
}
