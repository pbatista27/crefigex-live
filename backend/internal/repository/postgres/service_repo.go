package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type ServiceRepository interface {
	Create(ctx context.Context, s *domain.Service) error
	Update(ctx context.Context, s *domain.Service) error
	Delete(ctx context.Context, id, vendorID string) error
	DeleteAny(ctx context.Context, id string) error
	ListByVendor(ctx context.Context, vendorID string) ([]domain.Service, error)
	ListAll(ctx context.Context) ([]domain.Service, error)
	Get(ctx context.Context, id string) (*domain.Service, error)
	ValidateAvailability(ctx context.Context, id string) error
}

type serviceRepo struct {
	db *sql.DB
}

func NewServiceRepository(db *sql.DB) ServiceRepository {
	return &serviceRepo{db: db}
}

func (r *serviceRepo) Create(ctx context.Context, s *domain.Service) error {
	return r.db.QueryRowContext(ctx, `
		INSERT INTO services (vendor_id, name, description, price, currency, active, service_type)
		VALUES ($1,$2,$3,$4,$5,$6,$7)
		RETURNING id, created_at, updated_at
	`, s.VendorID, s.Name, s.Description, s.Price, s.Currency, s.Active, s.ServiceType).
		Scan(&s.ID, &s.CreatedAt, &s.UpdatedAt)
}
func (r *serviceRepo) Update(ctx context.Context, s *domain.Service) error {
	_, err := r.db.ExecContext(ctx, `
		UPDATE services SET name=$1, description=$2, price=$3, currency=$4, active=$5, service_type=$6, updated_at=now()
		WHERE id=$7 AND vendor_id=$8
	`, s.Name, s.Description, s.Price, s.Currency, s.Active, s.ServiceType, s.ID, s.VendorID)
	return err
}
func (r *serviceRepo) Delete(ctx context.Context, id, vendorID string) error {
	_, err := r.db.ExecContext(ctx, `DELETE FROM services WHERE id=$1 AND vendor_id=$2`, id, vendorID)
	return err
}
func (r *serviceRepo) DeleteAny(ctx context.Context, id string) error {
	_, err := r.db.ExecContext(ctx, `DELETE FROM services WHERE id=$1`, id)
	return err
}
func (r *serviceRepo) ListByVendor(ctx context.Context, vendorID string) ([]domain.Service, error) {
	rows, err := r.db.QueryContext(ctx, `
		SELECT id, vendor_id, name, description, price, currency, active, service_type, created_at, updated_at
		FROM services WHERE vendor_id = $1
	`, vendorID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []domain.Service
	for rows.Next() {
		var s domain.Service
		if err := rows.Scan(&s.ID, &s.VendorID, &s.Name, &s.Description, &s.Price, &s.Currency, &s.Active, &s.ServiceType, &s.CreatedAt, &s.UpdatedAt); err != nil {
			return nil, err
		}
		list = append(list, s)
	}
	return list, nil
}

func (r *serviceRepo) ListAll(ctx context.Context) ([]domain.Service, error) {
	rows, err := r.db.QueryContext(ctx, `
		SELECT id, vendor_id, name, description, price, currency, active, service_type, created_at, updated_at
		FROM services
	`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []domain.Service
	for rows.Next() {
		var s domain.Service
		if err := rows.Scan(&s.ID, &s.VendorID, &s.Name, &s.Description, &s.Price, &s.Currency, &s.Active, &s.ServiceType, &s.CreatedAt, &s.UpdatedAt); err != nil {
			return nil, err
		}
		list = append(list, s)
	}
	return list, nil
}
func (r *serviceRepo) Get(ctx context.Context, id string) (*domain.Service, error) {
	row := r.db.QueryRowContext(ctx, `
		SELECT id, vendor_id, name, description, price, currency, active, service_type, created_at, updated_at
		FROM services WHERE id = $1
	`, id)
	var s domain.Service
	if err := row.Scan(&s.ID, &s.VendorID, &s.Name, &s.Description, &s.Price, &s.Currency, &s.Active, &s.ServiceType, &s.CreatedAt, &s.UpdatedAt); err != nil {
		return nil, err
	}
	return &s, nil
}

func (r *serviceRepo) ValidateAvailability(ctx context.Context, id string) error {
	row := r.db.QueryRowContext(ctx, `SELECT active FROM services WHERE id=$1`, id)
	var active bool
	if err := row.Scan(&active); err != nil {
		return err
	}
	if !active {
		return sql.ErrNoRows
	}
	return nil
}
