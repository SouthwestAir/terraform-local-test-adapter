"""Configuration file for the Sphinx documentation builder.

For the full list of built-in configuration values, see the documentation:
https://www.sphinx-doc.org/en/master/usage/configuration.html

"""  # noqa: INP001

import tomllib
from datetime import date
from enum import StrEnum
from pathlib import Path

PYPROJECT_TOML = tomllib.loads((Path(__file__).parent.parent.parent / "pyproject.toml").read_text())
"""Read in the contents of ``../../pyproject.toml`` to reuse it's values."""

class SwaColor(StrEnum):
    """Southwest Airlines brand colors.

    https://www.schemecolor.com/southwest-airlines-logo-colors.php

    """

    VIOLET_BLUE = "#2E4BB1"
    CERULEAN_BLUE = "#3453C4"
    CHINEESE_SILVER = "#CCCCCC"
    LUST = "#E51D23"
    SPANISH_YELLOW = "#F9B612"


# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information
project = PYPROJECT_TOML["tool"]["poetry"]["name"]
copyright = f"{date.today().year}, Southwest Airlines Co."  # noqa: A001, DTZ011
author = PYPROJECT_TOML["tool"]["poetry"]["authors"][0]
release = "0.0.0"

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration
exclude_patterns = []

# This one is being touched on early to talk about Markdown support & linking.
# More info about extensions will be provided in 201-extensions.
extensions = [
    "myst_parser",  # enables support for Markdown
    "sphinx.ext.autosectionlabel",  # creates references for each section that can be linked back to
    "sphinx_copybutton",
]

language = "en"
templates_path = ["_templates"]

# [pygments](https://pygments.org/) is used for syntax highlighting.
# It offers many styles, found here: https://pygments.org/styles/
pygments_dark_style = "one-dark"  # syntax highlighting style; this is actually from the furo theme
# `pygments_dark_style` is actually contributed by the furo theme but I place it here to have it
#   set alongside `pygments_style` (from Sphinx).
pygments_style = "one-dark"  # syntax highlighting style

source_suffix = {
    ".md": "markdown",  # This is what tells Sphinx to use `myst_parser` for markdown files.
}

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output
html_use_opensearch = ''
html_codeblock_linenos_style = "inline"
html_css_files = [  # files relative to `html_static_path` OR public URLs
    # These are being added for the footers I'm adding in `html_theme_options`.
    "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/fontawesome.min.css",
    "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/solid.min.css",
    "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/brands.min.css",
]
html_favicon = "https://www.southwest.com/favicon.ico"
html_theme = "furo"  # external theme we want to use
html_theme_options = {  # all of these options are specific to the theme, `furo`
    "dark_css_variables": {
        "color-announcement-background": SwaColor.LUST.value,
        "color-brand-primary": SwaColor.CERULEAN_BLUE.value,
        "color-brand-content": SwaColor.CERULEAN_BLUE.value,
        "font-stack--monospace": "Inconsolata, monospace",
        "color-inline-code-background": "#24242d",
    },
    "footer_icons": [
        {
            # This adds an icon to the bottom of each page linking to the project in GitLab.
            "class": "fa-brands fa-gitlab fa-2xl",
            "name": "GitLab",
            # Here I am pulling the URL from the `pyproject.toml` file.
            "url": PYPROJECT_TOML["tool"]["poetry"]["repository"],
        }
    ],
    "light_css_variables": {
        "color-announcement-background": SwaColor.LUST.value,
        "color-brand-primary": SwaColor.VIOLET_BLUE.value,
        "color-brand-content": SwaColor.VIOLET_BLUE.value,
        "font-stack--monospace": "Inconsolata, monospace",
    },
}
html_short_title = project
html_show_copyright = True
html_show_sphinx = False
html_title = "Terraform ❎ Runner"
myst_heading_anchors = 1

# -- Options for myst_parser -------------------------------------------------
# https://myst-parser.readthedocs.io/en/latest/index.html
myst_enable_extensions = ["colon_fence"]


# -- Options of sphinx.ext.autosectionlabel ----------------------------------
# https://www.sphinx-doc.org/en/master/usage/extensions/autosectionlabel.html
autosectionlabel_prefix_document = True
