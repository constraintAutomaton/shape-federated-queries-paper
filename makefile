SOURCE= refs.bib sections/*.typ main.typ

.PHONY: clean dev watch

main.pdf: ${SOURCE}
	typst compile main.typ


watch:
	typst watch main.typ

clean:
	rm -f main.pdf
