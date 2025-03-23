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

func TestPostgresFFIDatabaseQueryComplex(t *testing.T) {
	ffi.SetupDatabaseType("postgres")
	connStr := os.Getenv("TEST_DATABASE_URL")

	result := ffi.SetupDatabaseConnection(connStr)
	if result != "Connection successful" {
		t.Errorf("database connection failed: %s", result)
	}
	defer ffi.SetupDatabaseClose()

	// Criando tabela com múltiplas colunas
	rowsAffected := ffi.SetupDatabaseExecute(`
		CREATE TABLE IF NOT EXISTS users (
			id SERIAL PRIMARY KEY,
			first_name VARCHAR(255),
			last_name VARCHAR(255),
			age INT,
			email VARCHAR(255)
		)`, nil)
	if rowsAffected == -1 {
		t.Errorf("failed to create table")
	}

	insertToUsersTable(t, "Alice", "Smith", 30, "alice.smith@example.com")
	insertToUsersTable(t, "Bob", "Johnson", 25, "bob.johnson@example.com")
	insertToUsersTable(t, "Charlie", "Brown", 35, "charlie.brown@example.com")

	// Consultando todos os registros
	result = ffi.SetupDatabaseQuery("SELECT * FROM users", nil)
	rows, err := utils.ParseJSONToMap(result)
	if err != nil {
		t.Errorf("Failed to parse JSON: %v", err)
	}

	if len(rows) != 3 {
		t.Errorf("Expected 3 rows, got %d", len(rows))
	}

	// Consultando com múltiplos parâmetros usando WHERE
	result = ffi.SetupDatabaseQuery("SELECT * FROM users WHERE age > $1 AND age < $2", []string{"25", "35"})
	rows, err = utils.ParseJSONToMap(result)
	if err != nil {
		t.Errorf("Failed to parse JSON: %v", err)
	}

	if len(rows) != 2 {
		t.Errorf("Expected 2 rows, got %d", len(rows))
	}

	// Atualizando registros com parâmetros
	rowsAffected = ffi.SetupDatabaseExecute(`
		UPDATE users SET age = $1 WHERE first_name = $2`, []string{"40", "Alice"})
	if rowsAffected == -1 {
		t.Errorf("Failed to update record")
	}

	// Verificando se a atualização foi realizada corretamente
	result = ffi.SetupDatabaseQuery("SELECT * FROM users WHERE first_name = $1", []string{"Alice"})
	rows, err = utils.ParseJSONToMap(result)
	if err != nil {
		t.Errorf("Failed to parse JSON: %v", err)
	}

	if len(rows) != 1 || rows[0]["age"].(float64) != 40 {
		t.Errorf("Failed to update user age correctly")
	}

	// Deletando registros
	rowsAffected = ffi.SetupDatabaseExecute("DELETE FROM users WHERE first_name = $1", []string{"Alice"})
	if rowsAffected == -1 {
		t.Errorf("Failed to delete record")
	}
}

func insertTestData(t *testing.T, name string) {
	rowsAffected := ffi.SetupDatabaseExecute("INSERT INTO test_table (name) VALUES ($1)", []string{name})
	if rowsAffected != 1 {
		t.Errorf("failed to insert into test_table with name: %s", name)
	}
}

func insertToUsersTable(t *testing.T, firstName, lastName string, age int, email string) {
	rowsAffected := ffi.SetupDatabaseExecute(`
		INSERT INTO users (first_name, last_name, age, email) 
		VALUES ($1, $2, $3, $4)`, []string{firstName, lastName, fmt.Sprintf("%d", age), email})

	if rowsAffected == -1 {
		t.Errorf("Failed to insert test data for %s %s", firstName, lastName)
	} else {
		t.Logf("Successfully inserted test data for %s %s", firstName, lastName)
	}
}
