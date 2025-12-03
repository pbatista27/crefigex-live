package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type PaymentPlanRepository interface {
	Get(ctx context.Context, id string) (*domain.PaymentPlan, error)
}

type paymentPlanRepo struct {
	db *sql.DB
}

func NewPaymentPlanRepository(db *sql.DB) PaymentPlanRepository {
	return &paymentPlanRepo{db: db}
}

func (r *paymentPlanRepo) Get(ctx context.Context, id string) (*domain.PaymentPlan, error) {
	row := r.db.QueryRowContext(ctx, `
		SELECT id, name, initial_percentage, installments, days_between
		FROM payment_plans WHERE id = $1
	`, id)
	var p domain.PaymentPlan
	if err := row.Scan(&p.ID, &p.Name, &p.InitialPercentage, &p.Installments, &p.DaysBetween); err != nil {
		return nil, err
	}
	return &p, nil
}
