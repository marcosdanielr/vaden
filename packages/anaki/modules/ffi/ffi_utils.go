package ffi

/*
#include <stdlib.h>
*/
import (
	"C"
	"fmt"
)
import "encoding/json"

func formatQueryResult(result []map[string]interface{}) string {
	jsonResult, err := json.Marshal(result)
	if err != nil {
		return fmt.Sprintf("Error marshalling result: %v", err)
	}
	return string(jsonResult)
}
