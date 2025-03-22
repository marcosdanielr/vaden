package sqlite

import (
	"anaki/shared/drivers/interfaces"
)

var _ interfaces.Database = (*SQLiteDriver)(nil)

func (p *SQLiteDriver) Query(query string, args ...interface{}) ([]map[string]interface{}, error) {
	panic("Method not implemented")
}
