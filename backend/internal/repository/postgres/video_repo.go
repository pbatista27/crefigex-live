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

func (r *videoRepo) Create(ctx context.Context, v *domain.Video) error {
	return r.db.QueryRowContext(ctx, `
		INSERT INTO videos (vendor_id, title, description, url)
		VALUES ($1,$2,$3,$4)
		RETURNING id, created_at
	`, v.VendorID, v.Title, v.Description, v.URL).Scan(&v.ID, &v.CreatedAt)
}
func (r *videoRepo) ListByVendor(ctx context.Context, vendorID string) ([]domain.Video, error) {
	rows, err := r.db.QueryContext(ctx, `
		SELECT id, vendor_id, title, description, url, created_at
		FROM videos WHERE vendor_id = $1
		ORDER BY created_at DESC
	`, vendorID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []domain.Video
	for rows.Next() {
		var v domain.Video
		if err := rows.Scan(&v.ID, &v.VendorID, &v.Title, &v.Description, &v.URL, &v.CreatedAt); err != nil {
			return nil, err
		}
		list = append(list, v)
	}
	return list, nil
}
func (r *videoRepo) Get(ctx context.Context, id string) (*domain.Video, error) {
	row := r.db.QueryRowContext(ctx, `
		SELECT id, vendor_id, title, description, url, created_at
		FROM videos WHERE id = $1
	`, id)
	var v domain.Video
	if err := row.Scan(&v.ID, &v.VendorID, &v.Title, &v.Description, &v.URL, &v.CreatedAt); err != nil {
		return nil, err
	}
	return &v, nil
}
