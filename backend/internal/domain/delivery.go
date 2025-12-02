package domain

import "time"

type DeliveryStatus string

const (
	DeliveryWaitingPayment DeliveryStatus = "WAITING_PAYMENT_APPROVAL"
	DeliveryPending        DeliveryStatus = "PENDING_DELIVERY"
	DeliveryInDelivery     DeliveryStatus = "IN_DELIVERY"
	DeliveryDelivered      DeliveryStatus = "DELIVERED"
	DeliveryConfirmed      DeliveryStatus = "CONFIRMED_BY_CLIENT"
)

type Delivery struct {
	ID               string
	OrderID          string
	VendorID         string
	CustomerID       string
	DeliveryType     DeliveryType
	Status           DeliveryStatus
	PhotoURL         string
	CustomerConfirmed bool
	CreatedAt        time.Time
	UpdatedAt        time.Time
}
