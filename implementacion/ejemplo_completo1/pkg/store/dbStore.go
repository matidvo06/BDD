package store

import (
	"database/sql"
	"errors"

	"github.com/bootcamp-go/consignas-go-db.git/internal/domain"
)

type dbStore struct {
	db *sql.DB
}

// NewDbStore crea un nuevo store de productos utilizando una base de datos SQLite.
func NewDbStore(db *sql.DB) StoreInterface {
	return &dbStore{
		db: db,
	}
}

func (s *dbStore) Read(id int) (domain.Product, error) {
	row := s.db.QueryRow("SELECT id, name, price, code_value FROM products WHERE id=?", id)
	var product domain.Product
	err := row.Scan(&product.Id, &product.Name, &product.Price, &product.CodeValue)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return domain.Product{}, errors.New("product not found")
		}
		return domain.Product{}, err
	}
	return product, nil
}

func (s *dbStore) Create(product domain.Product) error {
	stmt, err := s.db.Prepare("INSERT INTO products(name, price, code_value) VALUES (?, ?, ?)")
	if err != nil {
		return err
	}
	defer stmt.Close()
	_, err = stmt.Exec(product.Name, product.Price, product.CodeValue)
	return err
}

func (s *dbStore) Update(product domain.Product) error {
	stmt, err := s.db.Prepare("UPDATE products SET name=?, price=?, code_value=? WHERE id=?")
	if err != nil {
		return err
	}
	defer stmt.Close()
	res, err := stmt.Exec(product.Name, product.Price, product.CodeValue, product.Id)
	if err != nil {
		return err
	}
	rowsAffected, err := res.RowsAffected()
	if err != nil {
		return err
	}
	if rowsAffected == 0 {
		return errors.New("product not found")
	}
	return nil
}

func (s *dbStore) Delete(id int) error {
	stmt, err := s.db.Prepare("DELETE FROM products WHERE id=?")
	if err != nil {
		return err
	}
	defer stmt.Close()
	res, err := stmt.Exec(id)
	if err != nil {
		return err
	}
	rowsAffected, err := res.RowsAffected()
	if err != nil {
		return err
	}
	if rowsAffected == 0 {
		return errors.New("product not found")
	}
	return nil
}

func (s *dbStore) Exists(codeValue string) bool {
	row := s.db.QueryRow("SELECT COUNT(*) FROM products WHERE code_value=?", codeValue)
	var count int
	err := row.Scan(&count)
	if err != nil {
		return false
	}
	return count > 0
}
