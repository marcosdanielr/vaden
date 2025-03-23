package ffi

/*
#include <stdlib.h>
*/
import "C"
import (
	"unsafe"
)

func SetupDatabaseType(dbType string) {
	cDbType := C.CString(dbType)
	defer C.free(unsafe.Pointer(cDbType))
	SetDatabaseType(cDbType)
}

func SetupDatabaseConnection(connStr string) string {
	cConnStr := C.CString(connStr)
	defer C.free(unsafe.Pointer(cConnStr))
	return C.GoString(Connect(cConnStr))
}

func SetupDatabaseClose() string {
	return C.GoString(Close())

}

func SetupDatabaseExecute(sql string) int {
	cSql := C.CString(sql)
	defer C.free(unsafe.Pointer(cSql))

	result := Execute(cSql)

	return int(result)
}

func SetupDatabaseQuery(sql string) string {
	cSql := C.CString(sql)
	defer C.free(unsafe.Pointer(cSql))

	result := Query(cSql)

	return C.GoString(result)
}
