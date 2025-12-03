package service

import (
	"context"
	"errors"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/repository/postgres"
)

type ReviewService struct {
	reviews postgres.ReviewRepository
	orders  postgres.OrderRepository
}

func NewReviewService(reviews postgres.ReviewRepository, orders postgres.OrderRepository) *ReviewService {
	return &ReviewService{reviews: reviews, orders: orders}
}

func (s *ReviewService) ListVideoReviews(ctx context.Context, videoID string) ([]domain.VideoReview, error) {
	return s.reviews.ListVideoReviews(ctx, videoID)
}

func (s *ReviewService) CreateVideoReview(ctx context.Context, r *domain.VideoReview) error {
	if ok, _ := s.orders.HasPurchasedVideo(ctx, r.CustomerID, r.VideoID); !ok {
		return errors.New("solo compradores pueden reseñar el video")
	}
	return s.reviews.CreateVideoReview(ctx, r)
}

func (s *ReviewService) ListProductReviews(ctx context.Context, productID string) ([]domain.ProductReview, error) {
	return s.reviews.ListProductReviews(ctx, productID)
}

func (s *ReviewService) CreateProductReview(ctx context.Context, r *domain.ProductReview) error {
	if ok, _ := s.orders.HasPurchasedProduct(ctx, r.CustomerID, r.ProductID); !ok {
		return errors.New("solo compradores pueden reseñar")
	}
	return s.reviews.CreateProductReview(ctx, r)
}
