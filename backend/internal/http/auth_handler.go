package http

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/repository/postgres"
	"github.com/crefigex/live/backend/internal/service"
)

type AuthHandler struct {
	auth    *service.AuthService
	users   postgres.UserRepository
	vendors postgres.VendorRepository
}

func NewAuthHandler(auth *service.AuthService, users postgres.UserRepository, vendors postgres.VendorRepository) *AuthHandler {
	return &AuthHandler{auth: auth, users: users, vendors: vendors}
}

func (h *AuthHandler) Register(c *gin.Context) {
	var req struct {
		Name     string        `json:"name"`
		Email    string        `json:"email"`
		Phone    string        `json:"phone"`
		Password string        `json:"password"`
		Roles    []domain.Role `json:"roles"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	user := &domain.User{
		Name:     req.Name,
		Email:    req.Email,
		Phone:    req.Phone,
		Password: req.Password,
		Roles:    req.Roles,
	}
	if _, err := h.auth.Register(c.Request.Context(), user); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"user": user})
}

func (h *AuthHandler) Login(c *gin.Context) {
	var req struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	token, err := h.auth.Login(c.Request.Context(), req.Email, req.Password)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"token": token})
}

func (h *AuthHandler) Me(c *gin.Context) {
	userID := c.GetString("userID")
	user, _ := h.users.GetByID(c.Request.Context(), userID)
	roles := c.GetStringSlice("roles")
	var vendorType string
	var vendorStatus string
	if v, err := h.vendors.GetByUser(c.Request.Context(), userID); err == nil && v != nil {
		vendorType = string(v.Type)
		vendorStatus = string(v.Status)
	}
	c.JSON(http.StatusOK, gin.H{
		"user": gin.H{
			"id":            userID,
			"email":         user.Email,
			"name":          user.Name,
			"phone":         user.Phone,
			"roles":         roles,
			"vendor_type":   vendorType,
			"vendor_status": vendorStatus,
		},
	})
}

func (h *AuthHandler) Refresh(c *gin.Context) {
	userID := c.GetString("userID")
	roles := c.GetStringSlice("roles")
	token, err := h.auth.Refresh(c.Request.Context(), userID, roles)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"token": token})
}
