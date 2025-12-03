package http

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/service"
)

type DeliveryHandler struct {
	deliveries *service.DeliveryService
}

func NewDeliveryHandler(deliveries *service.DeliveryService) *DeliveryHandler {
	return &DeliveryHandler{deliveries: deliveries}
}

func (h *DeliveryHandler) ListVendor(c *gin.Context) {
	data, _ := h.deliveries.ListByVendor(c.Request.Context(), c.GetString("userID"))
	c.JSON(http.StatusOK, gin.H{"data": data})
}

func (h *DeliveryHandler) GetVendor(c *gin.Context) {
	d, _ := h.deliveries.Get(c.Request.Context(), c.Param("id"))
	c.JSON(http.StatusOK, gin.H{"delivery": d})
}

func (h *DeliveryHandler) UpdateStatus(c *gin.Context) {
	var req struct {
		Status domain.DeliveryStatus `json:"status"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := h.deliveries.UpdateStatus(c.Request.Context(), c.Param("id"), req.Status, ""); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.Status(http.StatusNoContent)
}

func (h *DeliveryHandler) MarkDelivered(c *gin.Context) {
	var req struct {
		PhotoURL string `json:"photo_url"`
	}
	_ = c.ShouldBindJSON(&req)
	if err := h.deliveries.UpdateStatus(c.Request.Context(), c.Param("id"), domain.DeliveryDelivered, req.PhotoURL); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.Status(http.StatusNoContent)
}

func (h *DeliveryHandler) ListCustomer(c *gin.Context) {
	data, _ := h.deliveries.ListByCustomer(c.Request.Context(), c.GetString("userID"))
	c.JSON(http.StatusOK, gin.H{"data": data})
}

func (h *DeliveryHandler) GetCustomer(c *gin.Context) {
	d, _ := h.deliveries.Get(c.Request.Context(), c.Param("id"))
	c.JSON(http.StatusOK, gin.H{"delivery": d})
}

func (h *DeliveryHandler) ConfirmDelivery(c *gin.Context) {
	_ = h.deliveries.UpdateStatus(c.Request.Context(), c.Param("id"), domain.DeliveryConfirmed, "")
	c.Status(http.StatusNoContent)
}
