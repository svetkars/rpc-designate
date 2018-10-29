# Documentation contributor guidelines

These guidelines provide the general process for maintaining source code for the
instructions in this repository (repo).

- [Documentation description](#documentation-description)
- [Updating and adding content](#updating-and-adding-content)
- [Using writing guidelines](#using-writing-guidelines)
- [Submitting your content](#submitting-changes)
- [Previewing changes](#previewing-changes)

## Documentation description

This repository includes the RPC Designate documentation that is written in
[reStructuredText](http://sphinx-doc.org/rest.html), which is the markup
syntax and parser component of [Python Docutils](http://docutils.sourceforge.net/index.html).

## Updating and adding content

Contributions are submitted, reviewed, and accepted by using GitHub pull
requests (PRs), following the [GitHub workflow](GITHUBING.md) for this repository.

To update existing source files or add new ones, follow the
[GitHub workflow](GITHUBING.md) for this repository.

* Update source files by using the GitHub editor or any plain text editor.
* Format RST source files with
  [reStructuredText syntax](http://www.sphinx-doc.org/en/stable/rest.html), and for quick syntax checking, try the [Online reStructuredText editor](http://rst.ninjs.org/).
* Format Markdown (.md) source files with [Markdown syntax](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet).

## Using writing guidelines

When you add or update content, use the writing and style guidelines
in the [Style guidelines for technical content](http://rackerlabs.github.io/docs-rackspace/style-guide/index.html).
Start with the guidelines in the [QuickStart](http://rackerlabs.github.io/docs-rackspace/style-guide/quickstart.html#quickstart)
section.

## Submitting changes

When you've completed your changes, submit a PR. Someone on the
Information Development team will review your PR.

- Minor updates and corrections get a quick review to ensure that content is
  error-free and doesn't introduce other issues.
- More complex changes or additions require both technical and editorial review.

Depending on the review feedback, you might be asked to make additional changes.

After content has been reviewed and approved, the updates can be merged to the
master branch.

## Previewing changes

When you submit a PR, the build process creates a preview of
your changes in a staging environment. After the build process completes, a
message displays in the PR comments with a link to the
content in a staging environment.

You can also build the project locally by using the [Sphinx documentation
generator](http://sphinx-doc.org/). For details, see
[Building from
source](https://github.com/rackerlabs/docs-rackspace/blob/master/doc/tools/build-from-source.rst).

Another easy way of building the documentation locally is to run ``tox``
from the `docs` directory:

```
cd doc
tox
```
