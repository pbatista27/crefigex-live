package service

import (
	"context"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/repository/postgres"
)

type AdminService struct {
	users      postgres.UserRepository
	categories postgres.CategoryRepository
}

func NewAdminService(users postgres.UserRepository, categories postgres.CategoryRepository) *AdminService {
	return &AdminService{users: users, categories: categories}
}

func (s *AdminService) ListCustomers(ctx context.Context) ([]domain.User, error) {
	return s.users.ListByRole(ctx, domain.RoleCustomer)
}

func (s *AdminService) UpdateCustomer(ctx context.Context, u *domain.User) error {
	return s.users.UpdateContact(ctx, u)
}

func (s *AdminService) ListCategories(ctx context.Context) ([]domain.Category, error) {
	return s.categories.ListCategories(ctx)
}

func (s *AdminService) ListProductTypes(ctx context.Context) ([]domain.ProductType, error) {
	return s.categories.ListProductTypes(ctx)
}

func (s *AdminService) ListServiceTypes(ctx context.Context) ([]domain.ServiceType, error) {
	return s.categories.ListServiceTypes(ctx)
}

func (s *AdminService) CreateCategory(ctx context.Context, name string) (*domain.Category, error) {
	return s.categories.CreateCategory(ctx, name)
}

func (s *AdminService) UpdateCategory(ctx context.Context, id, name string) error {
	return s.categories.UpdateCategory(ctx, id, name)
}

func (s *AdminService) DeleteCategory(ctx context.Context, id string) error {
	return s.categories.DeleteCategory(ctx, id)
}

func (s *AdminService) CreateProductType(ctx context.Context, name string) (*domain.ProductType, error) {
	return s.categories.CreateProductType(ctx, name)
}

func (s *AdminService) UpdateProductType(ctx context.Context, id, name string) error {
	return s.categories.UpdateProductType(ctx, id, name)
}

func (s *AdminService) DeleteProductType(ctx context.Context, id string) error {
	return s.categories.DeleteProductType(ctx, id)
}

func (s *AdminService) CreateServiceType(ctx context.Context, name string) (*domain.ServiceType, error) {
	return s.categories.CreateServiceType(ctx, name)
}

func (s *AdminService) UpdateServiceType(ctx context.Context, id, name string) error {
	return s.categories.UpdateServiceType(ctx, id, name)
}

func (s *AdminService) DeleteServiceType(ctx context.Context, id string) error {
	return s.categories.DeleteServiceType(ctx, id)
}
