package postgres

import (
	"anaki/shared/drivers/errors"
	"anaki/shared/drivers/interfaces"
	"context"
	"fmt"

	"github.com/jackc/pgx/v5"
)

type PostgresDriver struct {
	conn *pgx.Conn
}

var _ interfaces.Database = (*PostgresDriver)(nil)

func (p *PostgresDriver) Connect(connectionString string) error {
	conn, err := pgx.Connect(context.Background(), connectionString)
	if err != nil {
		return fmt.Errorf("%w: %v", errors.ErrFailedToConnect, err)
	}

	p.conn = conn
	return nil
}

func (p *PostgresDriver) Query(query string, args ...interface{}) (interface{}, error) {
	panic("Method not implemented")
}

func (p *PostgresDriver) Execute(query string, args ...interface{}) (int64, error) {
	result, err := p.conn.Exec(context.Background(), query, args...)

	if err != nil {
		return 0, fmt.Errorf("%w: %v", errors.ErrFailedToExecuteQuery, err)
	}

	return result.RowsAffected(), nil
}

func (p *PostgresDriver) Close() error {
	if p.conn != nil {
		err := p.conn.Close(context.Background())
		p.conn = nil
		return err
	}

	return nil
}
