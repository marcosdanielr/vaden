package sqlite

import (
	"anaki/shared/drivers/interfaces"
)

var _ interfaces.Database = (*SQLiteDriver)(nil)

func (s *SQLiteDriver) Connect(connectionString string) error {
	panic("method not implemented")

}

func (s *SQLiteDriver) Close() error {
	panic("method not implemented")
}
