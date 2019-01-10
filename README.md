# README #

[![Build Status](https://travis-ci.org/jgoldfar/paper-build-demo.svg?branch=master)](https://travis-ci.org/jgoldfar/paper-build-demo)

## What is this repository for? ##

* This is a project template for papers written in LaTeX using modern tools to check for correct syntax, spelling, formatting, etc.

## How do I get set up? ##

* Make sure you have the necessary dependencies: TeXLive for the main document, GNU make (optional) for the build system.

* TBD: Minimal LaTeX installation.

* Clone this repository to your system and run `make` (if available) or `latexmk -pdf -bibtex main` to build the main file.

## Available `make` Targets ##

Several checks for correct syntax, spelling, etc. are available as make targets.

* `make check`: Run the `chktex` "linter" on the codes and fail if any issues arise.

* `make spellcheck`: Run `aspell` on all documents to check for spelling issues. `aspell` also serves to check that names are consistently used throughout the document.

To customize the list of understood words in a file, add them to `.aspell.en.pws`. See the documentation for `aspell` for how to modify the list of ignored commands etc. in the included `aspell.conf`

* `make fmt`: Run `latexindent`, an automated TeX code formatter on all source files. Note: Requires `latexindent` to be installed. See the documentation for `latexindent` to see how to modify the indentation settings in `localSettings.yaml`.

* `make dist`: Package generated pdf and necessary source files to generate `main.pdf`. Note: Requires `latexpand` version from the TeX package manager.

* `make [file].pdf`: Compile the given pdf from `[file].tex`. See the `latexmk` documentation to see how to customize the build using the included `latexmkrc`.

* `make clean`: Remove generated TeX auxiliary files.

* `make clean-all`: Remove all files which can be generated from TeX sources.

## General Style Considerations ##

Since the goal of this work is a paper, working towards and following generally accepted style for major journals is preferable. Below is a list of selected tips to keep in mind

* Use at least one line of code per sentence/line of prose. This includes mathematical equations. Making lines longer than 80 characters is discouraged.

* Use notation (and corresponding syntax) consistently.

* Run `make check` regularly and fix issues the linter finds.

* Avoid inventing new notation and overusing macros. Conversely, use macros to reduced the need to copy/paste or track down hard to find "bugs", such as an incorrect order of variables in the control set. Using a unique macro for such repeated constructs allows the definition to easily be "inlined" by a preprocessor later if necessary.

* Use AMSLaTeX constructs, so, in particular, don't use `\limits` constructs, `eqnarray` environments, etc.

* As a corollary to the previous tip, always use `gather*`, `align*`, `gather`, or `align` environments as opposed to repeated equation environments.

Unless subsequent equations must be aligned, use the corresponding gather environment.

If you would like space in the TeX code before your gather or align environment, comment out the newline to avoid poor typesetting.

* Put a non-breaking space (`~`) between the word before a `\ref`, `\eqref`, or `\cite` (`make check` will catch this issue.)

## Who do I talk to about using this repository? ##

* Jonathan Goldfarb <jgoldfar@gmail.com>
