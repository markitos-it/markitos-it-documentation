package main

import (
	"fmt"
	"os"
)

func main() {
	nombre := "Markitos"
	if len(os.Args) > 1 {
		nombre = os.Args[1]
	}
	fmt.Printf("🚀 ¡Hola, %s! Este saludo viene desde un programa en Go compilado al vuelo.\n", nombre)
}
