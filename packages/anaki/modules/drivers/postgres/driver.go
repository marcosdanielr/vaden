package postgres

import (
	"anaki/shared/drivers/interfaces"

	"github.com/jackc/pgx/v5"
)

type PostgresDriver struct {
	conn *pgx.Conn
}

var _ interfaces.Database = (*PostgresDriver)(nil)
