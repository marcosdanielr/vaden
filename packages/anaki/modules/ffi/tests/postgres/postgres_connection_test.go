package postgres_ffi_test

import (
	"anaki/modules/ffi"
	"os"
	"testing"
)

func TestPostgresFFIDatabaseConnection(t *testing.T) {
	ffi.SetupDatabaseType("postgres")
	connStr := os.Getenv("TEST_DATABASE_URL")

	result := ffi.SetupDatabaseConnection(connStr)

	if result != "Connection successful" {
		t.Errorf("Database connection failed. Expected 'Connection successful', got: %s", result)
	}
}

func TestPostgresFFIDatabaseConnectionFailed(t *testing.T) {
	ffi.SetupDatabaseType("postgres")
	connStr := "postgres://invaliduser:invalidpass@localhost:5432/testdb"

	result := ffi.SetupDatabaseConnection(connStr)

	if result == "Connection successful" {
		t.Errorf("Expected database connection to fail, but it succeeded. Result: %s", result)
	}
}
