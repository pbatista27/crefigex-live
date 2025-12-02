package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type ServiceRepository interface {
	Create(ctx context.Context, s *domain.Service) error
	Update(ctx context.Context, s *domain.Service) error
	Delete(ctx context.Context, id, vendorID string) error
	ListByVendor(ctx context.Context, vendorID string) ([]domain.Service, error)
	Get(ctx context.Context, id string) (*domain.Service, error)
}

type serviceRepo struct {
	db *sql.DB
}

func NewServiceRepository(db *sql.DB) ServiceRepository {
	return &serviceRepo{db: db}
}

func (r *serviceRepo) Create(ctx context.Context, s *domain.Service) error { return nil }
func (r *serviceRepo) Update(ctx context.Context, s *domain.Service) error { return nil }
func (r *serviceRepo) Delete(ctx context.Context, id, vendorID string) error { return nil }
func (r *serviceRepo) ListByVendor(ctx context.Context, vendorID string) ([]domain.Service, error) {
	return []domain.Service{}, nil
}
func (r *serviceRepo) Get(ctx context.Context, id string) (*domain.Service, error) { return nil, sql.ErrNoRows }
