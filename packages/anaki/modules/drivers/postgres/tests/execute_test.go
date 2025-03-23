package postgres

import (
	"anaki/modules/drivers/postgres"
	"os"
	"testing"
)

func setupTestDatabase(driver *postgres.PostgresDriver) error {
	_, err := driver.Execute("CREATE TABLE IF NOT EXISTS test_table (id SERIAL PRIMARY KEY, name VARCHAR(255))")
	return err
}

func tearDownTestDatabase(driver *postgres.PostgresDriver) error {
	_, err := driver.Execute("DROP TABLE IF EXISTS test_table")
	return err
}

func TestPostgresDriver_Execute_InsertAndUpdate(t *testing.T) {
	connStr := os.Getenv("TEST_DATABASE_URL")
	driver := &postgres.PostgresDriver{}

	if err := driver.Connect(connStr); err != nil {
		t.Fatalf("failed to connect: %v", err)
	}
	defer driver.Close()

	if err := setupTestDatabase(driver); err != nil {
		t.Fatalf("failed to setup test database: %v", err)
	}

	_, err := driver.Execute("INSERT INTO test_table (name) VALUES ('test')")
	if err != nil {
		t.Errorf("failed to insert data: %v", err)
	}

	rowsAffected, err := driver.Execute("UPDATE test_table SET name = $1 WHERE name = $2", "updated_test", "test")
	if err != nil {
		t.Errorf("failed to update data: %v", err)
	}

	if rowsAffected != 1 {
		t.Errorf("expected 1 row affected, got %d", rowsAffected)
	}

	if err := tearDownTestDatabase(driver); err != nil {
		t.Errorf("failed to clean up test database: %v", err)
	}
}

func TestPostgresDriver_Execute_MultipleArguments(t *testing.T) {
	connStr := os.Getenv("TEST_DATABASE_URL")
	driver := &postgres.PostgresDriver{}

	if err := driver.Connect(connStr); err != nil {
		t.Fatalf("failed to connect: %v", err)
	}
	defer driver.Close()

	if err := setupTestDatabase(driver); err != nil {
		t.Fatalf("failed to setup test database: %v", err)
	}

	insertQuery := "INSERT INTO test_table (name) VALUES ($1), ($2)"
	_, err := driver.Execute(insertQuery, "Alice", "Bob")
	if err != nil {
		t.Errorf("failed to insert multiple users: %v", err)
	}

	rows, err := driver.Query("SELECT name FROM test_table WHERE name IN ($1, $2)", "Alice", "Bob")
	if err != nil {
		t.Errorf("failed to query users: %v", err)
	}

	if len(rows) != 2 {
		t.Errorf("expected 2 rows, got %d", len(rows))
	}

	if err := tearDownTestDatabase(driver); err != nil {
		t.Errorf("failed to clean up test database: %v", err)
	}
}
