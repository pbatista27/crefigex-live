package domain

import "time"

type DeliveryType string

const (
	DeliveryInternal DeliveryType = "INTERNAL"
	DeliveryCrefigex DeliveryType = "CREFIGEX"
)

type OrderStatus string

const (
	OrderPending   OrderStatus = "PENDING"
	OrderApproved  OrderStatus = "APPROVED"
	OrderCancelled OrderStatus = "CANCELLED"
)

type Order struct {
	ID              string
	CustomerID      string
	VendorID        string
	DeliveryType    DeliveryType
	ShippingAddress string
	Status          OrderStatus
	PaymentPlanID   string
	TotalAmount     int64
	CreatedAt       time.Time
}

type OrderItem struct {
	ID        string
	OrderID   string
	ProductID string
	ServiceID string
	Quantity  int
	UnitPrice int64
	Total     int64
}

type Installment struct {
	ID        string
	OrderID   string
	Amount    int64
	DueDate   time.Time
	Paid      bool
	CreatedAt time.Time
}

type CartItem struct {
	ID        string
	UserID    string
	VendorID  string
	ProductID string
	ServiceID string
	Quantity  int
	UnitPrice int64
	Total     int64
	CreatedAt time.Time
}
