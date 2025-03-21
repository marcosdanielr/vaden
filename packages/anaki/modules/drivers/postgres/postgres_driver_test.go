package postgres

import (
	"os"
	"testing"
)

func TestPostgresDriver_Connect(t *testing.T) {
	connStr := os.Getenv("TEST_DATABASE_URL")

	driver := &PostgresDriver{}

	err := driver.Connect(connStr)
	if err != nil {
		t.Errorf("expected no error, got %v", err)
	}

	if driver.conn == nil {
		t.Errorf("expected a connection, but got nil")
	}
}

func TestPostgresDriver_Connect_InvalidCredentials(t *testing.T) {
	connStr := "postgres://invaliduser:invalidpass@localhost:5432/testdb"

	driver := &PostgresDriver{}
	err := driver.Connect(connStr)
	if err == nil {
		t.Errorf("expected an error for invalid credentials, but got none")
	}
}
