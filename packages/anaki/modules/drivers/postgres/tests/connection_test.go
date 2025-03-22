package postgres

import (
	"anaki/modules/drivers/postgres"
	"os"
	"testing"
)

func TestPostgresDriver_Connect(t *testing.T) {
	connStr := os.Getenv("TEST_DATABASE_URL")

	driver := &postgres.PostgresDriver{}

	err := driver.Connect(connStr)
	if err != nil {
		t.Errorf("expected no error, got %v", err)
	}

	defer driver.Close()

}

func TestPostgresDriver_Connect_InvalidCredentials(t *testing.T) {
	connStr := "postgres://invaliduser:invalidpass@localhost:5432/testdb"

	driver := &postgres.PostgresDriver{}
	err := driver.Connect(connStr)
	if err == nil {
		t.Errorf("expected an error for invalid credentials, but got none")
	}
}
