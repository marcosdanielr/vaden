package sqlite

import "anaki/shared/drivers/interfaces"

var _ interfaces.Database = (*SQLiteDriver)(nil)

func (s *SQLiteDriver) Execute(query string, args ...interface{}) (int64, error) {
	panic("method not implemented")
}
