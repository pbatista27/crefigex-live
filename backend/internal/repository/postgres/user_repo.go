package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type UserRepository interface {
	FindByEmail(ctx context.Context, email string) (*domain.User, error)
	Create(ctx context.Context, u *domain.User) error
}

type userRepo struct {
	db *sql.DB
}

func NewUserRepository(db *sql.DB) UserRepository {
	return &userRepo{db: db}
}

func (r *userRepo) FindByEmail(ctx context.Context, email string) (*domain.User, error) {
	// TODO: implement query
	return nil, sql.ErrNoRows
}

func (r *userRepo) Create(ctx context.Context, u *domain.User) error {
	// TODO: insert user
	return nil
}
