package postgres

import (
	"anaki/shared/drivers/interfaces"

	"github.com/jackc/pgx/v5/pgxpool"
)

type PostgresDriver struct {
	conn *pgxpool.Pool
}

var _ interfaces.Database = (*PostgresDriver)(nil)
