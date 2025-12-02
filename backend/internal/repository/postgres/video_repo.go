package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type VideoRepository interface {
	Create(ctx context.Context, v *domain.Video) error
	ListByVendor(ctx context.Context, vendorID string) ([]domain.Video, error)
	Get(ctx context.Context, id string) (*domain.Video, error)
}

type videoRepo struct {
	db *sql.DB
}

func NewVideoRepository(db *sql.DB) VideoRepository {
	return &videoRepo{db: db}
}

func (r *videoRepo) Create(ctx context.Context, v *domain.Video) error { return nil }
func (r *videoRepo) ListByVendor(ctx context.Context, vendorID string) ([]domain.Video, error) {
	return []domain.Video{}, nil
}
func (r *videoRepo) Get(ctx context.Context, id string) (*domain.Video, error) { return nil, sql.ErrNoRows }
