package sqlite

import (
	"anaki/shared/drivers/interfaces"
	"database/sql"

	_ "github.com/mattn/go-sqlite3"
)

type SQLiteDriver struct {
	conn *sql.DB
}

var _ interfaces.Database = (*SQLiteDriver)(nil)
