package ffi

import (
	"anaki/modules/ffi"
	"testing"
)

func TestDatabaseWrapper(t *testing.T) {
	ffi.DB = nil

	ffi.SetupDatabaseType("postgres")
	if ffi.DB == nil {
		t.Error("Expected db to be set to PostgreSQL, but got nil")
	}

	ffi.DB = nil

	ffi.SetupDatabaseType("sqlite")
	if ffi.DB == nil {
		t.Error("Expected db to be set to SQLite, but got nil")
	}

	ffi.DB = nil

	ffi.SetupDatabaseType("invalid")
	if ffi.DB != nil {
		t.Error("Expected db to be nil for invalid type")
	}
}
