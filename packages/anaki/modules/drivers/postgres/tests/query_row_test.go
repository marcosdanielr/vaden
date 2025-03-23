package postgres

import (
	"anaki/modules/drivers/postgres"
	"os"
	"testing"
)

func TestPostgresDriver_QueryRow(t *testing.T) {
	connStr := os.Getenv("TEST_DATABASE_URL")
	driver := &postgres.PostgresDriver{}

	err := driver.Connect(connStr)
	if err != nil {
		t.Fatalf("failed to connect: %v", err)
	}
	defer driver.Close()

	_, err = driver.Execute("CREATE TABLE IF NOT EXISTS test_table (id SERIAL PRIMARY KEY, name VARCHAR(255))")
	if err != nil {
		t.Errorf("failed to create table: %v", err)
	}

	_, err = driver.Execute("INSERT INTO test_table (name) VALUES ($1)", "test")
	if err != nil {
		t.Errorf("failed to insert user: %v", err)
	}

	result, err := driver.QueryRow("SELECT * FROM test_table where id = ($1)", 1)
	if err != nil {
		t.Errorf("failed to query data: %v", err)
	}

	if id, ok := result["id"].(int32); ok {
		if id != 1 {
			t.Errorf("no row returned from query")
		}
	} else {
		t.Errorf("id is not of type int32")
	}

	_, err = driver.Execute("DROP TABLE test_table")
	if err != nil {
		t.Errorf("failed to drop table: %v", err)
	}
}
