package http

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/service"
)

type OrderHandler struct {
	orders *service.OrderService
}

func NewOrderHandler(orders *service.OrderService) *OrderHandler {
	return &OrderHandler{orders: orders}
}

func (h *OrderHandler) AddToCart(c *gin.Context) {
	var req struct {
		VendorID  string `json:"vendor_id" binding:"required"`
		ProductID string `json:"product_id"`
		ServiceID string `json:"service_id"`
		Quantity  int    `json:"quantity" binding:"required"`
		UnitPrice int64  `json:"unit_price"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	item := &domain.CartItem{
		UserID:    c.GetString("userID"),
		VendorID:  req.VendorID,
		ProductID: req.ProductID,
		ServiceID: req.ServiceID,
		Quantity:  req.Quantity,
		UnitPrice: req.UnitPrice,
		Total:     int64(req.Quantity) * req.UnitPrice,
	}
	if err := h.orders.AddToCart(c.Request.Context(), item); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"item": item})
}

func (h *OrderHandler) ViewCart(c *gin.Context) {
	vendorID := c.Query("vendor_id")
	if vendorID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "vendor_id is required"})
		return
	}
	items, err := h.orders.ViewCart(c.Request.Context(), c.GetString("userID"), vendorID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": items})
}

func (h *OrderHandler) Checkout(c *gin.Context) {
	var req struct {
		VendorID        string              `json:"vendor_id"`
		Items           []domain.OrderItem  `json:"items"`
		DeliveryType    domain.DeliveryType `json:"delivery_type"`
		ShippingAddress string              `json:"shipping_address"`
		PaymentPlanID   string              `json:"payment_plan_id"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	items := req.Items
	if len(items) == 0 {
		cartItems, err := h.orders.ViewCart(c.Request.Context(), c.GetString("userID"), req.VendorID)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		for _, ci := range cartItems {
			items = append(items, domain.OrderItem{
				ProductID: ci.ProductID,
				ServiceID: ci.ServiceID,
				Quantity:  ci.Quantity,
				UnitPrice: ci.UnitPrice,
				Total:     ci.Total,
			})
		}
	}
	order := &domain.Order{
		CustomerID:      c.GetString("userID"),
		VendorID:        req.VendorID,
		DeliveryType:    req.DeliveryType,
		ShippingAddress: req.ShippingAddress,
		PaymentPlanID:   req.PaymentPlanID,
		Status:          domain.OrderPending,
	}
	if err := h.orders.Checkout(c.Request.Context(), order, items); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	_ = h.orders.ClearCart(c.Request.Context(), c.GetString("userID"), req.VendorID)
	_ = h.orders.GenerateInstallments(c.Request.Context(), order)
	c.JSON(http.StatusCreated, gin.H{"order": order})
}

func (h *OrderHandler) ListMine(c *gin.Context) {
	data, _ := h.orders.ListByCustomer(c.Request.Context(), c.GetString("userID"))
	c.JSON(http.StatusOK, gin.H{"data": data})
}

func (h *OrderHandler) ListAdmin(c *gin.Context) {
	data, err := h.orders.ListAdmin(c.Request.Context())
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": data})
}
