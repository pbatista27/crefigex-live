package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type DeliveryRepository interface {
	Create(ctx context.Context, d *domain.Delivery) error
	UpdateStatus(ctx context.Context, id string, status domain.DeliveryStatus, photoURL string) error
	UpdateStatusByOrder(ctx context.Context, orderID string, status domain.DeliveryStatus) error
	ListByVendor(ctx context.Context, vendorID string) ([]domain.Delivery, error)
	ListByCustomer(ctx context.Context, customerID string) ([]domain.Delivery, error)
	ListByType(ctx context.Context, deliveryType domain.DeliveryType) ([]domain.Delivery, error)
	Get(ctx context.Context, id string) (*domain.Delivery, error)
}

type deliveryRepo struct {
	db *sql.DB
}

func NewDeliveryRepository(db *sql.DB) DeliveryRepository {
	return &deliveryRepo{db: db}
}

func (r *deliveryRepo) Create(ctx context.Context, d *domain.Delivery) error {
	return r.db.QueryRowContext(ctx, `
		INSERT INTO deliveries (order_id, vendor_id, customer_id, delivery_type, status, photo_url, customer_confirmed)
		VALUES ($1,$2,$3,$4,$5,$6,$7)
		RETURNING id, created_at, updated_at
	`, d.OrderID, d.VendorID, d.CustomerID, d.DeliveryType, d.Status, d.PhotoURL, d.CustomerConfirmed).
		Scan(&d.ID, &d.CreatedAt, &d.UpdatedAt)
}
func (r *deliveryRepo) UpdateStatus(ctx context.Context, id string, status domain.DeliveryStatus, photoURL string) error {
	_, err := r.db.ExecContext(ctx, `
		UPDATE deliveries SET status=$1, photo_url=COALESCE(NULLIF($2,''), photo_url), updated_at=now() WHERE id=$3
	`, status, photoURL, id)
	return err
}
func (r *deliveryRepo) UpdateStatusByOrder(ctx context.Context, orderID string, status domain.DeliveryStatus) error {
	_, err := r.db.ExecContext(ctx, `UPDATE deliveries SET status=$1, updated_at=now() WHERE order_id=$2`, status, orderID)
	return err
}
func (r *deliveryRepo) ListByVendor(ctx context.Context, vendorID string) ([]domain.Delivery, error) {
	rows, err := r.db.QueryContext(ctx, `
		SELECT id, order_id, vendor_id, customer_id, delivery_type, status, photo_url, customer_confirmed, created_at, updated_at
		FROM deliveries WHERE vendor_id = $1
	`, vendorID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []domain.Delivery
	for rows.Next() {
		var d domain.Delivery
		if err := rows.Scan(&d.ID, &d.OrderID, &d.VendorID, &d.CustomerID, &d.DeliveryType, &d.Status, &d.PhotoURL, &d.CustomerConfirmed, &d.CreatedAt, &d.UpdatedAt); err != nil {
			return nil, err
		}
		list = append(list, d)
	}
	return list, nil
}
func (r *deliveryRepo) ListByCustomer(ctx context.Context, customerID string) ([]domain.Delivery, error) {
	rows, err := r.db.QueryContext(ctx, `
		SELECT id, order_id, vendor_id, customer_id, delivery_type, status, photo_url, customer_confirmed, created_at, updated_at
		FROM deliveries WHERE customer_id = $1
	`, customerID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []domain.Delivery
	for rows.Next() {
		var d domain.Delivery
		if err := rows.Scan(&d.ID, &d.OrderID, &d.VendorID, &d.CustomerID, &d.DeliveryType, &d.Status, &d.PhotoURL, &d.CustomerConfirmed, &d.CreatedAt, &d.UpdatedAt); err != nil {
			return nil, err
		}
		list = append(list, d)
	}
	return list, nil
}
func (r *deliveryRepo) ListByType(ctx context.Context, deliveryType domain.DeliveryType) ([]domain.Delivery, error) {
	rows, err := r.db.QueryContext(ctx, `
		SELECT id, order_id, vendor_id, customer_id, delivery_type, status, photo_url, customer_confirmed, created_at, updated_at
		FROM deliveries WHERE delivery_type = $1
	`, deliveryType)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var list []domain.Delivery
	for rows.Next() {
		var d domain.Delivery
		if err := rows.Scan(&d.ID, &d.OrderID, &d.VendorID, &d.CustomerID, &d.DeliveryType, &d.Status, &d.PhotoURL, &d.CustomerConfirmed, &d.CreatedAt, &d.UpdatedAt); err != nil {
			return nil, err
		}
		list = append(list, d)
	}
	return list, nil
}
func (r *deliveryRepo) Get(ctx context.Context, id string) (*domain.Delivery, error) {
	row := r.db.QueryRowContext(ctx, `
		SELECT id, order_id, vendor_id, customer_id, delivery_type, status, photo_url, customer_confirmed, created_at, updated_at
		FROM deliveries WHERE id = $1
	`, id)
	var d domain.Delivery
	if err := row.Scan(&d.ID, &d.OrderID, &d.VendorID, &d.CustomerID, &d.DeliveryType, &d.Status, &d.PhotoURL, &d.CustomerConfirmed, &d.CreatedAt, &d.UpdatedAt); err != nil {
		return nil, err
	}
	return &d, nil
}
