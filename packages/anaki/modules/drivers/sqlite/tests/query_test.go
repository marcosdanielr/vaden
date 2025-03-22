package sqlite

import (
	"anaki/modules/drivers/sqlite"
	"testing"
)

func TestSQLiteDriver_Query(t *testing.T) {
	connStr := ":memory:"

	driver := sqlite.SQLiteDriver{}
	err := driver.Connect(connStr)
	if err != nil {
		t.Errorf("expected no error, got %v", err)
	}
	defer driver.Close()

	_, err = driver.Execute("CREATE TABLE IF NOT EXISTS test_table (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)")
	if err != nil {
		t.Errorf("failed to create table: %v", err)
	}

	_, err = driver.Execute("INSERT INTO test_table (name) VALUES ('test')")
	if err != nil {
		t.Errorf("failed to insert user: %v", err)
	}

	result, err := driver.Query("SELECT * FROM test_table")
	if err != nil {
		t.Errorf("failed to query data: %v", err)
	}

	if len(result) == 0 {
		t.Errorf("no rows returned from query")
	}

}
