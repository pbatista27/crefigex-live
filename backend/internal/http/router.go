package http

import (
	"database/sql"
	"log"

	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"

	"github.com/crefigex/live/backend/internal/auth"
	"github.com/crefigex/live/backend/internal/config"
	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/repository/postgres"
	"github.com/crefigex/live/backend/internal/service"
)

// NewRouter wires dependencies and registers routes.
func NewRouter(cfg *config.Config) *gin.Engine {
	db, err := sql.Open("postgres", cfg.DBURL)
	if err != nil {
		log.Fatalf("db open: %v", err)
	}

	userRepo := postgres.NewUserRepository(db)
	vendorRepo := postgres.NewVendorRepository(db)
	productRepo := postgres.NewProductRepository(db)
	serviceRepo := postgres.NewServiceRepository(db)
	videoRepo := postgres.NewVideoRepository(db)
	reviewRepo := postgres.NewReviewRepository(db)
	chatRepo := postgres.NewChatRepository(db)
	orderRepo := postgres.NewOrderRepository(db)
	paymentRepo := postgres.NewPaymentRepository(db)
	deliveryRepo := postgres.NewDeliveryRepository(db)
	appointmentRepo := postgres.NewAppointmentRepository(db)

	authSvc := service.NewAuthService(userRepo, cfg.JWTSecret)
	vendorSvc := service.NewVendorService(vendorRepo)
	catalogSvc := service.NewCatalogService(productRepo, serviceRepo)
	videoSvc := service.NewVideoService(videoRepo, reviewRepo, chatRepo)
	orderSvc := service.NewOrderService(orderRepo, deliveryRepo)
	paymentSvc := service.NewPaymentService(paymentRepo)
	deliverySvc := service.NewDeliveryService(deliveryRepo)
	appointmentSvc := service.NewAppointmentService(appointmentRepo)
	reviewSvc := service.NewReviewService(reviewRepo)

	router := gin.Default()

	authHandler := NewAuthHandler(authSvc)
	vendorHandler := NewVendorHandler(vendorSvc)
	catalogHandler := NewCatalogHandler(catalogSvc)
	videoHandler := NewVideoHandler(videoSvc)
	chatHandler := NewChatHandler(videoSvc)
	orderHandler := NewOrderHandler(orderSvc)
	paymentHandler := NewPaymentHandler(paymentSvc)
	deliveryHandler := NewDeliveryHandler(deliverySvc)
	appointmentHandler := NewAppointmentHandler(appointmentSvc)
	reviewHandler := NewReviewHandler(reviewSvc)

	api := router.Group("/api")
	{
		api.POST("/auth/register", authHandler.Register)
		api.POST("/auth/login", authHandler.Login)
		api.GET("/me", auth.Middleware(cfg.JWTSecret), authHandler.Me)

		api.GET("/videos", videoHandler.ListPublic)
		api.GET("/videos/:id", videoHandler.Get)
		api.GET("/vendors", vendorHandler.List)
		api.GET("/vendors/:id", vendorHandler.Get)
		api.GET("/vendors/:id/products", catalogHandler.ListVendorProducts)
		api.GET("/vendors/:id/services", catalogHandler.ListVendorServices)

		// vendor commerce/service protected routes
		vendorGroup := api.Group("/vendors/me", auth.Middleware(cfg.JWTSecret, string(domain.RoleVendor)))
		{
			vendorGroup.POST("/products", catalogHandler.CreateProduct)
			vendorGroup.PUT("/products/:id", catalogHandler.UpdateProduct)
			vendorGroup.DELETE("/products/:id", catalogHandler.DeleteProduct)
			vendorGroup.POST("/services", catalogHandler.CreateService)
			vendorGroup.PUT("/services/:id", catalogHandler.UpdateService)
			vendorGroup.DELETE("/services/:id", catalogHandler.DeleteService)
			vendorGroup.POST("/videos", videoHandler.Create)
			vendorGroup.GET("/videos", videoHandler.ListMine)
			vendorGroup.GET("/deliveries", deliveryHandler.ListVendor)
			vendorGroup.GET("/deliveries/:id", deliveryHandler.GetVendor)
			vendorGroup.POST("/deliveries/:id/status", deliveryHandler.UpdateStatus)
			vendorGroup.POST("/deliveries/:id/mark-delivered", deliveryHandler.MarkDelivered)
		}

		api.GET("/videos/:id/chat/messages", chatHandler.List)
		api.POST("/videos/:id/chat/messages", auth.Middleware(cfg.JWTSecret), chatHandler.Create)
		api.GET("/videos/:id/reviews", reviewHandler.ListVideoReviews)
		api.POST("/videos/:id/reviews", auth.Middleware(cfg.JWTSecret), reviewHandler.CreateVideoReview)

		api.GET("/services/:id/available-slots", appointmentHandler.ListSlots)
		api.POST("/appointments", auth.Middleware(cfg.JWTSecret), appointmentHandler.Create)
		api.GET("/me/appointments", auth.Middleware(cfg.JWTSecret), appointmentHandler.ListMine)

		api.POST("/cart/items", auth.Middleware(cfg.JWTSecret), orderHandler.AddToCart)
		api.GET("/cart", auth.Middleware(cfg.JWTSecret), orderHandler.ViewCart)
		api.POST("/orders/checkout", auth.Middleware(cfg.JWTSecret), orderHandler.Checkout)
		api.POST("/orders/:id/payments", auth.Middleware(cfg.JWTSecret), paymentHandler.Register)
		api.GET("/me/orders", auth.Middleware(cfg.JWTSecret), orderHandler.ListMine)
		api.GET("/me/installments", auth.Middleware(cfg.JWTSecret), paymentHandler.ListInstallments)

		api.GET("/me/deliveries", auth.Middleware(cfg.JWTSecret), deliveryHandler.ListCustomer)
		api.GET("/me/deliveries/:id", auth.Middleware(cfg.JWTSecret), deliveryHandler.GetCustomer)
		api.POST("/deliveries/:id/confirm", auth.Middleware(cfg.JWTSecret), deliveryHandler.ConfirmDelivery)

		api.GET("/products/:id/reviews", reviewHandler.ListProductReviews)
		api.POST("/products/:id/reviews", auth.Middleware(cfg.JWTSecret), reviewHandler.CreateProductReview)

		admin := api.Group("/admin", auth.Middleware(cfg.JWTSecret, string(domain.RoleAdmin)))
		{
			admin.GET("/vendors", vendorHandler.AdminList)
			admin.POST("/vendors/:id/approve", vendorHandler.Approve)
			admin.POST("/vendors/:id/reject", vendorHandler.Reject)
			admin.POST("/vendors/:id/suspend", vendorHandler.Suspend)
		}
	}

	return router
}
