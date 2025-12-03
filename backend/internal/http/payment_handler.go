package http

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/service"
)

type PaymentHandler struct {
	payments *service.PaymentService
}

func NewPaymentHandler(payments *service.PaymentService) *PaymentHandler {
	return &PaymentHandler{payments: payments}
}

func (h *PaymentHandler) Register(c *gin.Context) {
	var req domain.Payment
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	req.OrderID = c.Param("id")
	if req.Amount <= 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "amount required"})
		return
	}
	if err := h.payments.Register(c.Request.Context(), &req); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"payment": req})
}

func (h *PaymentHandler) ListInstallments(c *gin.Context) {
	data, err := h.payments.ListInstallmentsByCustomer(c.Request.Context(), c.GetString("userID"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": data})
}
