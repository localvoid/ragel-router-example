//go:generate ragel -Z -G2 -o router.go router.go.rl
package main

import "fmt"

func main() {
	handler, params := resolvePath("/user/1234/profile")

	fmt.Printf("handler: %s\nparams: %v\n", handler, params)
}
