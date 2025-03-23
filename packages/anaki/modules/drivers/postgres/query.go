package postgres

import (
	"anaki/shared/drivers/errors"
	"anaki/shared/drivers/interfaces"
	"context"
	"fmt"

	"github.com/jackc/pgx/v5"
)

var _ interfaces.Database = (*PostgresDriver)(nil)

func (p *PostgresDriver) Query(query string, args ...interface{}) ([]map[string]interface{}, error) {
	rows, err := p.conn.Query(context.Background(), query, args...)
	if err != nil {
		return nil, fmt.Errorf("%w: %v", errors.ErrFailedToQuery, err)
	}
	defer rows.Close()

	return p.processRow(rows)
}

func (p *PostgresDriver) QueryRow(query string, args ...interface{}) (map[string]interface{}, error) {
	row := p.conn.QueryRow(context.Background(), query, args...)

	columns, err := p.getQueryColumnNames(query, args...)
	if err != nil {
		return nil, err
	}

	return p.scanRow(row, columns)
}

func (p *PostgresDriver) processRow(rows pgx.Rows) ([]map[string]interface{}, error) {
	var result []map[string]interface{}
	fieldDescriptions := rows.FieldDescriptions()

	for rows.Next() {
		values := make([]interface{}, len(fieldDescriptions))
		valuePtrs := make([]interface{}, len(fieldDescriptions))

		for i := range fieldDescriptions {
			valuePtrs[i] = &values[i]
		}

		if err := rows.Scan(valuePtrs...); err != nil {
			return nil, fmt.Errorf("failed to scan row: %v", err)
		}

		rowData := make(map[string]interface{})
		for i, field := range fieldDescriptions {
			rowData[string(field.Name)] = values[i]
		}

		result = append(result, rowData)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("row iteration error: %v", err)
	}

	return result, nil
}

func (p *PostgresDriver) getQueryColumnNames(query string, args ...interface{}) ([]string, error) {
	rows, err := p.conn.Query(context.Background(), query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	// Extrai apenas os nomes das colunas
	var columnNames []string
	for _, field := range rows.FieldDescriptions() {
		columnNames = append(columnNames, string(field.Name))
	}

	return columnNames, nil
}

func (p *PostgresDriver) scanRow(row pgx.Row, columnNames []string) (map[string]interface{}, error) {
	values := make([]interface{}, len(columnNames))
	valuePtrs := make([]interface{}, len(columnNames))

	for i := range values {
		valuePtrs[i] = &values[i]
	}

	if err := row.Scan(valuePtrs...); err != nil {
		if err == pgx.ErrNoRows {
			return nil, fmt.Errorf("no rows returned")
		}
		return nil, fmt.Errorf("failed to scan row: %v", err)
	}

	return p.mapRowValues(columnNames, values), nil
}

func (p *PostgresDriver) mapRowValues(columnNames []string, values []interface{}) map[string]interface{} {
	rowData := make(map[string]interface{})

	for i, col := range columnNames {
		rowData[col] = values[i]
	}

	return rowData
}
