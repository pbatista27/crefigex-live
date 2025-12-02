package domain

import "time"

type ProductReview struct {
	ID         string
	ProductID  string
	CustomerID string
	Rating     int
	Comment    string
	CreatedAt  time.Time
}
