SHELL := /bin/bash

# Makefile for papers
PAPER := NRInjectionInfrastructure

GPI_SCRIPTS := $(shell find . -name '*.gpi')
GPI_FIGURES  = $(GPI_SCRIPTS:makeplots-%.gpi=%.pdf)
XFIG_FILES  := $(shell find . -name '*.fig')
XFIGURES    = $(XFIG_FILES:%.fig=%.pdf)
#SVG_FILES   := $(shell find . -name '*.svg')
SVG_FIGURES = $(SVG_FILES:%.svg=%.pdf)
AGR_FILES   := $(shell find . -name '*.agr')
AGR_FIGURES = $(AGR_FILES:%.agr=%.pdf)
PY_FILES   := $(shell find . -name 'q*.py')
PY_FIGURES  = $(PY_FILES:%.py=%.pdf)

MANUAL_FIGURES :=
AUTO_FIGURES   := $(AGR_FIGURES) $(PY_FIGURES) $(SVG_FIGURES) $(XFIGURES) $(GPI_FIGURES)

.DEFAULT_GOAL := $(PAPER).pdf


$(PAPER).pdf: $(PAPER).tex $(AUTO_FIGURES) $(MANUAL_FIGURES) nrinj.bib
	pdflatex -draftmode -file-line-error $<
	bibtex $(PAPER)
	pdflatex -draftmode -file-line-error $<
	pdflatex -file-line-error $<

# Automatically make pdf files from .gpi (gnuplot) scripts
%.pdf: %.gpi
	gnuplot $<

# Automatically make pdf files from .fig files
%.pdf: %.fig
	fig2mpdf $<

# Automatically make pdf files from .svg files
%.pdf: %.svg
	inkscape -D -z --file=$< --export-pdf=$@

# Automatically make pdf files from .agr files
%.pdf:%.agr
	xmgrace -hardcopy -hdevice EPS -printfile epsfig.eps $<
	epstopdf --outfile=$@ epsfig.eps
	rm -f epsfig.eps

# Automatically make pdf files from .py files
%.pdf:%.py
	python $<

clean:
	@rm -f *.aux
	@rm -f *.out
	@rm -f *.log
	@rm -f *.bbl
	@rm -f *.blg
	@rm -f $(AUTO_FIGURES)
	@rm -f $(PAPER).pdf
