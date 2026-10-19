SOURCE = main.tex refs.bib acronyms.tex section/*.tex Makefile

main.pdf: $(SOURCE)
	latexmk -pdf -shell-escape main.tex

watch:
	latexmk -pdf -pvc -shell-escape main.tex

clean:
	rm -f *.log *.bcf-SAVE-ERROR *.xmpi *.xmpdata *.abs *.aux main.pdf \
	      *.out *.text.bbl main.*.blg *.blg *.bbl *.fls *.fdb_latexmk \
	      main.log *.synctex.gz section/*.aux *.bcf *-blx.bib *.run.xml \
	      svg-inkscape/*

.PHONY: clean watch
