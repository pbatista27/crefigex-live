package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type ProductRepository interface {
	Create(ctx context.Context, p *domain.Product) error
	Update(ctx context.Context, p *domain.Product) error
	Delete(ctx context.Context, id, vendorID string) error
	ListByVendor(ctx context.Context, vendorID string) ([]domain.Product, error)
	Get(ctx context.Context, id string) (*domain.Product, error)
}

type productRepo struct {
	db *sql.DB
}

func NewProductRepository(db *sql.DB) ProductRepository {
	return &productRepo{db: db}
}

func (r *productRepo) Create(ctx context.Context, p *domain.Product) error { return nil }
func (r *productRepo) Update(ctx context.Context, p *domain.Product) error { return nil }
func (r *productRepo) Delete(ctx context.Context, id, vendorID string) error { return nil }
func (r *productRepo) ListByVendor(ctx context.Context, vendorID string) ([]domain.Product, error) {
	return []domain.Product{}, nil
}
func (r *productRepo) Get(ctx context.Context, id string) (*domain.Product, error) { return nil, sql.ErrNoRows }
