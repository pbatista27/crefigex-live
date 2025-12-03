package http

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type ReportingHandler struct{}

func NewReportingHandler() *ReportingHandler { return &ReportingHandler{} }

func (h *ReportingHandler) Summary(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"gmv_7d":              48200,
		"orders_bnpl":         312,
		"avg_ticket":          154,
		"deliveries_complete": 1204,
		"top_categories": []gin.H{
			{"name": "Electrónica", "gmv": 18000},
			{"name": "Moda", "gmv": 9600},
		},
	})
}
