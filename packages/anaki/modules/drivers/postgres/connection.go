package postgres

import (
	"anaki/shared/drivers/errors"
	"anaki/shared/drivers/interfaces"
	"context"
	"fmt"

	"github.com/jackc/pgx/v5"
)

var _ interfaces.Database = (*PostgresDriver)(nil)

func (p *PostgresDriver) Connect(connectionString string) error {
	conn, err := pgx.Connect(context.Background(), connectionString)
	if err != nil {
		return fmt.Errorf("%w: %v", errors.ErrFailedToConnect, err)
	}

	p.conn = conn
	return nil
}

func (p *PostgresDriver) Close() error {
	if p.conn != nil {
		err := p.conn.Close(context.Background())
		p.conn = nil
		return err
	}

	return nil
}
