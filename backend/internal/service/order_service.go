package service

import (
	"context"
	"errors"
	"time"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/repository/postgres"
)

type OrderService struct {
	orders       postgres.OrderRepository
	deliveries   postgres.DeliveryRepository
	cart         postgres.CartRepository
	plans        postgres.PaymentPlanRepository
	installments postgres.InstallmentRepository
	products     postgres.ProductRepository
	services     postgres.ServiceRepository
}

func NewOrderService(orders postgres.OrderRepository, deliveries postgres.DeliveryRepository, cart postgres.CartRepository, plans postgres.PaymentPlanRepository, installments postgres.InstallmentRepository, products postgres.ProductRepository, services postgres.ServiceRepository) *OrderService {
	return &OrderService{
		orders:       orders,
		deliveries:   deliveries,
		cart:         cart,
		plans:        plans,
		installments: installments,
		products:     products,
		services:     services,
	}
}

func (s *OrderService) Checkout(ctx context.Context, o *domain.Order, items []domain.OrderItem) error {
	if len(items) == 0 {
		return errors.New("no hay items en la orden")
	}
	var total int64
	for i := range items {
		if items[i].Total == 0 {
			items[i].Total = int64(items[i].Quantity) * items[i].UnitPrice
		}
		total += items[i].Total
		if items[i].ProductID != "" {
			if err := s.products.DecreaseStock(ctx, items[i].ProductID, items[i].Quantity); err != nil {
				return errors.New("stock insuficiente")
			}
		}
		if items[i].ServiceID != "" {
			if err := s.services.ValidateAvailability(ctx, items[i].ServiceID); err != nil {
				return errors.New("servicio no disponible")
			}
		}
	}
	o.TotalAmount = total
	if o.PaymentPlanID != "" {
		if _, err := s.plans.Get(ctx, o.PaymentPlanID); err != nil {
			return errors.New("plan BNPL inválido")
		}
	}
	if err := s.orders.Create(ctx, o, items); err != nil {
		return err
	}
	d := &domain.Delivery{
		ID:           "",
		OrderID:      o.ID,
		VendorID:     o.VendorID,
		CustomerID:   o.CustomerID,
		DeliveryType: o.DeliveryType,
		Status:       domain.DeliveryWaitingPayment,
	}
	return s.deliveries.Create(ctx, d)
}

func (s *OrderService) ListByCustomer(ctx context.Context, customerID string) ([]domain.Order, error) {
	return s.orders.ListByCustomer(ctx, customerID)
}

func (s *OrderService) ListAdmin(ctx context.Context) ([]postgres.OrderAdminView, error) {
	return s.orders.ListAdmin(ctx)
}

func (s *OrderService) AddToCart(ctx context.Context, item *domain.CartItem) error {
	return s.cart.AddItem(ctx, item)
}

func (s *OrderService) ViewCart(ctx context.Context, userID, vendorID string) ([]domain.CartItem, error) {
	return s.cart.List(ctx, userID, vendorID)
}

func (s *OrderService) ClearCart(ctx context.Context, userID, vendorID string) error {
	return s.cart.Clear(ctx, userID, vendorID)
}

func (s *OrderService) GenerateInstallments(ctx context.Context, order *domain.Order) error {
	if order.PaymentPlanID == "" {
		return nil
	}
	plan, err := s.plans.Get(ctx, order.PaymentPlanID)
	if err != nil {
		return err
	}
	now := time.Now()
	var list []domain.Installment
	if plan.Installments <= 0 {
		plan.Installments = 1
	}
	initialAmount := int64(float64(order.TotalAmount) * (plan.InitialPercentage / 100))
	if initialAmount <= 0 {
		initialAmount = order.TotalAmount / int64(plan.Installments)
	}
	remaining := order.TotalAmount - initialAmount
	remainingCount := plan.Installments - 1
	for i := 0; i < plan.Installments; i++ {
		amount := initialAmount
		if i > 0 {
			if remainingCount > 0 {
				amount = remaining / int64(remainingCount)
			} else {
				amount = remaining
			}
		}
		inst := domain.Installment{
			OrderID: order.ID,
			Amount:  amount,
			DueDate: now.Add(time.Duration(plan.DaysBetween*i) * 24 * time.Hour),
		}
		list = append(list, inst)
		remaining -= amount
		remainingCount--
	}
	return s.installments.CreateBulk(ctx, list)
}
