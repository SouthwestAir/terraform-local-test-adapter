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

# Test artifacts to purge before running terraform test
TEST_ARTIFACTS := pytest.json pytest.log jest.json jest.log junit.xml

# Remove generated test report/log files from anywhere in the repo
clean-test-artifacts: ## delete pytest/jest/junit report & log files recursively
	@find . \( -path ./.git -o -path ./.venv -o -path ./node_modules -o -path ./.terraform \) -prune -o \
		-type f \( $(foreach f,$(TEST_ARTIFACTS),-name $(f) -o) -false \) -exec rm -f {} +
	@echo "Removed test artifacts: $(TEST_ARTIFACTS)"

# Run terraform test after purging stale artifacts
test: clean-test-artifacts ## clean stale test artifacts then run terraform test
	@terraform init && terraform test -junit-xml=tf_junit.xml
