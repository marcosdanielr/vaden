package sqlite

import (
	"anaki/modules/drivers/sqlite"
	"testing"
)

func TestSQLiteDriver_Execute(t *testing.T) {
	connStr := ":memory:"

	driver := sqlite.SQLiteDriver{}

	err := driver.Connect(connStr)
	if err != nil {
		t.Errorf("expected no error, got %v", err)
	}

	defer driver.Close()

	_, err = driver.Execute("CREATE TABLE IF NOT EXISTS test_table (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(255))")
	if err != nil {
		t.Errorf("failed to create table: %v", err)
	}

	_, err = driver.Execute("INSERT INTO test_table (name) VALUES ('test')")
	if err != nil {
		t.Errorf("failed to insert user: %v", err)
	}

	rowsAffected, err := driver.Execute("UPDATE test_table SET name = 'updated_test' WHERE name = 'test'")
	if err != nil {
		t.Errorf("failed to update data: %v", err)
	}

	if rowsAffected != 1 {
		t.Errorf("expected 1 row affected, got %d", rowsAffected)
	}
}
