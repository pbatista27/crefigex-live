package http

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/service"
)

type AppointmentHandler struct {
	appointments *service.AppointmentService
}

func NewAppointmentHandler(appointments *service.AppointmentService) *AppointmentHandler {
	return &AppointmentHandler{appointments: appointments}
}

func (h *AppointmentHandler) ListSlots(c *gin.Context) {
	// Placeholder static slots
	c.JSON(http.StatusOK, gin.H{"slots": []string{"2024-01-01T10:00:00Z", "2024-01-01T14:00:00Z"}})
}

func (h *AppointmentHandler) Create(c *gin.Context) {
	var req domain.Appointment
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	req.CustomerID = c.GetString("userID")
	if err := h.appointments.Create(c.Request.Context(), &req); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"appointment": req})
}

func (h *AppointmentHandler) ListMine(c *gin.Context) {
	data, _ := h.appointments.ListByCustomer(c.Request.Context(), c.GetString("userID"))
	c.JSON(http.StatusOK, gin.H{"data": data})
}
