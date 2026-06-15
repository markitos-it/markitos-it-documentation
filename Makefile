.PHONY: help links-readmes

# Default target
help:
	@echo ""
	@echo ""
	@echo "#:[.'.]:>----------------------------------------------------------------------------------"
	@echo "#:[.'.]:>- The Artisan's Knowledge Base - Makefile Commands"
	@echo "#:[.'.]:>----------------------------------------------------------------------------------"
	@echo "#:[.'.]:>- help          : Show this help message"
	@echo "#:[.'.]:>- links-readmes : Auto-generate the index for the README files"
	@echo "#:[.'.]:>----------------------------------------------------------------------------------"
	@echo ""

links-readmes:
	go run links-readmes.go
