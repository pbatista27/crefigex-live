package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type AppointmentRepository interface {
	Create(ctx context.Context, a *domain.Appointment) error
	ListByCustomer(ctx context.Context, customerID string) ([]domain.Appointment, error)
}

type appointmentRepo struct {
	db *sql.DB
}

func NewAppointmentRepository(db *sql.DB) AppointmentRepository {
	return &appointmentRepo{db: db}
}

func (r *appointmentRepo) Create(ctx context.Context, a *domain.Appointment) error { return nil }
func (r *appointmentRepo) ListByCustomer(ctx context.Context, customerID string) ([]domain.Appointment, error) {
	return []domain.Appointment{}, nil
}
