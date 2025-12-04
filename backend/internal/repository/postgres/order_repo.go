package postgres

import (
	"context"
	"database/sql"
	"time"

	"github.com/crefigex/live/backend/internal/domain"
)

type OrderRepository interface {
	Create(ctx context.Context, o *domain.Order, items []domain.OrderItem) error
	ListByCustomer(ctx context.Context, customerID string) ([]domain.Order, error)
	ListAdmin(ctx context.Context) ([]OrderAdminView, error)
	Get(ctx context.Context, id string) (*domain.Order, error)
	HasPurchasedProduct(ctx context.Context, customerID, productID string) (bool, error)
	HasPurchasedVideo(ctx context.Context, customerID, videoID string) (bool, error)
}

type orderRepo struct {
	db *sql.DB
}

// OrderAdminView represents an order with display-friendly fields for admins.
type OrderAdminView struct {
	ID           string             `json:"id"`
	CustomerName string             `json:"customer_name"`
	VendorName   string             `json:"vendor_name"`
	Status       domain.OrderStatus `json:"status"`
	PaymentPlan  string             `json:"payment_plan"`
	TotalAmount  int64              `json:"total_amount"`
	CreatedAt    time.Time          `json:"created_at"`
}

func NewOrderRepository(db *sql.DB) OrderRepository {
	return &orderRepo{db: db}
}

func (r *orderRepo) Create(ctx context.Context, o *domain.Order, items []domain.OrderItem) error {
	tx, err := r.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	if err := tx.QueryRowContext(ctx, `
		INSERT INTO orders (customer_id, vendor_id, delivery_type, shipping_address, status, total_amount, payment_plan_id)
		VALUES ($1,$2,$3,$4,$5,$6,$7)
		RETURNING id, created_at
	`, o.CustomerID, o.VendorID, o.DeliveryType, o.ShippingAddress, o.Status, o.TotalAmount, o.PaymentPlanID).
		Scan(&o.ID, &o.CreatedAt); err != nil {
		return err
	}

	for i := range items {
		items[i].OrderID = o.ID
		if err := tx.QueryRowContext(ctx, `
			INSERT INTO order_items (order_id, product_id, service_id, quantity, unit_price, total)
			VALUES ($1,$2,$3,$4,$5,$6)
			RETURNING id
		`, items[i].OrderID, items[i].ProductID, items[i].ServiceID, items[i].Quantity, items[i].UnitPrice, items[i].Total).
			Scan(&items[i].ID); err != nil {
			return err
		}
	}

	return tx.Commit()
}

func (r *orderRepo) ListByCustomer(ctx context.Context, customerID string) ([]domain.Order, error) {
	rows, err := r.db.QueryContext(ctx, `
		SELECT id, customer_id, vendor_id, delivery_type, shipping_address, status, total_amount, payment_plan_id, created_at
		FROM orders WHERE customer_id = $1
		ORDER BY created_at DESC
	`, customerID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []domain.Order
	for rows.Next() {
		var o domain.Order
		if err := rows.Scan(&o.ID, &o.CustomerID, &o.VendorID, &o.DeliveryType, &o.ShippingAddress, &o.Status, &o.TotalAmount, &o.PaymentPlanID, &o.CreatedAt); err != nil {
			return nil, err
		}
		list = append(list, o)
	}
	return list, nil
}

func (r *orderRepo) ListAdmin(ctx context.Context) ([]OrderAdminView, error) {
	rows, err := r.db.QueryContext(ctx, `
		SELECT
			o.id,
			COALESCE(u.name, u.email) AS customer_name,
			COALESCE(v.name, v.email) AS vendor_name,
			o.status,
			COALESCE(p.name, '') AS payment_plan,
			o.total_amount,
			o.created_at
		FROM orders o
		LEFT JOIN users u ON u.id = o.customer_id
		LEFT JOIN vendors v ON v.id = o.vendor_id
		LEFT JOIN payment_plans p ON p.id = o.payment_plan_id
		ORDER BY o.created_at DESC
	`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []OrderAdminView
	for rows.Next() {
		var o OrderAdminView
		if err := rows.Scan(&o.ID, &o.CustomerName, &o.VendorName, &o.Status, &o.PaymentPlan, &o.TotalAmount, &o.CreatedAt); err != nil {
			return nil, err
		}
		list = append(list, o)
	}
	return list, nil
}

func (r *orderRepo) Get(ctx context.Context, id string) (*domain.Order, error) {
	row := r.db.QueryRowContext(ctx, `
		SELECT id, customer_id, vendor_id, delivery_type, shipping_address, status, total_amount, payment_plan_id, created_at
		FROM orders WHERE id = $1
	`, id)
	var o domain.Order
	if err := row.Scan(&o.ID, &o.CustomerID, &o.VendorID, &o.DeliveryType, &o.ShippingAddress, &o.Status, &o.TotalAmount, &o.PaymentPlanID, &o.CreatedAt); err != nil {
		return nil, err
	}
	return &o, nil
}

func (r *orderRepo) HasPurchasedProduct(ctx context.Context, customerID, productID string) (bool, error) {
	row := r.db.QueryRowContext(ctx, `
		SELECT 1 FROM orders o
		INNER JOIN order_items oi ON oi.order_id = o.id
		WHERE o.customer_id = $1 AND oi.product_id = $2 AND o.status != $3
		LIMIT 1
	`, customerID, productID, domain.OrderCancelled)
	var dummy int
	if err := row.Scan(&dummy); err != nil {
		if err == sql.ErrNoRows {
			return false, nil
		}
		return false, err
	}
	return true, nil
}

func (r *orderRepo) HasPurchasedVideo(ctx context.Context, customerID, videoID string) (bool, error) {
	row := r.db.QueryRowContext(ctx, `
		SELECT 1
		FROM orders o
		INNER JOIN order_items oi ON oi.order_id = o.id
		LEFT JOIN video_products vp ON vp.product_id = oi.product_id
		LEFT JOIN video_services vs ON vs.service_id = oi.service_id
		WHERE o.customer_id = $1
		AND (vp.video_id = $2 OR vs.video_id = $2)
		AND o.status != $3
		LIMIT 1
	`, customerID, videoID, domain.OrderCancelled)
	var dummy int
	if err := row.Scan(&dummy); err != nil {
		if err == sql.ErrNoRows {
			return false, nil
		}
		return false, err
	}
	return true, nil
}
