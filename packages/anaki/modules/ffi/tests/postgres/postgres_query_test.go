package postgres_ffi_test

import (
	"anaki/modules/ffi"
	"anaki/shared/utils"
	"os"
	"testing"
)

func TestPostgresFFIDatabaseQuery(t *testing.T) {
	ffi.SetupDatabaseType("postgres")
	connStr := os.Getenv("TEST_DATABASE_URL")

	result := ffi.SetupDatabaseConnection(connStr)

	if result != "Connection successful" {
		t.Errorf("Falha ao conectar ao banco de dados: %s", result)
	}

	defer ffi.SetupDatabaseClose()

	rowsAffected := ffi.SetupDatabaseExecute("CREATE TABLE IF NOT EXISTS test_table (id SERIAL PRIMARY KEY, name VARCHAR(255))", nil)
	if rowsAffected == -1 {
		t.Errorf("failed to create table")
	}

	insertTestData(t, "test")
	insertTestData(t, "test_2")

	result = ffi.SetupDatabaseQuery("SELECT * FROM test_table")
	rows, err := utils.ParseJSONToMap(result)
	if err != nil {
		t.Errorf("Failed to parse JSON: %v", err)
	}

	if len(rows) != 2 || rows[0]["id"] == nil {
		t.Errorf("failed to select test_table")
	}

	rowsAffected = ffi.SetupDatabaseExecute("DROP TABLE test_table", nil)
	if rowsAffected == -1 {
		t.Errorf("failed to drop table")

	}
}

func insertTestData(t *testing.T, name string) {
	rowsAffected := ffi.SetupDatabaseExecute("INSERT INTO test_table (name) VALUES ($1)", []string{name})
	if rowsAffected != 1 {
		t.Errorf("failed to insert into test_table with name: %s", name)
	}
}
