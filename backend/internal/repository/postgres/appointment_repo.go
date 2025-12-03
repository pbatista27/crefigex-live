package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type AppointmentRepository interface {
	Create(ctx context.Context, a *domain.Appointment) error
	ListByCustomer(ctx context.Context, customerID string) ([]domain.Appointment, error)
	ListByService(ctx context.Context, serviceID string) ([]domain.Appointment, error)
}

type appointmentRepo struct {
	db *sql.DB
}

func NewAppointmentRepository(db *sql.DB) AppointmentRepository {
	return &appointmentRepo{db: db}
}

func (r *appointmentRepo) Create(ctx context.Context, a *domain.Appointment) error {
	return r.db.QueryRowContext(ctx, `
		INSERT INTO appointments (service_id, customer_id, vendor_id, scheduled_at, status)
		VALUES ($1,$2,$3,$4,$5)
		RETURNING id, created_at
	`, a.ServiceID, a.CustomerID, a.VendorID, a.ScheduledAt, a.Status).
		Scan(&a.ID, &a.CreatedAt)
}
func (r *appointmentRepo) ListByCustomer(ctx context.Context, customerID string) ([]domain.Appointment, error) {
	rows, err := r.db.QueryContext(ctx, `
		SELECT id, service_id, customer_id, vendor_id, scheduled_at, status, created_at
		FROM appointments WHERE customer_id = $1
		ORDER BY scheduled_at DESC
	`, customerID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []domain.Appointment
	for rows.Next() {
		var a domain.Appointment
		if err := rows.Scan(&a.ID, &a.ServiceID, &a.CustomerID, &a.VendorID, &a.ScheduledAt, &a.Status, &a.CreatedAt); err != nil {
			return nil, err
		}
		list = append(list, a)
	}
	return list, nil
}

func (r *appointmentRepo) ListByService(ctx context.Context, serviceID string) ([]domain.Appointment, error) {
	rows, err := r.db.QueryContext(ctx, `
		SELECT id, service_id, customer_id, vendor_id, scheduled_at, status, created_at
		FROM appointments WHERE service_id = $1
		ORDER BY scheduled_at DESC
	`, serviceID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []domain.Appointment
	for rows.Next() {
		var a domain.Appointment
		if err := rows.Scan(&a.ID, &a.ServiceID, &a.CustomerID, &a.VendorID, &a.ScheduledAt, &a.Status, &a.CreatedAt); err != nil {
			return nil, err
		}
		list = append(list, a)
	}
	return list, nil
}
