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

func SetupDatabaseExecute(sql string, args []string) int {
	cSql := C.CString(sql)
	defer C.free(unsafe.Pointer(cSql))

	if len(args) == 0 {
		return int(Execute(cSql, nil, 0))
	}

	cArgs, freeArgs := convertArgsToCStringArray(args)
	defer freeArgs()

	result := Execute(cSql, cArgs, C.int(len(args)))

	return int(result)
}

func SetupDatabaseQuery(sql string, args []string) string {
	cSql := C.CString(sql)
	defer C.free(unsafe.Pointer(cSql))

	if len(args) == 0 {
		result := Query(cSql, nil, 0)
		return C.GoString(result)
	}

	cArgs, freeArgs := convertArgsToCStringArray(args)
	defer freeArgs()

	result := Query(cSql, cArgs, C.int(len(args)))

	return C.GoString(result)
}

func convertArgsToCStringArray(args []string) (**C.char, func()) {
	cArgs := make([]*C.char, len(args))
	for i, arg := range args {
		cArgs[i] = C.CString(arg)
	}

	return (**C.char)(unsafe.Pointer(&cArgs[0])), func() {
		for _, cArg := range cArgs {
			C.free(unsafe.Pointer(cArg))
		}
	}
}
