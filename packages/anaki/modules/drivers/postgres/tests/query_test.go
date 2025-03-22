package postgres

import (
	"anaki/modules/drivers/postgres"
	"os"
	"testing"
)

func TestPostgresDriver_Query(t *testing.T) {
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

	_, err = driver.Execute("DROP TABLE test_table")
	if err != nil {
		t.Errorf("failed to drop table: %v", err)
	}

}
