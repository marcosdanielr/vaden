package postgres_ffi_test

import (
	"anaki/modules/ffi"
	"anaki/shared/utils"
	"fmt"
	"os"
	"reflect"
	"testing"
)

func TestPostgresFFIDatabaseQuery(t *testing.T) {
	ffi.SetupDatabaseType("postgres")
	connStr := os.Getenv("TEST_DATABASE_URL")

	result := ffi.SetupDatabaseConnection(connStr)

	if result != "Connection successful" {
		t.Errorf("database connection failed: %s", result)
	}

	defer ffi.SetupDatabaseClose()

	rowsAffected := ffi.SetupDatabaseExecute("CREATE TABLE IF NOT EXISTS test_table (id SERIAL PRIMARY KEY, name VARCHAR(255))", nil)
	if rowsAffected == -1 {
		t.Errorf("failed to create table")
	}

	insertTestData(t, "test")
	insertTestData(t, "test_2")

	result = ffi.SetupDatabaseQuery("SELECT * FROM test_table", nil)
	rows, err := utils.ParseJSONToMap(result)
	if err != nil {
		t.Errorf("Failed to parse JSON: %v", err)
	}

	if len(rows) != 2 || rows[0]["id"] == nil {
		t.Errorf("failed to select test_table")
	}

	result = ffi.SetupDatabaseQuery("SELECT * FROM test_table WHERE id = $1", []string{"2"})
	rows, err = utils.ParseJSONToMap(result)
	if err != nil {
		t.Errorf("Failed to parse JSON: %v", err)
	}

	if len(rows) != 1 {
		t.Errorf("failed to select test_table")
	}

	if id, ok := rows[0]["id"].(float64); ok {
		if id != 2 {
			t.Errorf("no row returned from query")
		}
	} else {
		t.Errorf("id is not of type float64, it is of type %s", reflect.TypeOf(rows[0]["id"]))
	}

	rowsAffected = ffi.SetupDatabaseExecute("DROP TABLE test_table", nil)
	if rowsAffected == -1 {
		t.Errorf("failed to drop table")
	}
}

func TestPostgresFFIDatabaseQueryMutipleArgs(t *testing.T) {
	ffi.SetupDatabaseType("postgres")
	connStr := os.Getenv("TEST_DATABASE_URL")

	result := ffi.SetupDatabaseConnection(connStr)
	if result != "Connection successful" {
		t.Errorf("database connection failed: %s", result)
	}
	defer ffi.SetupDatabaseClose()

	rowsAffected := ffi.SetupDatabaseExecute(`
		CREATE TABLE IF NOT EXISTS users_test (
			id SERIAL PRIMARY KEY,
			first_name VARCHAR(255),
			last_name VARCHAR(255),
			age INT,
			email VARCHAR(255)
		)`, nil)
	if rowsAffected == -1 {
		t.Errorf("failed to create table")
	}

	insertToUsersTestTable(t, "Alice", "Smith", 30, "alice.smith@example.com")
	insertToUsersTestTable(t, "Bob", "Johnson", 25, "bob.johnson@example.com")
	insertToUsersTestTable(t, "Charlie", "Brown", 35, "charlie.brown@example.com")

	result = ffi.SetupDatabaseQuery("SELECT * FROM users_test", nil)
	rows, err := utils.ParseJSONToMap(result)
	if err != nil {
		t.Errorf("Failed to parse JSON: %v", err)
	}

	if len(rows) != 3 {
		t.Errorf("Expected 3 rows, got %d", len(rows))
	}

	result = ffi.SetupDatabaseQuery("SELECT * FROM users_test WHERE age > $1 AND age < $2", []string{"25", "35"})
	rows, err = utils.ParseJSONToMap(result)
	if err != nil {
		t.Errorf("Failed to parse JSON: %v", err)
	}

	if len(rows) != 1 {
		t.Errorf("Expected 1 row, got %d", len(rows))
	}

	rowsAffected = ffi.SetupDatabaseExecute("DROP TABLE users_test", nil)
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

func insertToUsersTestTable(t *testing.T, firstName, lastName string, age int, email string) {
	rowsAffected := ffi.SetupDatabaseExecute(`
		INSERT INTO users_test (first_name, last_name, age, email) 
		VALUES ($1, $2, $3, $4)`, []string{firstName, lastName, fmt.Sprintf("%d", age), email})

	if rowsAffected == -1 {
		t.Errorf("Failed to insert test data for %s %s", firstName, lastName)
	} else {
		t.Logf("Successfully inserted test data for %s %s", firstName, lastName)
	}
}
