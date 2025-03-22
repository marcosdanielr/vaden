package ffi

/*
#include <stdlib.h>
*/
import "C"
import (
	"unsafe"
)

func TestSetDatabaseType(dbType string) {
	cDbType := C.CString(dbType)
	defer C.free(unsafe.Pointer(cDbType))
	SetDatabaseType(cDbType)
}

func TestConnect(connStr string) string {
	cConnStr := C.CString(connStr)
	defer C.free(unsafe.Pointer(cConnStr))
	return C.GoString(Connect(cConnStr))
}
