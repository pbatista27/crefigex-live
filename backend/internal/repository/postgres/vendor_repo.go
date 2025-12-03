package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type VendorRepository interface {
	Create(ctx context.Context, v *domain.Vendor) error
	UpdateStatus(ctx context.Context, id string, status domain.VendorStatus) error
	List(ctx context.Context, status domain.VendorStatus) ([]domain.Vendor, error)
	Get(ctx context.Context, id string) (*domain.Vendor, error)
	GetByUser(ctx context.Context, userID string) (*domain.Vendor, error)
}

type vendorRepo struct {
	db *sql.DB
}

func NewVendorRepository(db *sql.DB) VendorRepository {
	return &vendorRepo{db: db}
}

func (r *vendorRepo) Create(ctx context.Context, v *domain.Vendor) error {
	return r.db.QueryRowContext(ctx, `
		INSERT INTO vendors (user_id, name, phone, address, category_id, description, vendor_type, status)
		VALUES ($1,$2,$3,$4,$5,$6,$7,$8)
		RETURNING id, created_at
	`, v.UserID, v.Name, v.Phone, v.Address, v.CategoryID, v.Description, v.Type, v.Status).
		Scan(&v.ID, &v.CreatedAt)
}

func (r *vendorRepo) UpdateStatus(ctx context.Context, id string, status domain.VendorStatus) error {
	_, err := r.db.ExecContext(ctx, `UPDATE vendors SET status = $1 WHERE id = $2`, status, id)
	return err
}

func (r *vendorRepo) List(ctx context.Context, status domain.VendorStatus) ([]domain.Vendor, error) {
	query := `SELECT id, user_id, name, phone, address, category_id, description, vendor_type, status, created_at FROM vendors`
	var args []any
	if status != "" {
		query += ` WHERE status = $1`
		args = append(args, status)
	}
	rows, err := r.db.QueryContext(ctx, query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []domain.Vendor
	for rows.Next() {
		var v domain.Vendor
		if err := rows.Scan(&v.ID, &v.UserID, &v.Name, &v.Phone, &v.Address, &v.CategoryID, &v.Description, &v.Type, &v.Status, &v.CreatedAt); err != nil {
			return nil, err
		}
		list = append(list, v)
	}
	return list, nil
}

func (r *vendorRepo) Get(ctx context.Context, id string) (*domain.Vendor, error) {
	row := r.db.QueryRowContext(ctx, `
		SELECT id, user_id, name, phone, address, category_id, description, vendor_type, status, created_at
		FROM vendors WHERE id = $1
	`, id)
	var v domain.Vendor
	if err := row.Scan(&v.ID, &v.UserID, &v.Name, &v.Phone, &v.Address, &v.CategoryID, &v.Description, &v.Type, &v.Status, &v.CreatedAt); err != nil {
		return nil, err
	}
	return &v, nil
}

func (r *vendorRepo) GetByUser(ctx context.Context, userID string) (*domain.Vendor, error) {
	row := r.db.QueryRowContext(ctx, `
		SELECT id, user_id, name, phone, address, category_id, description, vendor_type, status, created_at
		FROM vendors WHERE user_id = $1 LIMIT 1
	`, userID)
	var v domain.Vendor
	if err := row.Scan(&v.ID, &v.UserID, &v.Name, &v.Phone, &v.Address, &v.CategoryID, &v.Description, &v.Type, &v.Status, &v.CreatedAt); err != nil {
		return nil, err
	}
	return &v, nil
}
