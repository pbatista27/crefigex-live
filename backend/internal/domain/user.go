package domain

import "time"

type Role string

const (
	RoleVisitor  Role = "VISITOR"
	RoleCustomer Role = "CLIENTE"
	RoleVendor   Role = "VENDEDOR"
	RoleAdmin    Role = "ADMIN"
)

type User struct {
	ID        string
	Name      string
	Email     string
	Phone     string
	Password  string
	Roles     []Role
	CreatedAt time.Time
}

type VendorType string

const (
	VendorTypeCommerce VendorType = "COMERCIO"
	VendorTypeService  VendorType = "PRESTADOR_SERVICIO"
)

type VendorStatus string

const (
	VendorStatusPending  VendorStatus = "PENDING"
	VendorStatusApproved VendorStatus = "APPROVED"
	VendorStatusRejected VendorStatus = "REJECTED"
)

type Vendor struct {
	ID          string
	UserID      string
	Name        string
	Phone       string
	Address     string
	CategoryID  string
	Description string
	Type        VendorType
	Status      VendorStatus
	CreatedAt   time.Time
}
