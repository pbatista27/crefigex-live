package http

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/repository/postgres"
)

type CrefigexHandler struct {
	deliveries postgres.DeliveryRepository
}

func NewCrefigexHandler(deliveries postgres.DeliveryRepository) *CrefigexHandler {
	return &CrefigexHandler{deliveries: deliveries}
}

func (h *CrefigexHandler) List(c *gin.Context) {
	data, err := h.deliveries.ListByType(c.Request.Context(), domain.DeliveryCrefigex)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": data})
}
