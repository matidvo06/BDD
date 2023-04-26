package main

import (
	"github.com/bootcamp-go/consignas-go-db.git/cmd/server/handler"
	"github.com/bootcamp-go/consignas-go-db.git/internal/product"
	"github.com/bootcamp-go/consignas-go-db.git/pkg/store"
	"github.com/gin-gonic/gin"
)

func main() {
	// Open database connection.
	databaseConfig := &mysql.Config{
		User:      "root",
		Passwd:    "gormit897",
		Addr:      "localhost:3306",
		DBName:    "storage",
		ParseTime: true,
	}

	database, err := sql.Open("mysql", databaseConfig.FormatDSN())
	if err != nil {
		panic(err)
	}

	// Ping database connection.
	if err = database.Ping(); err != nil {
		panic(err)
	}

	println("Database connection established")

	// Create products repository.
	var repository products.Repository = &products.MySQLRepository{
		Database: database,
	}

	// Get product.
	product, err := repository.Get(1)
	if err != nil {
		panic(err)
	}
	
	
	storage := store.NewJsonStore("./products.json")

	repo := product.NewRepository(storage)
	service := product.NewService(repo)
	productHandler := handler.NewProductHandler(service)

	r := gin.Default()

	r.GET("/ping", func(c *gin.Context) { c.String(200, "pong") })
	products := r.Group("/products")
	{
		products.GET(":id", productHandler.GetByID())
		products.POST("", productHandler.Post())
		products.DELETE(":id", productHandler.Delete())
		products.PATCH(":id", productHandler.Patch())
		products.PUT(":id", productHandler.Put())
	}

	r.Run(":8080")
}
