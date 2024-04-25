# $Id: makefile 37 2020-02-25 09:06:02Z rishi $
.PHONY: all out pdf bib authors.tex

file=main

all: pdf out authors.tex main.tex
	make pdf
	make bib
	make pdf
	
authors.tex: authors.txt
	awk -F "\t" '{print $$1;}$$1 !~ /Xi/{print "\\and"}' $< > $@


out:
	if  [ -f $(file).out ] ; then cp $(file).out tmp.out; fi ;
	sed 's/BOOKMARK/dtxmark/g;' tmp.out > x.out; mv x.out tmp.out ;

pdf:
	pdflatex $(file)
bib:
	bibtex $(file)

index:
	makeindex -s gind.ist -o $(file).ind $(file).idx 

changes:
	makeindex -s gglo.ist -o $(file).gls $(file).glo

clean:
	$(RM) authors.tex
xview:
	xpdf -z 200 $(file).pdf &>/dev/null

view:
	open -a 'Adobe Reader.app' $(file).pdf

ins:
	latex $(file).ins 

diff:
	diff $(file).sty ../$(file).sty |less

copy:
	cp $(file).sty ../
