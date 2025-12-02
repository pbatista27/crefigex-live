package service

import (
	"context"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/repository/postgres"
)

type VideoService struct {
	videos  postgres.VideoRepository
	reviews postgres.ReviewRepository
	chats   postgres.ChatRepository
}

func NewVideoService(videos postgres.VideoRepository, reviews postgres.ReviewRepository, chats postgres.ChatRepository) *VideoService {
	return &VideoService{videos: videos, reviews: reviews, chats: chats}
}

func (s *VideoService) Create(ctx context.Context, v *domain.Video) error {
	return s.videos.Create(ctx, v)
}

func (s *VideoService) ListByVendor(ctx context.Context, vendorID string) ([]domain.Video, error) {
	return s.videos.ListByVendor(ctx, vendorID)
}

func (s *VideoService) Get(ctx context.Context, id string) (*domain.Video, error) {
	return s.videos.Get(ctx, id)
}

func (s *VideoService) ListReviews(ctx context.Context, videoID string) ([]domain.VideoReview, error) {
	return s.reviews.ListVideoReviews(ctx, videoID)
}

func (s *VideoService) CreateReview(ctx context.Context, r *domain.VideoReview) error {
	return s.reviews.CreateVideoReview(ctx, r)
}

func (s *VideoService) ListMessages(ctx context.Context, videoID, since string) ([]domain.VideoChatMessage, error) {
	return s.chats.ListMessages(ctx, videoID, since)
}

func (s *VideoService) CreateMessage(ctx context.Context, msg *domain.VideoChatMessage) error {
	return s.chats.CreateMessage(ctx, msg)
}
