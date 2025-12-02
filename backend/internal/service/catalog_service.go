package service

import (
	"context"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/repository/postgres"
)

type CatalogService struct {
	products postgres.ProductRepository
	services postgres.ServiceRepository
}

func NewCatalogService(products postgres.ProductRepository, services postgres.ServiceRepository) *CatalogService {
	return &CatalogService{products: products, services: services}
}

func (s *CatalogService) CreateProduct(ctx context.Context, p *domain.Product) error {
	return s.products.Create(ctx, p)
}

func (s *CatalogService) UpdateProduct(ctx context.Context, p *domain.Product) error {
	return s.products.Update(ctx, p)
}

func (s *CatalogService) DeleteProduct(ctx context.Context, id, vendorID string) error {
	return s.products.Delete(ctx, id, vendorID)
}

func (s *CatalogService) ListProducts(ctx context.Context, vendorID string) ([]domain.Product, error) {
	return s.products.ListByVendor(ctx, vendorID)
}

func (s *CatalogService) CreateService(ctx context.Context, service *domain.Service) error {
	return s.services.Create(ctx, service)
}

func (s *CatalogService) UpdateService(ctx context.Context, service *domain.Service) error {
	return s.services.Update(ctx, service)
}

func (s *CatalogService) DeleteService(ctx context.Context, id, vendorID string) error {
	return s.services.Delete(ctx, id, vendorID)
}

func (s *CatalogService) ListServices(ctx context.Context, vendorID string) ([]domain.Service, error) {
	return s.services.ListByVendor(ctx, vendorID)
}
