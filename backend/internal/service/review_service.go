package service

import (
	"context"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/repository/postgres"
)

type ReviewService struct {
	reviews postgres.ReviewRepository
}

func NewReviewService(reviews postgres.ReviewRepository) *ReviewService {
	return &ReviewService{reviews: reviews}
}

func (s *ReviewService) ListVideoReviews(ctx context.Context, videoID string) ([]domain.VideoReview, error) {
	return s.reviews.ListVideoReviews(ctx, videoID)
}

func (s *ReviewService) CreateVideoReview(ctx context.Context, r *domain.VideoReview) error {
	return s.reviews.CreateVideoReview(ctx, r)
}

func (s *ReviewService) ListProductReviews(ctx context.Context, productID string) ([]domain.ProductReview, error) {
	return s.reviews.ListProductReviews(ctx, productID)
}

func (s *ReviewService) CreateProductReview(ctx context.Context, r *domain.ProductReview) error {
	return s.reviews.CreateProductReview(ctx, r)
}
