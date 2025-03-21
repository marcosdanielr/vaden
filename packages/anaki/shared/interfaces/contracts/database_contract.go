package contracts

type Database interface {
	Connect(connectionString string) error
	Query(query string, args ...interface{}) (interface{}, error)
	Execute(query string, args ...interface{}) (int64, error)
	Close() error
}
