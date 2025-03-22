package sqlite_ffi_test

import (
	"anaki/modules/drivers/sqlite"
	"anaki/modules/ffi"
	"reflect"
	"testing"
)

func TestSelectSQLiteDatabaseType(t *testing.T) {
	ffi.DB = nil

	ffi.SetupDatabaseType("sqlite")

	if ffi.DB == nil {
		t.Error("Expected db to be set to SQLite, but got nil")
	}

	expectedType := &sqlite.SQLiteDriver{}
	if reflect.TypeOf(ffi.DB) != reflect.TypeOf(expectedType) {
		t.Errorf("Expected db type to be %T, but got %T", expectedType, ffi.DB)
	}
}
