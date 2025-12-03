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
	rows, err := r.db.QueryContext(ctx, `
		SELECT id, video_id, customer_id, rating, comment, created_at
		FROM video_reviews WHERE video_id = $1
		ORDER BY created_at DESC
	`, videoID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []domain.VideoReview
	for rows.Next() {
		var vr domain.VideoReview
		if err := rows.Scan(&vr.ID, &vr.VideoID, &vr.CustomerID, &vr.Rating, &vr.Comment, &vr.CreatedAt); err != nil {
			return nil, err
		}
		list = append(list, vr)
	}
	return list, nil
}

func (r *reviewRepo) CreateVideoReview(ctx context.Context, vr *domain.VideoReview) error {
	return r.db.QueryRowContext(ctx, `
		INSERT INTO video_reviews (video_id, customer_id, rating, comment)
		VALUES ($1,$2,$3,$4)
		RETURNING id, created_at
	`, vr.VideoID, vr.CustomerID, vr.Rating, vr.Comment).
		Scan(&vr.ID, &vr.CreatedAt)
}

func (r *reviewRepo) ListProductReviews(ctx context.Context, productID string) ([]domain.ProductReview, error) {
	rows, err := r.db.QueryContext(ctx, `
		SELECT id, product_id, customer_id, rating, comment, created_at
		FROM product_reviews WHERE product_id = $1
		ORDER BY created_at DESC
	`, productID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []domain.ProductReview
	for rows.Next() {
		var pr domain.ProductReview
		if err := rows.Scan(&pr.ID, &pr.ProductID, &pr.CustomerID, &pr.Rating, &pr.Comment, &pr.CreatedAt); err != nil {
			return nil, err
		}
		list = append(list, pr)
	}
	return list, nil
}

func (r *reviewRepo) CreateProductReview(ctx context.Context, pr *domain.ProductReview) error {
	return r.db.QueryRowContext(ctx, `
		INSERT INTO product_reviews (product_id, customer_id, rating, comment)
		VALUES ($1,$2,$3,$4)
		RETURNING id, created_at
	`, pr.ProductID, pr.CustomerID, pr.Rating, pr.Comment).
		Scan(&pr.ID, &pr.CreatedAt)
}
