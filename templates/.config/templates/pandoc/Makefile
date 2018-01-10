BIBFILE=biblio.bib
BIBDIR=biblio
VIEWER=evince

ifneq ("$(wildcard $(BIBDIR)/*)","")
HAS_BIBLIO = true
else
HAS_BIBLIO =
endif

all: $(patsubst %.md,%.pdf,$(wildcard *.md))

%.pdf: %.md $(if $(HAS_BIBLIO),$(BIBFILE))
ifdef $(HAS_BIBLIO)
	pandoc --bibliography $(BIBFILE) --filter pandoc-citeproc $< -o $@
else
	pandoc $< -o $@
endif

$(BIBFILE): 
	-$(if $(wildcard $(BIBDIR)/*), cat $(wildcard $(BIBDIR)/*) > $@,touch $(BIBFILE))

clean: 
	-rm *.pdf
	-rm $(BIBFILE)
view: all
	($(VIEWER) $(wildcard *.pdf) &)

.PHONY: view clean
