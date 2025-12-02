package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type DeliveryRepository interface {
	Create(ctx context.Context, d *domain.Delivery) error
	UpdateStatus(ctx context.Context, id string, status domain.DeliveryStatus, photoURL string) error
	ListByVendor(ctx context.Context, vendorID string) ([]domain.Delivery, error)
	ListByCustomer(ctx context.Context, customerID string) ([]domain.Delivery, error)
	Get(ctx context.Context, id string) (*domain.Delivery, error)
}

type deliveryRepo struct {
	db *sql.DB
}

func NewDeliveryRepository(db *sql.DB) DeliveryRepository {
	return &deliveryRepo{db: db}
}

func (r *deliveryRepo) Create(ctx context.Context, d *domain.Delivery) error { return nil }
func (r *deliveryRepo) UpdateStatus(ctx context.Context, id string, status domain.DeliveryStatus, photoURL string) error {
	return nil
}
func (r *deliveryRepo) ListByVendor(ctx context.Context, vendorID string) ([]domain.Delivery, error) {
	return []domain.Delivery{}, nil
}
func (r *deliveryRepo) ListByCustomer(ctx context.Context, customerID string) ([]domain.Delivery, error) {
	return []domain.Delivery{}, nil
}
func (r *deliveryRepo) Get(ctx context.Context, id string) (*domain.Delivery, error) {
	return nil, sql.ErrNoRows
}
