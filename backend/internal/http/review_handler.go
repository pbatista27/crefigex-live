package http

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/service"
)

type ReviewHandler struct {
	reviews *service.ReviewService
}

func NewReviewHandler(reviews *service.ReviewService) *ReviewHandler {
	return &ReviewHandler{reviews: reviews}
}

func (h *ReviewHandler) ListVideoReviews(c *gin.Context) {
	data, _ := h.reviews.ListVideoReviews(c.Request.Context(), c.Param("id"))
	c.JSON(http.StatusOK, gin.H{"data": data})
}

func (h *ReviewHandler) CreateVideoReview(c *gin.Context) {
	var req domain.VideoReview
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	req.VideoID = c.Param("id")
	req.CustomerID = c.GetString("userID")
	if err := h.reviews.CreateVideoReview(c.Request.Context(), &req); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"review": req})
}

func (h *ReviewHandler) ListProductReviews(c *gin.Context) {
	data, _ := h.reviews.ListProductReviews(c.Request.Context(), c.Param("id"))
	c.JSON(http.StatusOK, gin.H{"data": data})
}

func (h *ReviewHandler) CreateProductReview(c *gin.Context) {
	var req domain.ProductReview
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	req.ProductID = c.Param("id")
	req.CustomerID = c.GetString("userID")
	if err := h.reviews.CreateProductReview(c.Request.Context(), &req); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"review": req})
}
