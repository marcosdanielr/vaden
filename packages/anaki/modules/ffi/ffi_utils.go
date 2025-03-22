package ffi

import (
	"C"
	"fmt"
	"unsafe"
)

func FormatQueryResult(result []map[string]interface{}) string {
	var formattedResult string
	for _, row := range result {
		rowString := ""
		for key, value := range row {
			rowString += fmt.Sprintf("%s: %v, ", key, value)
		}
		formattedResult += fmt.Sprintf("{%s}\n", rowString)
	}
	return formattedResult
}

func convertCArgsToGoArgs(args **C.char, argsCount C.int) []interface{} {
	goArgs := make([]interface{}, argsCount)
	for i := C.int(0); i < argsCount; i++ {
		goArgs[i] = C.GoString(*args)
		args = (**C.char)(unsafe.Pointer(uintptr(unsafe.Pointer(args)) + uintptr(i)*unsafe.Sizeof(args)))
	}
	return goArgs
}
