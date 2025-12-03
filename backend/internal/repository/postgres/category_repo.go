package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type CategoryRepository interface {
	ListCategories(ctx context.Context) ([]domain.Category, error)
	ListProductTypes(ctx context.Context) ([]domain.ProductType, error)
	ListServiceTypes(ctx context.Context) ([]domain.ServiceType, error)
	CreateCategory(ctx context.Context, name string) (*domain.Category, error)
	UpdateCategory(ctx context.Context, id, name string) error
	DeleteCategory(ctx context.Context, id string) error
	CreateProductType(ctx context.Context, name string) (*domain.ProductType, error)
	UpdateProductType(ctx context.Context, id, name string) error
	DeleteProductType(ctx context.Context, id string) error
	CreateServiceType(ctx context.Context, name string) (*domain.ServiceType, error)
	UpdateServiceType(ctx context.Context, id, name string) error
	DeleteServiceType(ctx context.Context, id string) error
}

type categoryRepo struct {
	db *sql.DB
}

func NewCategoryRepository(db *sql.DB) CategoryRepository {
	return &categoryRepo{db: db}
}

func (r *categoryRepo) ListCategories(ctx context.Context) ([]domain.Category, error) {
	rows, err := r.db.QueryContext(ctx, `SELECT id, name FROM categories`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var list []domain.Category
	for rows.Next() {
		var c domain.Category
		if err := rows.Scan(&c.ID, &c.Name); err != nil {
			return nil, err
		}
		list = append(list, c)
	}
	return list, nil
}

func (r *categoryRepo) ListProductTypes(ctx context.Context) ([]domain.ProductType, error) {
	rows, err := r.db.QueryContext(ctx, `SELECT id, name FROM product_types`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var list []domain.ProductType
	for rows.Next() {
		var p domain.ProductType
		if err := rows.Scan(&p.ID, &p.Name); err != nil {
			return nil, err
		}
		list = append(list, p)
	}
	return list, nil
}

func (r *categoryRepo) ListServiceTypes(ctx context.Context) ([]domain.ServiceType, error) {
	rows, err := r.db.QueryContext(ctx, `SELECT id, name FROM service_types`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var list []domain.ServiceType
	for rows.Next() {
		var s domain.ServiceType
		if err := rows.Scan(&s.ID, &s.Name); err != nil {
			return nil, err
		}
		list = append(list, s)
	}
	return list, nil
}

func (r *categoryRepo) CreateCategory(ctx context.Context, name string) (*domain.Category, error) {
	var c domain.Category
	if err := r.db.QueryRowContext(ctx, `INSERT INTO categories (name) VALUES ($1) RETURNING id, name`, name).Scan(&c.ID, &c.Name); err != nil {
		return nil, err
	}
	return &c, nil
}

func (r *categoryRepo) UpdateCategory(ctx context.Context, id, name string) error {
	_, err := r.db.ExecContext(ctx, `UPDATE categories SET name=$1 WHERE id=$2`, name, id)
	return err
}

func (r *categoryRepo) DeleteCategory(ctx context.Context, id string) error {
	_, err := r.db.ExecContext(ctx, `DELETE FROM categories WHERE id=$1`, id)
	return err
}

func (r *categoryRepo) CreateProductType(ctx context.Context, name string) (*domain.ProductType, error) {
	var p domain.ProductType
	if err := r.db.QueryRowContext(ctx, `INSERT INTO product_types (name) VALUES ($1) RETURNING id, name`, name).Scan(&p.ID, &p.Name); err != nil {
		return nil, err
	}
	return &p, nil
}

func (r *categoryRepo) UpdateProductType(ctx context.Context, id, name string) error {
	_, err := r.db.ExecContext(ctx, `UPDATE product_types SET name=$1 WHERE id=$2`, name, id)
	return err
}

func (r *categoryRepo) DeleteProductType(ctx context.Context, id string) error {
	_, err := r.db.ExecContext(ctx, `DELETE FROM product_types WHERE id=$1`, id)
	return err
}

func (r *categoryRepo) CreateServiceType(ctx context.Context, name string) (*domain.ServiceType, error) {
	var s domain.ServiceType
	if err := r.db.QueryRowContext(ctx, `INSERT INTO service_types (name) VALUES ($1) RETURNING id, name`, name).Scan(&s.ID, &s.Name); err != nil {
		return nil, err
	}
	return &s, nil
}

func (r *categoryRepo) UpdateServiceType(ctx context.Context, id, name string) error {
	_, err := r.db.ExecContext(ctx, `UPDATE service_types SET name=$1 WHERE id=$2`, name, id)
	return err
}

func (r *categoryRepo) DeleteServiceType(ctx context.Context, id string) error {
	_, err := r.db.ExecContext(ctx, `DELETE FROM service_types WHERE id=$1`, id)
	return err
}
