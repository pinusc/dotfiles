BIBFILE=biblio.bib
BIBDIR=biblio
VIEWER=evince

all: $(patsubst %.md,%.pdf,$(wildcard *.md))

%.pdf: %.md $(BIBFILE)
	pandoc --bibliography $(BIBFILE) --filter pandoc-citeproc --latex-engine=xelatex $< -o $@

$(BIBDIR):
	mkdir $@

$(BIBFILE): $(BIBDIR)
	-cat $(wildcard $(BIBDIR)/*) > $@

clean: 
	-rm *.pdf
	-rm $(BIBFILE)
view: all
	($(VIEWER) $(wildcard *.pdf) &)

.PHONY: view clean
