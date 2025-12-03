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
	query := `
		SELECT id, video_id, sender_id, sender_role, message, created_at
		FROM video_chat_messages
		WHERE video_id = $1
	`
	args := []any{videoID}
	if since != "" {
		query += ` AND created_at > $2`
		args = append(args, since)
	}
	query += ` ORDER BY created_at ASC`

	rows, err := r.db.QueryContext(ctx, query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []domain.VideoChatMessage
	for rows.Next() {
		var m domain.VideoChatMessage
		if err := rows.Scan(&m.ID, &m.VideoID, &m.SenderID, &m.SenderRole, &m.Message, &m.CreatedAt); err != nil {
			return nil, err
		}
		list = append(list, m)
	}
	return list, nil
}

func (r *chatRepo) CreateMessage(ctx context.Context, msg *domain.VideoChatMessage) error {
	return r.db.QueryRowContext(ctx, `
		INSERT INTO video_chat_messages (video_id, sender_id, sender_role, message)
		VALUES ($1,$2,$3,$4)
		RETURNING id, created_at
	`, msg.VideoID, msg.SenderID, msg.SenderRole, msg.Message).
		Scan(&msg.ID, &msg.CreatedAt)
}
