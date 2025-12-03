package service

import (
	"context"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/repository/postgres"
)

type PaymentService struct {
	payments     postgres.PaymentRepository
	installments postgres.InstallmentRepository
	deliveries   postgres.DeliveryRepository
}

func NewPaymentService(payments postgres.PaymentRepository, installments postgres.InstallmentRepository, deliveries postgres.DeliveryRepository) *PaymentService {
	return &PaymentService{payments: payments, installments: installments, deliveries: deliveries}
}

func (s *PaymentService) Register(ctx context.Context, p *domain.Payment) error {
	if err := s.payments.Create(ctx, p); err != nil {
		return err
	}
	if p.InstallmentID != "" {
		_ = s.installments.MarkPaid(ctx, p.InstallmentID)
	}
	_ = s.deliveries.UpdateStatusByOrder(ctx, p.OrderID, domain.DeliveryPending)
	return nil
}

func (s *PaymentService) ListByOrder(ctx context.Context, orderID string) ([]domain.Payment, error) {
	return s.payments.ListByOrder(ctx, orderID)
}

func (s *PaymentService) ListInstallmentsByCustomer(ctx context.Context, customerID string) ([]domain.Installment, error) {
	return s.installments.ListByCustomer(ctx, customerID)
}
