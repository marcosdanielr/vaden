package postgres_ffi_test

import (
	"anaki/modules/drivers/postgres"
	"anaki/modules/ffi"
	"reflect"
	"testing"
)

func TestSelectPostgresDatabaseType(t *testing.T) {
	ffi.DB = nil

	ffi.SetupDatabaseType("postgres")

	if ffi.DB == nil {
		t.Error("Expected db to be set to PostgreSQL, but got nil")
	}

	expectedType := &postgres.PostgresDriver{}
	if reflect.TypeOf(ffi.DB) != reflect.TypeOf(expectedType) {
		t.Errorf("Expected db type to be %T, but got %T", expectedType, ffi.DB)
	}
}
