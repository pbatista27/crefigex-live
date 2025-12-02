package service

import (
	"context"
	"errors"
	"time"

	"github.com/crefigex/live/backend/internal/auth"
	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/repository/postgres"
)

type AuthService struct {
	users     postgres.UserRepository
	jwtSecret string
}

func NewAuthService(users postgres.UserRepository, secret string) *AuthService {
	return &AuthService{users: users, jwtSecret: secret}
}

func (s *AuthService) Register(ctx context.Context, u *domain.User) (*domain.User, error) {
	// TODO: hash password and persist
	if err := s.users.Create(ctx, u); err != nil {
		return nil, err
	}
	return u, nil
}

func (s *AuthService) Login(ctx context.Context, email, password string) (string, error) {
	user, err := s.users.FindByEmail(ctx, email)
	if err != nil {
		return "", errors.New("invalid credentials")
	}
	_ = password // TODO: compare hash
	var roles []string
	for _, r := range user.Roles {
		roles = append(roles, string(r))
	}
	return auth.GenerateToken(s.jwtSecret, user.ID, roles, 24*time.Hour)
}
