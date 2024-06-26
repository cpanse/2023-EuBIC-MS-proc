# $Id: makefile 37 2020-02-25 09:06:02Z rishi $
.PHONY: all out pdf bib authors.tex
TEX = 1_intro.tex 2_keynotes.tex 3_hackathons.tex 4_poster.tex 5_conclusion.tex abstract.tex keywords.tex main.tex

target=r35:~/WWW/2023EuBIC-MSProc.pdf
file=main

view: all
	open $(file).pdf

all: pdf 
	make pdf
	make bib
	make pdf
	make pdf
	
authors.tex: authors.txt
	tr -d '\r' < $< | awk -F "\t" '{print $$1;}$$1 !~ /Xi/{print "\\and"}' > $@

affiliation.tex: authors.txt
	tr -d '\r' < $< | awk -F"\t" '{a[$$1]=$$2}END{for (i in a){print i"\t&\t"a[i]}}' | sort -t"&" -k2 | awk '{print $$0"\\\\"}' | sed 's/;/\\\\\n\t\t\&/g' > $@


out:
	if  [ -f $(file).out ] ; then cp $(file).out tmp.out; fi ;
	sed 's/BOOKMARK/dtxmark/g;' tmp.out > x.out; mv x.out tmp.out ;

pdf: $(TEX)
	pdflatex $(file)
bib:
	bibtex $(file)

index:
	makeindex -s gind.ist -o $(file).ind $(file).idx 

changes:
	makeindex -s gglo.ist -o $(file).gls $(file).glo

clean:
	$(RM) authors.tex affiliation.tex main.pdf main.aux main.bbl main.blg main.log main.out main.pdf
xview:
	xpdf -z 200 $(file).pdf &>/dev/null


ins:
	latex $(file).ins 

diff:
	diff $(file).sty ../$(file).sty |less

copy:
	cp $(file).sty ../



scp:
	scp $(file).pdf $(target)
