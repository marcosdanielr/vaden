package postgres

import (
	"anaki/shared/drivers/errors"
	"anaki/shared/drivers/interfaces"
	"context"
	"fmt"
)

var _ interfaces.Database = (*PostgresDriver)(nil)

func (p *PostgresDriver) Execute(query string, args ...interface{}) (int64, error) {
	result, err := p.conn.Exec(context.Background(), query, args...)

	if err != nil {
		return 0, fmt.Errorf("%w: %v", errors.ErrFailedToExecuteQuery, err)
	}

	return result.RowsAffected(), nil
}
