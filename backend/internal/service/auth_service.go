package service

import (
	"context"
	"errors"
	"time"

	"golang.org/x/crypto/bcrypt"

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
	if len(u.Roles) == 0 {
		u.Roles = []domain.Role{domain.RoleCustomer}
	}
	hashed, err := bcrypt.GenerateFromPassword([]byte(u.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}
	u.Password = string(hashed)
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
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password)); err != nil {
		return "", errors.New("invalid credentials")
	}
	var roles []string
	for _, r := range user.Roles {
		roles = append(roles, string(r))
	}
	return auth.GenerateToken(s.jwtSecret, user.ID, roles, 24*time.Hour)
}

func (s *AuthService) Refresh(ctx context.Context, userID string, roles []string) (string, error) {
	if userID == "" {
		return "", errors.New("missing user")
	}
	return auth.GenerateToken(s.jwtSecret, userID, roles, 24*time.Hour)
}
