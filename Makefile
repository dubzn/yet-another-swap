PRE_COMMIT_VERSION = 3.4.0
PRE_COMMIT_URL = https://github.com/pre-commit/pre-commit/releases/download/v$(PRE_COMMIT_VERSION)/pre-commit-$(PRE_COMMIT_VERSION).pyz
PRE_COMMIT_DEST = $(HOME)/.pre-commit

CYAN := $(shell tput -Txterm setaf 6)
GREEN := $(shell tput -Txterm setaf 2)
RESET := $(shell tput -Txterm sgr0)

deps: install-dojo install-pre-commit
	curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh -s -- -v  0.7.0 \

fmt:
	scarb fmt 
	npx prettier -w .

install-dojo:
	@echo "$(CYAN)Installing Dojo...$(RESET)"
	@if [ ! -d "${HOME}/.dojo" ]; then mkdir -p ${HOME}/.dojo; fi
	@cd ${HOME}/.dojo && \
	if [ ! -d "dojo" ]; then git clone https://github.com/dojoengine/dojo; fi && \
	cd dojo && \
	cargo install --path ./crates/katana --locked --force
	@echo "$(GREEN)Dojo installation complete.$(RESET)"


install-pre-commit:
	@echo "$(CYAN)Installing pre-commit$(RESET)"
	@if [ ! -d "$(PRE_COMMIT_DEST)" ]; then mkdir -p "$(PRE_COMMIT_DEST)"; fi
	@cd "$(PRE_COMMIT_DEST)" && \
	if [ ! -f "pre-commit-$(PRE_COMMIT_VERSION).pyz" ]; then \
		curl --proto '=https' --tlsv1.2 -sSf -o "pre-commit-$(PRE_COMMIT_VERSION).pyz" "$(PRE_COMMIT_URL)"; \
	fi && \
	python "pre-commit-$(PRE_COMMIT_VERSION).pyz"
	@echo "$(GREEN)Pre-Commit installation complete.$(RESET)"

start-katana:
	katana

build:
	scarb build

deploy:
	cargo run --bin deploy

test:
	scarb test
