SOURCE= refs.bib sections/*.typ main.typ

main.pdf: ${SOURCE}
	typst compile main.typ

.PHONY: clean dev

watch:
	typst watch main.typ

clean:
	rm -f main.pdf