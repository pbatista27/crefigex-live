package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type ChatRepository interface {
	ListMessages(ctx context.Context, videoID string, since string) ([]domain.VideoChatMessage, error)
	CreateMessage(ctx context.Context, msg *domain.VideoChatMessage) error
}

type chatRepo struct {
	db *sql.DB
}

func NewChatRepository(db *sql.DB) ChatRepository {
	return &chatRepo{db: db}
}

func (r *chatRepo) ListMessages(ctx context.Context, videoID string, since string) ([]domain.VideoChatMessage, error) {
	return []domain.VideoChatMessage{}, nil
}

func (r *chatRepo) CreateMessage(ctx context.Context, msg *domain.VideoChatMessage) error {
	return nil
}
