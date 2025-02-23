USER_SHELL := $(shell getent passwd $(shell whoami) | cut -d: -f7)
SHELL := /bin/bash
PYTHON := python3
VENV := .venv
ACTIVATE := source $(VENV)/bin/activate
COMMAND ?=

.PHONY: help setup clean activate
help:
	@echo "Available commands:"
	@echo "  make setup                   - Create virtual environment and install dependencies."
	@echo "  make activate                - Enter the virtual environment."
	@echo "  make clean                   - Remove virtual environment and cached files."
	@echo "  make exec COMMAND=<command>  - Run the specified command inside the environment."

$(VENV):
	$(PYTHON) -m venv $(VENV)
	$(ACTIVATE) && pip install --upgrade pip

setup: $(VENV)
	$(ACTIVATE) && pip install -r requirements.txt && \
	ansible-galaxy install -r requirements.yml && \
	@echo "✅ Environment setup complete!"

clean:
	rm -rf $(VENV)
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name ".mypy_cache" -exec rm -rf {} +
	find . -type d -name ".ansible" -exec rm -rf {} +
	@echo "🧹 Cleaned up the environment!"

activate:
	@echo "Virtual environment activated. To exit, type 'deactivate'."
	$(ACTIVATE) && exec $(USER_SHELL)

exec:
	$(ACTIVATE) && exec $(COMMAND)