package postgres_ffi_test

import (
	"anaki/modules/ffi"
	"os"
	"testing"
)

func TestPostgresFFIDatabaseExecute(t *testing.T) {
	ffi.SetupDatabaseType("postgres")
	connStr := os.Getenv("TEST_DATABASE_URL")

	result := ffi.SetupDatabaseConnection(connStr)

	if result != "Connection successful" {
		t.Errorf("Falha ao conectar ao banco de dados: %s", result)
	}

	defer ffi.SetupDatabaseClose()

	rowsAffected := ffi.SetupDatabaseExecute("CREATE TABLE IF NOT EXISTS test_table (id SERIAL PRIMARY KEY, name VARCHAR(255))")
	if rowsAffected == -1 {
		t.Errorf("failed to create table")
	}

	rowsAffected = ffi.SetupDatabaseExecute("INSERT INTO test_table (name) VALUES ('test')")
	if rowsAffected != 1 {
		t.Errorf("failed to insert test_table")
	}

	rowsAffected = ffi.SetupDatabaseExecute("UPDATE test_table SET name = 'updated_test' WHERE name = 'test'")
	if rowsAffected != 1 {
		t.Errorf("failed to update data")
		t.Errorf("expected 1 row affected, got %d", rowsAffected)
	}

	rowsAffected = ffi.SetupDatabaseExecute("DROP TABLE test_table")
	if rowsAffected == -1 {
		t.Errorf("failed to drop table")

	}
}
