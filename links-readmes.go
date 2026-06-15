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
	var openTags []int

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

		if name == "sync.go" || name == "links-readmes.go" || name == "README.md" || name == "README.es.md" {
			return nil
		}

		rel, _ := filepath.Rel(root, path)
		if rel == "." {
			return nil
		}

		depth := len(strings.Split(rel, string(os.PathSeparator))) - 1
		indent := strings.Repeat("  ", depth)

		// Close tags if we move to a shallower or equal depth
		for len(openTags) > 0 && openTags[len(openTags)-1] >= depth {
			lastDepth := openTags[len(openTags)-1]
			closeIndent := strings.Repeat("  ", lastDepth)
			indexLines = append(indexLines, "")
			indexLines = append(indexLines, fmt.Sprintf("%s  </details>", closeIndent))
			openTags = openTags[:len(openTags)-1]
		}

		linkPath := filepath.ToSlash(rel)
		if info.IsDir() {
			// Desplegamos por defecto el primer nivel de directorios
			openState := ""
			if depth == 0 {
				openState = " open"
			}
			indexLines = append(indexLines, fmt.Sprintf("%s* <details%s><summary>📁 **%s/**</summary>", indent, openState, name))
			indexLines = append(indexLines, "")
			openTags = append(openTags, depth)
		} else {
			indexLines = append(indexLines, fmt.Sprintf("%s* 📄 [%s](./%s)", indent, name, linkPath))
		}

		return nil
	})

	if err != nil {
		fmt.Printf("Error recorriendo el directorio: %v\n", err)
		return
	}

	// Close any remaining tags
	for i := len(openTags) - 1; i >= 0; i-- {
		lastDepth := openTags[i]
		closeIndent := strings.Repeat("  ", lastDepth)
		indexLines = append(indexLines, "")
		indexLines = append(indexLines, fmt.Sprintf("%s  </details>", closeIndent))
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
