package ffi

/*
#include <stdlib.h>
*/
import (
	"C"
	"fmt"
)
import (
	"encoding/json"
	"unsafe"
)

func formatQueryResult(result []map[string]interface{}) string {
	jsonResult, err := json.Marshal(result)
	if err != nil {
		return fmt.Sprintf("Error marshalling result: %v", err)
	}
	return string(jsonResult)
}

func convertCArgsToGo(args **C.char, numArgs C.int) []interface{} {
	var arguments []interface{}

	if numArgs > 0 && args != nil {
		for i := 0; i < int(numArgs); i++ {
			argPtr := (**C.char)(unsafe.Pointer(uintptr(unsafe.Pointer(args)) + uintptr(i)*unsafe.Sizeof(*args)))

			if argPtr == nil || *argPtr == nil {
				continue
			}

			arg := C.GoString(*argPtr)

			arguments = append(arguments, arg)
		}
	}

	return arguments
}
