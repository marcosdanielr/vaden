package ffi

/*
#include <stdlib.h>
*/
import "C"
import (
	"anaki/modules/drivers/postgres"
	"anaki/shared/interfaces/contracts"
	"fmt"
)

var db contracts.Database

//export SetDatabaseType
func SetDatabaseType(dbType *C.char) {
	typeStr := C.GoString(dbType)

	switch typeStr {
	case "postgres":
		db = &postgres.PostgresDriver{}
	default:
		db = nil
	}
}

//export ConnectDB
func ConnectDB(connectionString *C.char) *C.char {
	connStr := C.GoString(connectionString)
	if db == nil {
		return C.CString("Database type not set")
	}

	err := db.Connect(connStr)
	if err != nil {
		return C.CString(fmt.Sprintf("Error connecting to database: %v", err))
	}

	return C.CString("Connection successful")
}

//export CloseDB
func CloseDB() *C.char {
	if db == nil {
		return C.CString("Database not connected")
	}

	err := db.Close()
	if err != nil {
		return C.CString(fmt.Sprintf("Error closing database connection: %v", err))
	}

	return C.CString("Connection closed successfully")
}
