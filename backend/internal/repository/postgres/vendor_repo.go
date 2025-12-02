package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type VendorRepository interface {
	Create(ctx context.Context, v *domain.Vendor) error
	UpdateStatus(ctx context.Context, id string, status domain.VendorStatus) error
	List(ctx context.Context, status domain.VendorStatus) ([]domain.Vendor, error)
	Get(ctx context.Context, id string) (*domain.Vendor, error)
}

type vendorRepo struct {
	db *sql.DB
}

func NewVendorRepository(db *sql.DB) VendorRepository {
	return &vendorRepo{db: db}
}

func (r *vendorRepo) Create(ctx context.Context, v *domain.Vendor) error {
	return nil
}

func (r *vendorRepo) UpdateStatus(ctx context.Context, id string, status domain.VendorStatus) error {
	return nil
}

func (r *vendorRepo) List(ctx context.Context, status domain.VendorStatus) ([]domain.Vendor, error) {
	return []domain.Vendor{}, nil
}

func (r *vendorRepo) Get(ctx context.Context, id string) (*domain.Vendor, error) {
	return nil, sql.ErrNoRows
}
