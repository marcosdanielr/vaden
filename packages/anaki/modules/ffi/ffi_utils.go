package ffi

/*
#include <stdlib.h>
*/
import (
	"C"
	"fmt"
	"unsafe"
)
import "encoding/json"

func formatQueryResult(result []map[string]interface{}) string {
	jsonResult, err := json.Marshal(result)
	if err != nil {
		return fmt.Sprintf("Error marshalling result: %v", err)
	}
	return string(jsonResult)
}

func convertCArgsToGoArgs(args **C.char) []string {
	var goArgs []string
	for i := 0; ; i++ {
		arg := (*C.char)(unsafe.Pointer(uintptr(unsafe.Pointer(args)) + uintptr(i)*unsafe.Sizeof(*args)))

		if arg == nil {
			break
		}

		goArgs = append(goArgs, C.GoString(arg))
	}
	return goArgs
}
