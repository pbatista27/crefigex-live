package postgres

import (
	"context"
	"database/sql"

	"github.com/crefigex/live/backend/internal/domain"
)

type UserRepository interface {
	FindByEmail(ctx context.Context, email string) (*domain.User, error)
	GetByID(ctx context.Context, id string) (*domain.User, error)
	Create(ctx context.Context, u *domain.User) error
	ListByRole(ctx context.Context, role domain.Role) ([]domain.User, error)
	UpdateContact(ctx context.Context, u *domain.User) error
}

type userRepo struct {
	db *sql.DB
}

func NewUserRepository(db *sql.DB) UserRepository {
	return &userRepo{db: db}
}

func (r *userRepo) FindByEmail(ctx context.Context, email string) (*domain.User, error) {
	row := r.db.QueryRowContext(ctx, `
		SELECT id, name, email, phone, password_hash, created_at
		FROM users WHERE email = $1
	`, email)
	u := &domain.User{}
	if err := row.Scan(&u.ID, &u.Name, &u.Email, &u.Phone, &u.Password, &u.CreatedAt); err != nil {
		return nil, err
	}

	roleRows, err := r.db.QueryContext(ctx, `SELECT role_name FROM user_roles WHERE user_id = $1`, u.ID)
	if err != nil {
		return nil, err
	}
	defer roleRows.Close()

	for roleRows.Next() {
		var roleName string
		if err := roleRows.Scan(&roleName); err != nil {
			return nil, err
		}
		u.Roles = append(u.Roles, domain.Role(roleName))
	}
	return u, nil
}

func (r *userRepo) GetByID(ctx context.Context, id string) (*domain.User, error) {
	row := r.db.QueryRowContext(ctx, `
		SELECT id, name, email, phone, password_hash, created_at
		FROM users WHERE id = $1
	`, id)
	u := &domain.User{}
	if err := row.Scan(&u.ID, &u.Name, &u.Email, &u.Phone, &u.Password, &u.CreatedAt); err != nil {
		return nil, err
	}
	roleRows, err := r.db.QueryContext(ctx, `SELECT role_name FROM user_roles WHERE user_id = $1`, u.ID)
	if err != nil {
		return nil, err
	}
	defer roleRows.Close()
	for roleRows.Next() {
		var roleName string
		if err := roleRows.Scan(&roleName); err != nil {
			return nil, err
		}
		u.Roles = append(u.Roles, domain.Role(roleName))
	}
	return u, nil
}

func (r *userRepo) Create(ctx context.Context, u *domain.User) error {
	tx, err := r.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	if err := tx.QueryRowContext(ctx, `
		INSERT INTO users (name, phone, email, password_hash)
		VALUES ($1, $2, $3, $4)
		RETURNING id, created_at
	`, u.Name, u.Phone, u.Email, u.Password).Scan(&u.ID, &u.CreatedAt); err != nil {
		return err
	}

	for _, role := range u.Roles {
		if _, err := tx.ExecContext(ctx, `
			INSERT INTO user_roles (user_id, role_name) VALUES ($1, $2)
			ON CONFLICT DO NOTHING
		`, u.ID, string(role)); err != nil {
			return err
		}
	}

	return tx.Commit()
}

func (r *userRepo) ListByRole(ctx context.Context, role domain.Role) ([]domain.User, error) {
	rows, err := r.db.QueryContext(ctx, `
		SELECT u.id, u.name, u.email, u.phone, u.created_at
		FROM users u
		INNER JOIN user_roles ur ON ur.user_id = u.id
		WHERE ur.role_name = $1
	`, role)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []domain.User
	for rows.Next() {
		var u domain.User
		if err := rows.Scan(&u.ID, &u.Name, &u.Email, &u.Phone, &u.CreatedAt); err != nil {
			return nil, err
		}
		list = append(list, u)
	}
	return list, nil
}

func (r *userRepo) UpdateContact(ctx context.Context, u *domain.User) error {
	_, err := r.db.ExecContext(ctx, `
		UPDATE users SET name=$1, phone=$2 WHERE id=$3
	`, u.Name, u.Phone, u.ID)
	return err
}
