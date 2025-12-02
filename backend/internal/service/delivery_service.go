package service

import (
	"context"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/repository/postgres"
)

type DeliveryService struct {
	deliveries postgres.DeliveryRepository
}

func NewDeliveryService(deliveries postgres.DeliveryRepository) *DeliveryService {
	return &DeliveryService{deliveries: deliveries}
}

func (s *DeliveryService) UpdateStatus(ctx context.Context, id string, status domain.DeliveryStatus, photo string) error {
	return s.deliveries.UpdateStatus(ctx, id, status, photo)
}

func (s *DeliveryService) ListByVendor(ctx context.Context, vendorID string) ([]domain.Delivery, error) {
	return s.deliveries.ListByVendor(ctx, vendorID)
}

func (s *DeliveryService) ListByCustomer(ctx context.Context, customerID string) ([]domain.Delivery, error) {
	return s.deliveries.ListByCustomer(ctx, customerID)
}

func (s *DeliveryService) Get(ctx context.Context, id string) (*domain.Delivery, error) {
	return s.deliveries.Get(ctx, id)
}
