package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type ReviewRepository interface {
	ListVideoReviews(ctx context.Context, videoID string) ([]domain.VideoReview, error)
	CreateVideoReview(ctx context.Context, r *domain.VideoReview) error
	ListProductReviews(ctx context.Context, productID string) ([]domain.ProductReview, error)
	CreateProductReview(ctx context.Context, r *domain.ProductReview) error
}

type reviewRepo struct {
	db *sql.DB
}

func NewReviewRepository(db *sql.DB) ReviewRepository {
	return &reviewRepo{db: db}
}

func (r *reviewRepo) ListVideoReviews(ctx context.Context, videoID string) ([]domain.VideoReview, error) {
	return []domain.VideoReview{}, nil
}

func (r *reviewRepo) CreateVideoReview(ctx context.Context, vr *domain.VideoReview) error {
	return nil
}

func (r *reviewRepo) ListProductReviews(ctx context.Context, productID string) ([]domain.ProductReview, error) {
	return []domain.ProductReview{}, nil
}

func (r *reviewRepo) CreateProductReview(ctx context.Context, pr *domain.ProductReview) error {
	return nil
}
