package sqlite

import (
	"anaki/shared/drivers/errors"
	"anaki/shared/drivers/interfaces"
	"fmt"
)

var _ interfaces.Database = (*SQLiteDriver)(nil)

func (s *SQLiteDriver) Execute(query string, args ...interface{}) (int64, error) {
	result, err := s.conn.Exec(query, args...)
	if err != nil {
		return 0, fmt.Errorf("%w: %v", errors.ErrFailedToExecuteQuery, err)
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return 0, fmt.Errorf("%w: %v", errors.ErrFailedToExecuteQuery, err)
	}

	return rowsAffected, nil
}
