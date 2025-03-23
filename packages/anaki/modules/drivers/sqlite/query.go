package sqlite

import (
	"anaki/shared/drivers/errors"
	"anaki/shared/drivers/interfaces"
	"database/sql"
	"fmt"
)

var _ interfaces.Database = (*SQLiteDriver)(nil)

func (s *SQLiteDriver) Query(query string, args ...interface{}) ([]map[string]interface{}, error) {
	rows, err := s.conn.Query(query, args...)
	if err != nil {
		return nil, fmt.Errorf("%w: %v", errors.ErrFailedToQuery, err)
	}
	defer rows.Close()

	return s.processRow(rows)
}

func (s *SQLiteDriver) QueryRow(query string, args ...interface{}) (map[string]interface{}, error) {
	return nil, fmt.Errorf("method not implemented")
}

func (s *SQLiteDriver) processRow(rows *sql.Rows) ([]map[string]interface{}, error) {
	var result []map[string]interface{}
	columns, err := rows.Columns()
	if err != nil {
		return nil, fmt.Errorf("failed to get columns: %v", err)
	}

	for rows.Next() {
		values := make([]interface{}, len(columns))
		valuePtrs := make([]interface{}, len(columns))

		for i := range columns {
			valuePtrs[i] = &values[i]
		}

		if err := rows.Scan(valuePtrs...); err != nil {
			return nil, fmt.Errorf("failed to scan row: %v", err)
		}

		rowData := make(map[string]interface{})
		for i, colName := range columns {
			rowData[colName] = values[i]
		}

		result = append(result, rowData)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("row iteration error: %v", err)
	}

	return result, nil
}
