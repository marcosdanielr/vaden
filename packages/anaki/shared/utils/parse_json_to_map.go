package utils

import (
	"encoding/json"
	"fmt"
)

func ParseJSONToMap(jsonStr string) ([]map[string]interface{}, error) {
	var rows []map[string]interface{}
	err := json.Unmarshal([]byte(jsonStr), &rows)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal JSON: %v", err)
	}
	return rows, nil
}
