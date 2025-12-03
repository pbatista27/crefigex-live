package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type ProductRepository interface {
	Create(ctx context.Context, p *domain.Product) error
	Update(ctx context.Context, p *domain.Product) error
	Delete(ctx context.Context, id, vendorID string) error
	DeleteAny(ctx context.Context, id string) error
	ListByVendor(ctx context.Context, vendorID string) ([]domain.Product, error)
	ListAll(ctx context.Context) ([]domain.Product, error)
	Get(ctx context.Context, id string) (*domain.Product, error)
	DecreaseStock(ctx context.Context, id string, qty int) error
}

type productRepo struct {
	db *sql.DB
}

func NewProductRepository(db *sql.DB) ProductRepository {
	return &productRepo{db: db}
}

func (r *productRepo) Create(ctx context.Context, p *domain.Product) error {
	return r.db.QueryRowContext(ctx, `
		INSERT INTO products (vendor_id, name, description, price, currency, active, category_id, stock)
		VALUES ($1,$2,$3,$4,$5,$6,$7,$8)
		RETURNING id, created_at, updated_at
	`, p.VendorID, p.Name, p.Description, p.Price, p.Currency, p.Active, p.CategoryID, p.Stock).
		Scan(&p.ID, &p.CreatedAt, &p.UpdatedAt)
}
func (r *productRepo) Update(ctx context.Context, p *domain.Product) error {
	_, err := r.db.ExecContext(ctx, `
		UPDATE products SET name=$1, description=$2, price=$3, currency=$4, active=$5, category_id=$6, stock=$7, updated_at=now()
		WHERE id=$8 AND vendor_id=$9
	`, p.Name, p.Description, p.Price, p.Currency, p.Active, p.CategoryID, p.Stock, p.ID, p.VendorID)
	return err
}
func (r *productRepo) Delete(ctx context.Context, id, vendorID string) error {
	_, err := r.db.ExecContext(ctx, `DELETE FROM products WHERE id=$1 AND vendor_id=$2`, id, vendorID)
	return err
}
func (r *productRepo) DeleteAny(ctx context.Context, id string) error {
	_, err := r.db.ExecContext(ctx, `DELETE FROM products WHERE id=$1`, id)
	return err
}
func (r *productRepo) ListByVendor(ctx context.Context, vendorID string) ([]domain.Product, error) {
	rows, err := r.db.QueryContext(ctx, `
		SELECT id, vendor_id, name, description, price, currency, active, category_id, stock, created_at, updated_at
		FROM products WHERE vendor_id = $1
	`, vendorID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []domain.Product
	for rows.Next() {
		var p domain.Product
		if err := rows.Scan(&p.ID, &p.VendorID, &p.Name, &p.Description, &p.Price, &p.Currency, &p.Active, &p.CategoryID, &p.Stock, &p.CreatedAt, &p.UpdatedAt); err != nil {
			return nil, err
		}
		list = append(list, p)
	}
	return list, nil
}

func (r *productRepo) ListAll(ctx context.Context) ([]domain.Product, error) {
	rows, err := r.db.QueryContext(ctx, `
		SELECT id, vendor_id, name, description, price, currency, active, category_id, stock, created_at, updated_at
		FROM products
	`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []domain.Product
	for rows.Next() {
		var p domain.Product
		if err := rows.Scan(&p.ID, &p.VendorID, &p.Name, &p.Description, &p.Price, &p.Currency, &p.Active, &p.CategoryID, &p.Stock, &p.CreatedAt, &p.UpdatedAt); err != nil {
			return nil, err
		}
		list = append(list, p)
	}
	return list, nil
}
func (r *productRepo) Get(ctx context.Context, id string) (*domain.Product, error) {
	row := r.db.QueryRowContext(ctx, `
		SELECT id, vendor_id, name, description, price, currency, active, category_id, stock, created_at, updated_at
		FROM products WHERE id = $1
	`, id)
	var p domain.Product
	if err := row.Scan(&p.ID, &p.VendorID, &p.Name, &p.Description, &p.Price, &p.Currency, &p.Active, &p.CategoryID, &p.Stock, &p.CreatedAt, &p.UpdatedAt); err != nil {
		return nil, err
	}
	return &p, nil
}

func (r *productRepo) DecreaseStock(ctx context.Context, id string, qty int) error {
	row := r.db.QueryRowContext(ctx, `
		UPDATE products SET stock = stock - $2
		WHERE id = $1 AND stock >= $2
		RETURNING id
	`, id, qty)
	var tmp string
	if err := row.Scan(&tmp); err != nil {
		return err
	}
	return nil
}
