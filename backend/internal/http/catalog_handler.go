package http

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/service"
)

type CatalogHandler struct {
	catalog *service.CatalogService
}

func NewCatalogHandler(catalog *service.CatalogService) *CatalogHandler {
	return &CatalogHandler{catalog: catalog}
}

func (h *CatalogHandler) CreateProduct(c *gin.Context) {
	var req domain.Product
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	req.VendorID = c.GetString("userID")
	if err := h.catalog.CreateProduct(c.Request.Context(), &req); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"product": req})
}

func (h *CatalogHandler) UpdateProduct(c *gin.Context) {
	var req domain.Product
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	req.ID = c.Param("id")
	req.VendorID = c.GetString("userID")
	if err := h.catalog.UpdateProduct(c.Request.Context(), &req); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"product": req})
}

func (h *CatalogHandler) DeleteProduct(c *gin.Context) {
	_ = h.catalog.DeleteProduct(c.Request.Context(), c.Param("id"), c.GetString("userID"))
	c.Status(http.StatusNoContent)
}

func (h *CatalogHandler) ListVendorProducts(c *gin.Context) {
	data, _ := h.catalog.ListProducts(c.Request.Context(), c.Param("id"))
	c.JSON(http.StatusOK, gin.H{"data": data})
}

func (h *CatalogHandler) CreateService(c *gin.Context) {
	var req domain.Service
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	req.VendorID = c.GetString("userID")
	if err := h.catalog.CreateService(c.Request.Context(), &req); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"service": req})
}

func (h *CatalogHandler) UpdateService(c *gin.Context) {
	var req domain.Service
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	req.ID = c.Param("id")
	req.VendorID = c.GetString("userID")
	if err := h.catalog.UpdateService(c.Request.Context(), &req); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"service": req})
}

func (h *CatalogHandler) DeleteService(c *gin.Context) {
	_ = h.catalog.DeleteService(c.Request.Context(), c.Param("id"), c.GetString("userID"))
	c.Status(http.StatusNoContent)
}

func (h *CatalogHandler) ListVendorServices(c *gin.Context) {
	data, _ := h.catalog.ListServices(c.Request.Context(), c.Param("id"))
	c.JSON(http.StatusOK, gin.H{"data": data})
}
