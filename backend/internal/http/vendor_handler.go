package http

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/service"
)

type VendorHandler struct {
	vendors *service.VendorService
}

func NewVendorHandler(vendors *service.VendorService) *VendorHandler {
	return &VendorHandler{vendors: vendors}
}

func (h *VendorHandler) Register(c *gin.Context) {
	var req struct {
		Name        string            `json:"name"`
		Phone       string            `json:"phone"`
		Address     string            `json:"address"`
		CategoryID  string            `json:"category_id"`
		Description string            `json:"description"`
		Type        domain.VendorType `json:"type"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	v := &domain.Vendor{
		Name:        req.Name,
		Phone:       req.Phone,
		Address:     req.Address,
		CategoryID:  req.CategoryID,
		Description: req.Description,
		Type:        req.Type,
		Status:      domain.VendorStatusPending,
	}
	if err := h.vendors.Register(c.Request.Context(), v); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"vendor": v})
}

func (h *VendorHandler) List(c *gin.Context) {
	vendors, _ := h.vendors.List(c.Request.Context(), "")
	c.JSON(http.StatusOK, gin.H{"data": vendors})
}

func (h *VendorHandler) Get(c *gin.Context) {
	v, err := h.vendors.Get(c.Request.Context(), c.Param("id"))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "not found"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"vendor": v})
}

func (h *VendorHandler) AdminList(c *gin.Context) {
	status := domain.VendorStatus(c.Query("status"))
	vendors, _ := h.vendors.List(c.Request.Context(), status)
	c.JSON(http.StatusOK, gin.H{"data": vendors})
}

func (h *VendorHandler) Approve(c *gin.Context) {
	_ = h.vendors.Approve(c.Request.Context(), c.Param("id"))
	c.Status(http.StatusNoContent)
}

func (h *VendorHandler) Reject(c *gin.Context) {
	_ = h.vendors.Reject(c.Request.Context(), c.Param("id"))
	c.Status(http.StatusNoContent)
}

func (h *VendorHandler) Suspend(c *gin.Context) {
	_ = h.vendors.Reject(c.Request.Context(), c.Param("id"))
	c.Status(http.StatusNoContent)
}
