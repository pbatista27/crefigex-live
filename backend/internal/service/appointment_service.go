package service

import (
	"context"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/repository/postgres"
)

type AppointmentService struct {
	appointments postgres.AppointmentRepository
}

func NewAppointmentService(appointments postgres.AppointmentRepository) *AppointmentService {
	return &AppointmentService{appointments: appointments}
}

func (s *AppointmentService) Create(ctx context.Context, a *domain.Appointment) error {
	return s.appointments.Create(ctx, a)
}

func (s *AppointmentService) ListByCustomer(ctx context.Context, customerID string) ([]domain.Appointment, error) {
	return s.appointments.ListByCustomer(ctx, customerID)
}
