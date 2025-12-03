package http

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/crefigex/live/backend/internal/repository/postgres"
)

type CatalogGlobalHandler struct {
	products postgres.ProductRepository
	services postgres.ServiceRepository
}

func NewCatalogGlobalHandler(products postgres.ProductRepository, services postgres.ServiceRepository) *CatalogGlobalHandler {
	return &CatalogGlobalHandler{products: products, services: services}
}

func (h *CatalogGlobalHandler) ListProducts(c *gin.Context) {
	data, err := h.products.ListAll(c.Request.Context())
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": data})
}

func (h *CatalogGlobalHandler) ListServices(c *gin.Context) {
	data, err := h.services.ListAll(c.Request.Context())
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": data})
}

func (h *CatalogGlobalHandler) DeleteProductAny(c *gin.Context) {
	if err := h.products.DeleteAny(c.Request.Context(), c.Param("id")); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.Status(http.StatusNoContent)
}

func (h *CatalogGlobalHandler) DeleteServiceAny(c *gin.Context) {
	if err := h.services.DeleteAny(c.Request.Context(), c.Param("id")); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.Status(http.StatusNoContent)
}
