PWD:=$(shell pwd)
MAINFILE=main

export CHKTEX_FLAGS?=-wall -n 6 -n 3 -n 22 -n 36
export CHKTEX=chktex $(CHKTEX_FLAGS)

export ASPELLPWS="$(PWD)/.aspell.en.pws"
export ASPELLCONF="$(PWD)/aspell.conf"
export ASPELL=aspell --personal=$(ASPELLPWS) --conf=$(ASPELLCONF) -a

export LATEXMKRC=$(PWD)/latexmkrc
export LATEX=latexmk -r "$(LATEXMKRC)" -bibtex -pdf -f

UNAME=$(shell uname -s)

SOURCES:=$(wildcard *.tex)
SOURCENAMES:=$(basename $(SOURCES))
LOCAL_COMPILE_TARGETS:=main

###
# Global
###
all: $(MAINFILE).pdf

#Generate pdf output using latexmk, so references & bib-file are run appropriately
%.pdf: %.tex refs.bib
	$(LATEX) $<

# Remove byproducts of TeX generation
clean-%: %.tex
	-$(LATEX) -c $<

clean-all-%: %.tex
	-$(LATEX) -C $<

clean-srcs: $(addprefix clean-,$(SOURCENAMES))

clean-all-srcs: $(addprefix clean-all-,$(SOURCENAMES))

###
# Visualize output using Skim or Evince depending on platform
###
ifeq ($(UNAME), Darwin)
viz: $(MAINFILE).pdf
		/usr/bin/osascript -e "set theFile to POSIX file \"$(PWD)/$<\" as alias" -e "set thePath to POSIX path of theFile" -e "tell application \"Skim\"" -e "  set theDocs to get documents whose path is thePath" -e "  try" -e "    if (count of theDocs) > 0 then revert theDocs" -e "  end try" -e "  open theFile" -e "end tell"
endif
ifeq ($(UNAME), Linux)
viz: $(MAINFILE).pdf
		evince "$(PWD)/$<" &
endif

###
# check target: Run chktex on all files
###
check: $(addprefix check-,$(SOURCENAMES))

check-%: lint-%.out
	test ! -s $<

lint-%.out: %.tex
	$(CHKTEX) $< 2>/dev/null | tee $@

clean-check: $(addprefix clean-check-,$(SOURCENAMES))

clean-check-%: %.tex
	$(RM) lint-$*.out

###
# l-check-compile target: Compile files we expect to compile
###
l-check-compile: $(addsuffix .pdf,$(LOCAL_COMPILE_TARGETS))

###
# Run spellcheck on all files
###
spellcheck: $(addprefix spellcheck-,$(SOURCENAMES))

spellcheck-%: sp-%.out
	test `tail -n +2 $< | grep -e '^#' - | wc -l` -eq "0"

sp-%.out: %.tex
	$(ASPELL) < $< > $@

clean-spellcheck: $(addprefix clean-spellcheck-,$(SOURCENAMES))

clean-spellcheck-%: %.tex
	$(RM) sp-$*.out

# Clean up test output
clean-test: clean-spellcheck clean-check

clean-all-test:

###
# Flattening file for distribution
###
dist: $(MAINFILE).tar.gz $(MAINFILE).zip

%-flat.tex: %.tex
	latexpand $< > $@

%.zip: %-flat.tex %.pdf refs.bib
	zip $@ $^

%.tar.gz: %-flat.tex %.pdf refs.bib
	tar cvzf $@ $^

clean-dist-%: %.tex
	[ -e $*-flat.tex ] && $(LATEX) -C $*-flat.tex || echo "There is no $*-flat.tex"
	$(RM) $*.tar.gz

clean-dist: clean-dist-$(MAINFILE)

clean-all-dist:

###
# Automated formatting targets
###
fmt: $(addsuffix .bak,$(SOURCENAMES))

%.bak: %.tex
	latexindent -w -l $<

clean-fmt: $(addprefix clean-fmt-,$(SOURCENAMES))

clean-fmt-%: %.tex
	$(RM) $*.bak

###
# Combined clean targets
###
CLEANLIST=main fmt check srcs dist
clean: $(addprefix clean-,$(CLEANLIST))
	$(RM) -r auto

CLEANALLLIST=test dist srcs
clean-all: clean $(addprefix clean-all-,$(CLEANALLLIST))

###
# Print variable (see http://blog.jgc.org/2015/04/the-one-line-you-should-add-to-every.html)
###
print-%: ; @echo $*=$($*)
