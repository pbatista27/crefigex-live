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
	c.JSON(http.StatusCreated, gin.H{"status": "added"})
}

func (h *OrderHandler) ViewCart(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"items": []string{}})
}

func (h *OrderHandler) Checkout(c *gin.Context) {
	var req struct {
		VendorID string `json:"vendor_id"`
		Items    []domain.OrderItem `json:"items"`
		DeliveryType domain.DeliveryType `json:"delivery_type"`
		ShippingAddress string `json:"shipping_address"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	order := &domain.Order{
		CustomerID: c.GetString("userID"),
		VendorID:   req.VendorID,
		DeliveryType: req.DeliveryType,
		ShippingAddress: req.ShippingAddress,
		Status:    domain.OrderPending,
	}
	if err := h.orders.Checkout(c.Request.Context(), order, req.Items); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"order": order})
}

func (h *OrderHandler) ListMine(c *gin.Context) {
	data, _ := h.orders.ListByCustomer(c.Request.Context(), c.GetString("userID"))
	c.JSON(http.StatusOK, gin.H{"data": data})
}
