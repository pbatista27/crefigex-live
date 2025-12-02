package service

import (
	"context"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/repository/postgres"
)

type OrderService struct {
	orders postgres.OrderRepository
	deliveries postgres.DeliveryRepository
}

func NewOrderService(orders postgres.OrderRepository, deliveries postgres.DeliveryRepository) *OrderService {
	return &OrderService{orders: orders, deliveries: deliveries}
}

func (s *OrderService) Checkout(ctx context.Context, o *domain.Order, items []domain.OrderItem) error {
	if err := s.orders.Create(ctx, o, items); err != nil {
		return err
	}
	d := &domain.Delivery{
		ID:        "",
		OrderID:   o.ID,
		VendorID:  o.VendorID,
		CustomerID: o.CustomerID,
		DeliveryType: o.DeliveryType,
		Status:    domain.DeliveryWaitingPayment,
	}
	return s.deliveries.Create(ctx, d)
}

func (s *OrderService) ListByCustomer(ctx context.Context, customerID string) ([]domain.Order, error) {
	return s.orders.ListByCustomer(ctx, customerID)
}
