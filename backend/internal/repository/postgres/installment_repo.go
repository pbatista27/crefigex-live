package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type InstallmentRepository interface {
	CreateBulk(ctx context.Context, list []domain.Installment) error
	ListByCustomer(ctx context.Context, customerID string) ([]domain.Installment, error)
	MarkPaid(ctx context.Context, installmentID string) error
}

type installmentRepo struct {
	db *sql.DB
}

func NewInstallmentRepository(db *sql.DB) InstallmentRepository {
	return &installmentRepo{db: db}
}

func (r *installmentRepo) CreateBulk(ctx context.Context, list []domain.Installment) error {
	tx, err := r.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	for i := range list {
		if err := tx.QueryRowContext(ctx, `
			INSERT INTO installments (order_id, amount, due_date, paid)
			VALUES ($1,$2,$3,$4)
			RETURNING id, created_at
		`, list[i].OrderID, list[i].Amount, list[i].DueDate, list[i].Paid).
			Scan(&list[i].ID, &list[i].CreatedAt); err != nil {
			return err
		}
	}

	return tx.Commit()
}

func (r *installmentRepo) ListByCustomer(ctx context.Context, customerID string) ([]domain.Installment, error) {
	rows, err := r.db.QueryContext(ctx, `
		SELECT ins.id, ins.order_id, ins.amount, ins.due_date, ins.paid, ins.created_at
		FROM installments ins
		INNER JOIN orders o ON o.id = ins.order_id
		WHERE o.customer_id = $1
		ORDER BY ins.due_date ASC
	`, customerID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []domain.Installment
	for rows.Next() {
		var ins domain.Installment
		if err := rows.Scan(&ins.ID, &ins.OrderID, &ins.Amount, &ins.DueDate, &ins.Paid, &ins.CreatedAt); err != nil {
			return nil, err
		}
		list = append(list, ins)
	}
	return list, nil
}

func (r *installmentRepo) MarkPaid(ctx context.Context, installmentID string) error {
	_, err := r.db.ExecContext(ctx, `UPDATE installments SET paid = TRUE WHERE id = $1`, installmentID)
	return err
}
