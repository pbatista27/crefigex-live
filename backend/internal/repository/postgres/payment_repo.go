package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type PaymentRepository interface {
	Create(ctx context.Context, p *domain.Payment) error
	ListByOrder(ctx context.Context, orderID string) ([]domain.Payment, error)
}

type paymentRepo struct {
	db *sql.DB
}

func NewPaymentRepository(db *sql.DB) PaymentRepository {
	return &paymentRepo{db: db}
}

func (r *paymentRepo) Create(ctx context.Context, p *domain.Payment) error {
	return r.db.QueryRowContext(ctx, `
		INSERT INTO payments (order_id, installment_id, amount, method, reference, bank_origin, bank_dest)
		VALUES ($1,$2,$3,$4,$5,$6,$7)
		RETURNING id, created_at
	`, p.OrderID, p.InstallmentID, p.Amount, p.Method, p.Reference, p.BankOrigin, p.BankDest).
		Scan(&p.ID, &p.CreatedAt)
}
func (r *paymentRepo) ListByOrder(ctx context.Context, orderID string) ([]domain.Payment, error) {
	rows, err := r.db.QueryContext(ctx, `
		SELECT id, order_id, installment_id, amount, method, reference, bank_origin, bank_dest, created_at
		FROM payments WHERE order_id = $1
	`, orderID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []domain.Payment
	for rows.Next() {
		var p domain.Payment
		if err := rows.Scan(&p.ID, &p.OrderID, &p.InstallmentID, &p.Amount, &p.Method, &p.Reference, &p.BankOrigin, &p.BankDest, &p.CreatedAt); err != nil {
			return nil, err
		}
		list = append(list, p)
	}
	return list, nil
}
