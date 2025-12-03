package http

import (
	"net/http"
	"time"

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
	slots, err := h.appointments.AvailableSlots(c.Request.Context(), c.Param("id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"slots": slots})
}

func (h *AppointmentHandler) Create(c *gin.Context) {
	var req struct {
		ServiceID   string    `json:"service_id"`
		CustomerID  string    `json:"customer_id"`
		VendorID    string    `json:"vendor_id"`
		ScheduledAt time.Time `json:"scheduled_at"`
		Status      string    `json:"status"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	app := domain.Appointment{
		ServiceID:   req.ServiceID,
		CustomerID:  c.GetString("userID"),
		VendorID:    req.VendorID,
		ScheduledAt: req.ScheduledAt,
		Status:      req.Status,
	}
	if app.Status == "" {
		app.Status = "PENDING"
	}
	if err := h.appointments.Create(c.Request.Context(), &app); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"appointment": app})
}

func (h *AppointmentHandler) ListMine(c *gin.Context) {
	data, _ := h.appointments.ListByCustomer(c.Request.Context(), c.GetString("userID"))
	c.JSON(http.StatusOK, gin.H{"data": data})
}
