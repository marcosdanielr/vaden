package interfaces

type Database interface {
	Connect(connectionString string) error
	Query(query string, args ...interface{}) ([]map[string]interface{}, error)
	// QueryRow(query string, args ...interface{}) ([]map[string]interface{}, error)
	Execute(query string, args ...interface{}) (int64, error)
	Close() error
}
