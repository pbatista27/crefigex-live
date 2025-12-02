package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type OrderRepository interface {
	Create(ctx context.Context, o *domain.Order, items []domain.OrderItem) error
	ListByCustomer(ctx context.Context, customerID string) ([]domain.Order, error)
	Get(ctx context.Context, id string) (*domain.Order, error)
}

type orderRepo struct {
	db *sql.DB
}

func NewOrderRepository(db *sql.DB) OrderRepository {
	return &orderRepo{db: db}
}

func (r *orderRepo) Create(ctx context.Context, o *domain.Order, items []domain.OrderItem) error {
	return nil
}

func (r *orderRepo) ListByCustomer(ctx context.Context, customerID string) ([]domain.Order, error) {
	return []domain.Order{}, nil
}

func (r *orderRepo) Get(ctx context.Context, id string) (*domain.Order, error) {
	return nil, sql.ErrNoRows
}
