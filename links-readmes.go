package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	root := "."
	var indexLines []string

	err := filepath.Walk(root, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		name := info.Name()

		if name != "." && strings.HasPrefix(name, ".") {
			if info.IsDir() {
				return filepath.SkipDir
			}
			return nil
		}

		if name == "sync.go" || name == "README.md" || name == "README.es.md" {
			return nil
		}

		rel, _ := filepath.Rel(root, path)
		if rel == "." {
			return nil
		}

		depth := len(strings.Split(rel, string(os.PathSeparator))) - 1
		indent := strings.Repeat("  ", depth)

		linkPath := filepath.ToSlash(rel)
		if info.IsDir() {
			indexLines = append(indexLines, fmt.Sprintf("%s* 📁 **%s/**", indent, name))
		} else {
			indexLines = append(indexLines, fmt.Sprintf("%s* 📄 [%s](./%s)", indent, name, linkPath))
		}

		return nil
	})

	if err != nil {
		fmt.Printf("Error recorriendo el directorio: %v\n", err)
		return
	}

	indexContent := strings.Join(indexLines, "\n")

	filesToUpdate := []string{"README.md", "README.es.md"}
	for _, file := range filesToUpdate {
		err := updateFileIndex(file, indexContent)
		if err != nil {
			fmt.Printf("❌ Error actualizando %s: %v\n", file, err)
		} else {
			fmt.Printf("✅ %s actualizado correctamente.\n", file)
		}
	}
}

func updateFileIndex(filename string, newIndex string) error {
	content, err := os.ReadFile(filename)
	if err != nil {
		return err
	}

	strContent := string(content)
	startMarker := "<!-- INDEX_START -->"
	endMarker := "<!-- INDEX_END -->"

	startIndex := strings.Index(strContent, startMarker)
	endIndex := strings.Index(strContent, endMarker)

	if startIndex == -1 || endIndex == -1 || startIndex >= endIndex {
		return fmt.Errorf("marcadores no encontrados o inválidos en %s", filename)
	}

	before := strContent[:startIndex+len(startMarker)]
	after := strContent[endIndex:]

	newContent := before + "\n" + newIndex + "\n" + after

	return os.WriteFile(filename, []byte(newContent), 0644)
}
