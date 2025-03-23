package sqlite_ffi_test

import (
	"anaki/modules/ffi"
	"testing"
)

func TestSQLiteExecute(t *testing.T) {
	ffi.SetupDatabaseType("sqlite")

	result := ffi.SetupDatabaseConnection(":memory:")
	if result != "Connection successful" {
		t.Errorf("Database connection failed. Expected 'Connection successful', got: %s", result)
	}

	defer ffi.SetupDatabaseClose()

	rowsAffected := ffi.SetupDatabaseExecute("CREATE TABLE IF NOT EXISTS test_table (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(255))", nil)
	if rowsAffected == -1 {
		t.Errorf("failed to create table")
	}

	rowsAffected = ffi.SetupDatabaseExecute("INSERT INTO test_table (name) VALUES (?)", []string{"test"})
	if rowsAffected != 1 {
		t.Errorf("failed to insert test_table")
	}

	rowsAffected = ffi.SetupDatabaseExecute("UPDATE test_table SET name = ? WHERE name = ?", []string{"updated_test", "test"})
	if rowsAffected != 1 {
		t.Errorf("failed to update data")
	}
}
