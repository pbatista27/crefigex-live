package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type CartRepository interface {
	AddItem(ctx context.Context, item *domain.CartItem) error
	List(ctx context.Context, userID, vendorID string) ([]domain.CartItem, error)
	Clear(ctx context.Context, userID, vendorID string) error
}

type cartRepo struct {
	db *sql.DB
}

func NewCartRepository(db *sql.DB) CartRepository {
	return &cartRepo{db: db}
}

func (r *cartRepo) AddItem(ctx context.Context, item *domain.CartItem) error {
	return r.db.QueryRowContext(ctx, `
		INSERT INTO cart_items (user_id, vendor_id, product_id, service_id, quantity, unit_price, total)
		VALUES ($1,$2,$3,$4,$5,$6,$7)
		RETURNING id, created_at
	`, item.UserID, item.VendorID, item.ProductID, item.ServiceID, item.Quantity, item.UnitPrice, item.Total).
		Scan(&item.ID, &item.CreatedAt)
}

func (r *cartRepo) List(ctx context.Context, userID, vendorID string) ([]domain.CartItem, error) {
	rows, err := r.db.QueryContext(ctx, `
		SELECT id, user_id, vendor_id, product_id, service_id, quantity, unit_price, total, created_at
		FROM cart_items WHERE user_id = $1 AND vendor_id = $2
	`, userID, vendorID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []domain.CartItem
	for rows.Next() {
		var it domain.CartItem
		if err := rows.Scan(&it.ID, &it.UserID, &it.VendorID, &it.ProductID, &it.ServiceID, &it.Quantity, &it.UnitPrice, &it.Total, &it.CreatedAt); err != nil {
			return nil, err
		}
		list = append(list, it)
	}
	return list, nil
}

func (r *cartRepo) Clear(ctx context.Context, userID, vendorID string) error {
	_, err := r.db.ExecContext(ctx, `DELETE FROM cart_items WHERE user_id=$1 AND vendor_id=$2`, userID, vendorID)
	return err
}
