package service

import (
	"context"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/repository/postgres"
)

type VendorService struct {
	vendors postgres.VendorRepository
}

func NewVendorService(vendors postgres.VendorRepository) *VendorService {
	return &VendorService{vendors: vendors}
}

func (s *VendorService) Register(ctx context.Context, v *domain.Vendor) error {
	return s.vendors.Create(ctx, v)
}

func (s *VendorService) Approve(ctx context.Context, id string) error {
	return s.vendors.UpdateStatus(ctx, id, domain.VendorStatusApproved)
}

func (s *VendorService) Reject(ctx context.Context, id string) error {
	return s.vendors.UpdateStatus(ctx, id, domain.VendorStatusRejected)
}

func (s *VendorService) List(ctx context.Context, status domain.VendorStatus) ([]domain.Vendor, error) {
	return s.vendors.List(ctx, status)
}
