package service

import (
	"context"
	"errors"
	"time"

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
	available, _ := s.AvailableSlots(ctx, a.ServiceID)
	slot := a.ScheduledAt.Format(time.RFC3339)
	ok := false
	for _, v := range available {
		if v == slot {
			ok = true
			break
		}
	}
	if !ok {
		return errors.New("slot no disponible")
	}
	return s.appointments.Create(ctx, a)
}

func (s *AppointmentService) ListByCustomer(ctx context.Context, customerID string) ([]domain.Appointment, error) {
	return s.appointments.ListByCustomer(ctx, customerID)
}

func (s *AppointmentService) AvailableSlots(ctx context.Context, serviceID string) ([]string, error) {
	existing, err := s.appointments.ListByService(ctx, serviceID)
	if err != nil {
		return nil, err
	}
	busy := map[string]bool{}
	for _, a := range existing {
		busy[a.ScheduledAt.Format(time.RFC3339)] = true
	}

	now := time.Now().Add(24 * time.Hour).Truncate(time.Hour)
	var slots []string
	for d := 0; d < 5; d++ {
		for h := 9; h <= 17; h += 2 {
			slot := time.Date(now.Year(), now.Month(), now.Day()+d, h, 0, 0, 0, now.Location())
			key := slot.Format(time.RFC3339)
			if !busy[key] {
				slots = append(slots, key)
			}
		}
	}
	return slots, nil
}
