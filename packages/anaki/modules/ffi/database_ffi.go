package ffi

/*
#include <stdlib.h>
*/
import "C"
import (
	"anaki/modules/drivers/postgres"
	"anaki/modules/drivers/sqlite"
	"anaki/shared/drivers/interfaces"
	"anaki/shared/helpers"
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
func Execute(args **C.char) C.int {
	goArgs := convertCArgsToGoArgs(args)
	if DB == nil {
		return -1
	}

	query := goArgs[0]
	queryArgs := helpers.ConvertStringsToInterfaces(goArgs[1:])

	rowsAffected, err := DB.Execute(query, queryArgs...)
	if err != nil {
		return -1
	}

	return C.int(rowsAffected)
}

//export Query
func Query(args **C.char) *C.char {
	goArgs := convertCArgsToGoArgs(args)
	if DB == nil {
		return C.CString("Database not connected")
	}

	query := goArgs[0]
	queryArgs := helpers.ConvertStringsToInterfaces(goArgs[1:])
	result, err := DB.Query(query, queryArgs...)
	if err != nil {
		return C.CString(fmt.Sprintf("Error querying database: %v", err))
	}

	return C.CString(formatQueryResult(result))
}

//export Close
func Close(args **C.char) *C.char {
	goArgs := convertCArgsToGoArgs(args)
	if DB == nil {
		return C.CString("Database not connected")
	}

	query := goArgs[0]
	queryArgs := helpers.ConvertStringsToInterfaces(goArgs[1:])
	result, err := DB.Query(query, queryArgs...)
	if err != nil {
		return C.CString(fmt.Sprintf("Error querying database: %v", err))
	}

	return C.CString(formatQueryResult(result))
}
