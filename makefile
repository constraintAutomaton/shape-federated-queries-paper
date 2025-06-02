SOURCE= refs.bib sections/*.typ main.typ

main.pdf: ${SOURCE}
	typst compile main.typ

.PHONY: clean dev

dev:
	typst watch main.typ

clean:
	rm -f main.pdf