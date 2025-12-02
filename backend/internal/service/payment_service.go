package service

import (
	"context"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/repository/postgres"
)

type PaymentService struct {
	payments postgres.PaymentRepository
}

func NewPaymentService(payments postgres.PaymentRepository) *PaymentService {
	return &PaymentService{payments: payments}
}

func (s *PaymentService) Register(ctx context.Context, p *domain.Payment) error {
	return s.payments.Create(ctx, p)
}

func (s *PaymentService) ListByOrder(ctx context.Context, orderID string) ([]domain.Payment, error) {
	return s.payments.ListByOrder(ctx, orderID)
}
