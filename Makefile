SHELL := /bin/bash
# Variables
SPHINXOPTS    ?=
SPHINXBUILD   ?= poetry run sphinx-build
SOURCEDIR     = ./docs/source/
BUILDDIR      = ./docs/build

# Cleaning
clean: ## remove old build artifacts
	@rm -rf $(BUILDDIR)/*
	@echo "Removed HTML files from previous build"

# HTML Build Task
html:
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

# Start Sphinx auto-build server
html-watch: ## start sphinx-autobuild server & open a browser window
	@poetry run sphinx-autobuild "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O) --open-browser

# Open built documentation in the browser
open: ## open locally built documentation with our default browser
	@open $(BUILDDIR)/html/index.html

docs: clean html ## remove old build artifacts & build HTML docs
