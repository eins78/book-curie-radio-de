MATHTEX=~/bin/mathtex.cgi
PANDOC=~/.cabal/bin/pandoc

all: html txt

html:
	$(PANDOC) -f markdown curie.md -s --toc --bibliography curie.bib --csl=curie.csl -o curie.html
	for i in html-patches/* ; do patch -p0 <$$i ; done

epub:
	$(PANDOC) -f markdown curie.md --toc --epub-metadata=dc.xml --epub-cover-image=images/cover.png --bibliography curie.bib --csl=curie.csl -o curie.epub
	
txt:
	$(PANDOC) -f markdown -t plain -s curie.md --bibliography curie.bib --csl=curie.csl -o t.txt
	sed -f txtconv.sed <t.txt >curie.txt
	for i in txt-patches/* ; do patch -p0 <$$i ; done

curie.md:
	$(PANDOC) -f latex curie.tex -t markdown -o curie.md

math:
	$(PANDOC) -s --mimetex=$(MATHTEX) math.md >t.html

cv:
	sed -f convert.sed <curie.tex >curie.txt

zip:
	rm -f curie.zip
	cp curie.txt curie-utf8.txt
	zip -r curie curie-utf8.txt curie.html images

