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
	"unsafe"
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

	var arguments []interface{}

	if numArgs > 0 && args != nil {
		for i := 0; i < int(numArgs); i++ {
			argPtr := (**C.char)(unsafe.Pointer(uintptr(unsafe.Pointer(args)) + uintptr(i)*unsafe.Sizeof(*args)))

			if argPtr == nil || *argPtr == nil {
				continue
			}

			arg := C.GoString(*argPtr)

			arguments = append(arguments, arg)

			fmt.Printf("Argument %d: %s\n", i, arg)
		}
	}

	// Execute a query
	if len(arguments) > 0 {
		fmt.Printf("Executing SQL with %d args: %s, %v\n", len(arguments), sql, arguments)
		rowsAffected, err := DB.Execute(sql, arguments...)
		if err != nil {
			fmt.Printf("SQL Error: %v\n", err)
			return -1
		}
		fmt.Printf("Rows affected: %d\n", rowsAffected)
		return C.int(rowsAffected)
	} else {
		fmt.Printf("Executing SQL without args: %s\n", sql)
		rowsAffected, err := DB.Execute(sql)
		if err != nil {
			fmt.Printf("SQL Error: %v\n", err)
			return -1
		}
		fmt.Printf("Rows affected: %d\n", rowsAffected)
		return C.int(rowsAffected)
	}
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
