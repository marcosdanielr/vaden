package sqlite_ffi_test

import (
	"anaki/modules/ffi"
	"anaki/shared/utils"
	"testing"
)

func TestSQLiteQuery(t *testing.T) {
	ffi.SetupDatabaseType("sqlite")

	result := ffi.SetupDatabaseConnection(":memory:")
	if result != "Connection successful" {
		t.Errorf("Database connection failed. Expected 'Connection successful', got: %s", result)
	}

	defer ffi.SetupDatabaseClose()

	rowsAffected := ffi.SetupDatabaseExecute("CREATE TABLE IF NOT EXISTS test_table (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)", nil)
	if rowsAffected == -1 {
		t.Errorf("failed to create table")
	}

	rowsAffected = ffi.SetupDatabaseExecute("INSERT INTO test_table (name) VALUES (?)", []string{"test"})
	if rowsAffected != 1 {
		t.Errorf("failed to insert test_table")
	}

	result = ffi.SetupDatabaseQuery("SELECT * FROM test_table WHERE name = ?", []string{"test"})
	rows, err := utils.ParseJSONToMap(result)
	if err != nil {
		t.Errorf("Failed to parse JSON: %v", err)
	}

	if len(rows) != 1 || rows[0]["id"] == nil {
		t.Errorf("failed to select test_table")
	}

	if len(rows) != 1 {
		t.Errorf("no rows returned from query")
	}

}
