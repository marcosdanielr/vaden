package ffi

import (
	"testing"
)

func TestDatabaseWrapper(t *testing.T) {
	db = nil

	TestSetDatabaseType("postgres")
	if db == nil {
		t.Error("Expected db to be set to PostgreSQL, but got nil")
	}

	db = nil

	TestSetDatabaseType("sqlite")
	if db == nil {
		t.Error("Expected db to be set to SQLite, but got nil")
	}

	db = nil

	TestSetDatabaseType("invalid")
	if db != nil {
		t.Error("Expected db to be nil for invalid type")
	}
}
