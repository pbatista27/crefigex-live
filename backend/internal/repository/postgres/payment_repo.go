package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type PaymentRepository interface {
	Create(ctx context.Context, p *domain.Payment) error
	ListByOrder(ctx context.Context, orderID string) ([]domain.Payment, error)
}

type paymentRepo struct {
	db *sql.DB
}

func NewPaymentRepository(db *sql.DB) PaymentRepository {
	return &paymentRepo{db: db}
}

func (r *paymentRepo) Create(ctx context.Context, p *domain.Payment) error { return nil }
func (r *paymentRepo) ListByOrder(ctx context.Context, orderID string) ([]domain.Payment, error) {
	return []domain.Payment{}, nil
}
