package ffi

/*
#include <stdlib.h>
*/
import "C"
import (
	"anaki/modules/drivers/postgres"
	"anaki/modules/drivers/sqlite"
	"anaki/shared/drivers/interfaces"
	"fmt"
)

var DB interfaces.Database

//export SetDatabaseType
func SetDatabaseType(dbType *C.char) {
	typeStr := C.GoString(dbType)

	switch typeStr {
	case "postgres":
		DB = &postgres.PostgresDriver{}
	case "sqlite":
		DB = &sqlite.SQLiteDriver{}
	default:
		DB = nil
	}
}

//export Connect
func Connect(connectionString *C.char) *C.char {
	connStr := C.GoString(connectionString)
	if DB == nil {
		return C.CString("Database type not set")
	}

	err := DB.Connect(connStr)
	if err != nil {
		return C.CString(fmt.Sprintf("Error connecting to database: %v", err))
	}

	return C.CString("Connection successful")
}

//export Execute
func Execute(query *C.char, args **C.char, numArgs C.int) C.int {
	if DB == nil {
		return -1
	}

	sql := C.GoString(query)

	var arguments = convertCArgsToGo(args, numArgs)

	if len(arguments) == 0 {
		arguments = nil
	}

	rowsAffected, err := DB.Execute(sql, arguments...)
	if err != nil {
		return -1
	}

	return C.int(rowsAffected)
}

//export Query
func Query(arg *C.char) *C.char {
	if DB == nil {
		return C.CString("Database not connected")
	}

	query := C.GoString(arg)

	result, err := DB.Query(query)
	if err != nil {
		return C.CString(fmt.Sprintf("Error querying database: %v", err))
	}

	return C.CString(formatQueryResult(result))
}

//export Close
func Close() *C.char {
	if DB == nil {
		return C.CString("Database not connected")
	}

	err := DB.Close()
	if err != nil {
		return C.CString(fmt.Sprintf("Error disconnecting database: %v", err))
	}

	DB = nil

	return C.CString("Database disconnected successfully")
}
