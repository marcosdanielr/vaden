package postgres

import (
	"anaki/shared/drivers/errors"
	"anaki/shared/drivers/interfaces"
	"context"
	"fmt"

	"github.com/jackc/pgx/v5/pgxpool"
)

var _ interfaces.Database = (*PostgresDriver)(nil)

func (p *PostgresDriver) Connect(connectionString string) error {

	conn, err := pgxpool.New(context.Background(), connectionString)
	if err != nil {
		return fmt.Errorf("%w: %v", errors.ErrFailedToConnect, err)
	}

	if err := conn.Ping(context.Background()); err != nil {
		conn.Close()
		return fmt.Errorf("%w: %v", errors.ErrFailedToConnect, err)
	}

	p.conn = conn
	return nil
}

func (p *PostgresDriver) Close() error {
	p.conn.Close()
	p.conn = nil

	return nil
}
