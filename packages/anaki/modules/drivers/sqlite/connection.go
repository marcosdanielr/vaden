package sqlite

import (
	"anaki/shared/drivers/errors"
	"anaki/shared/drivers/interfaces"
	"database/sql"
	"fmt"
)

var _ interfaces.Database = (*SQLiteDriver)(nil)

func (s *SQLiteDriver) Connect(connectionString string) error {
	var err error

	s.conn, err = sql.Open("sqlite3", connectionString)
	if err != nil {
		return fmt.Errorf("%w: %v", errors.ErrFailedToConnect, err)
	}

	return nil
}

func (s *SQLiteDriver) Close() error {
	if s.conn != nil {
		err := s.conn.Close()
		s.conn = nil
		return err
	}

	return nil
}
