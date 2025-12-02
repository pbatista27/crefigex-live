package domain

import "time"

type Video struct {
	ID          string
	VendorID    string
	Title       string
	Description string
	URL         string
	CreatedAt   time.Time
}

type VideoReview struct {
	ID         string
	VideoID    string
	CustomerID string
	Rating     int
	Comment    string
	CreatedAt  time.Time
}

type VideoChatMessage struct {
	ID         string
	VideoID    string
	SenderID   string
	SenderRole Role
	Message    string
	CreatedAt  time.Time
}
