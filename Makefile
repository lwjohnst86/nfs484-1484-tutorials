## Not sure if I will use this...
SHELL = /bin/bash
SLIDES := $(patsubst %.md,%.md.slides.pdf,$(wildcard *.md))
HANDOUTS := $(patsubst %.md,%.md.handout.pdf,$(wildcard *.md))

#----------------------------------------------------------------------
# Specify the default target so we're sure which one Make will choose.
#----------------------------------------------------------------------

all : commands

NOTES = \
	$(wildcard 1-tut/*notes*.md) \

SLIDES = \
	$(patsubst %.md, %.pdf, $(wildcard 1-tut/*slides*.md)) \

#----------------------------------------------------------------------
# Targets.
#----------------------------------------------------------------------

## ---------------------------------------

## commands : show all commands.
commands :
@grep -E '^##' Makefile | sed -e 's/##//g'

## ---------------------------------------

all : $(SLIDES) $(HANDOUTS)


%.md.slides.pdf : %.md
	pandoc $^ -t beamer --slide-level 2 -o $@

%.md.handout.pdf : %.md
	pandoc $^ -t beamer --slide-level 2 -V handout -o $@ 
	pdfnup $@ --nup 1x2 --no-landscape --keepinfo \
		--paper letterpaper --frame true --scale 0.9 \
		--suffix "nup"
	mv $*.md.handout-nup.pdf $@

clobber : 
	rm -f $(SLIDES)
	rm -f $(HANDOUTS)

.PHONY: commands slides notes readme
