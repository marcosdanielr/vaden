package postgres

import (
	"anaki/shared/interfaces/contracts"
	"context"
	"fmt"
	"github.com/jackc/pgx/v5"
)

type PostgresDriver struct {
	conn *pgx.Conn
}

var _ contracts.Database = (*PostgresDriver)(nil)

func (p *PostgresDriver) Connect(connectionString string) error {
	conn, err := pgx.Connect(context.Background(), connectionString)
	if err != nil {
		return fmt.Errorf("unable to connect to database: %v", err)
	}

	p.conn = conn
	return nil
}

func (p *PostgresDriver) Query(query string, args ...interface{}) (interface{}, error) {
	panic("Method not implemented")
}

func (p *PostgresDriver) Execute(query string, args ...interface{}) (int64, error) {
	panic("Method implemented")
}

func (p *PostgresDriver) Close() error {
	panic("Method not implemented")
}
