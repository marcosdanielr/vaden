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

var db interfaces.Database

//export SetDatabaseType
func SetDatabaseType(dbType *C.char) {
	typeStr := C.GoString(dbType)

	switch typeStr {
	case "postgres":
		db = &postgres.PostgresDriver{}

	case "sqlite":
		db = &sqlite.SQLiteDriver{}

	default:
		db = nil
	}
}

//export Connect
func Connect(connectionString *C.char) *C.char {
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

//export Execute
func Execute(argsCount C.int, args **C.char) C.int {
	goArgs := convertCArgsToGoArgs(args, argsCount)
	if db == nil {
		return -1
	}

	query := goArgs[0].(string)
	queryArgs := goArgs[1:]

	rowsAffected, err := db.Execute(query, queryArgs...)
	if err != nil {
		return -1
	}

	return C.int(rowsAffected)
}

//export Query
func Query(argsCount C.int, args **C.char) *C.char {
	goArgs := convertCArgsToGoArgs(args, argsCount)
	if db == nil {
		return C.CString("Database not connected")
	}

	query := goArgs[0].(string)
	queryArgs := goArgs[1:]
	result, err := db.Query(query, queryArgs...)
	if err != nil {
		return C.CString(fmt.Sprintf("Error querying database: %v", err))
	}

	return C.CString(FormatQueryResult(result))
}
