package errors

import "fmt"

var (
	ErrFailedToConnect      = fmt.Errorf("failed to connect to database")
	ErrFailedToExecuteQuery = fmt.Errorf("failed to execute query")
	ErrFailedToQuery        = fmt.Errorf("failed to execute query")
)
