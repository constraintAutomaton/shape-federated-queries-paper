# Motivation

- [ ] Open the paper with the motivation that VoID descriptions are rarely adopted and that their vocabulary is no longer online. Tie this to the need for standard summaries.
  - [ ] The [VoID specification](https://www.w3.org/TR/void/) is still online, but the [vocabulary](https://vocab.deri.ie/void) is not
    - [ ] Look for papers about this problem; Tasitio might have one
  - [ ] Use this issue as motivation: https://github.com/w3c/sparql-service-description/issues/42
- [ ] Standard format
- [ ] More expressive

# Remarks about the approach
- [ ] Create a section in the paper for these remarks
- [ ] Serialization: target the shapes from the service description, so that a client can use the shape index
  - [ ] For instance, anyone can extract the shapes with sheXer, without needing the provider
- [ ] Exploitation of shape disjunctions

# State of the art
- [ ] Mention SPLENDID

# Implementation
- [ ] Filter expressions
- [ ] Validate that the source selection algorithm is sound
- [ ] Extract shapes with sheXer at 100% fit (no frequency threshold) for LargeRDFBench and FedShop, and verify coverage and closedness of the resulting shape index

# Formalization: endpoint summaries
- [x] Link definition (value and reference cases, subject/predicate/object positions)
- [x] `IRI_i` must contain *every* endpoint holding a triple of an entity conforming to `s_i`
- [x] Coverage equation: use `E_SI` instead of the big union (also fixes overflow)
- [x] Formalize "accepts the predicate" (closed: `p` in some triple constraint of an alternative)
- [x] Rework "Beyond the combinations..." + kinds example, now far from the triple constraint definition
- [x] Exclusive union paragraph: rephrase with alternatives `A_j` of the shape definition
- [x] Partitioning sentence ("In most cases, IRI_i contains a single endpoint...") put back
- [x] Entity locality assumption
- [x] Remove remaining "i.e."/"e.g." (foundation.tex:9, foundation.tex:19)
- [x] Remove SGSC leftovers in the approach intro and label `sec:sgsc`
- [ ] Remove the SGSC acronym once §4.2 no longer uses it

# Formalization: source selection
- [ ] Summary as a quotient of the federation built from the shape index (one named graph per endpoint IRI)
- [ ] Define `sols` over this summary, replacing Algorithm 2 (unsound: per endpoint instead of per entity)
- [ ] Treat `IRI_i` as one source group per shape (relaxed locality), so star joins across its endpoints are not lost
- [ ] Rewrite: constants → VALUES over allowed bindings (listed value, identifiers, shape IRIs n_k with the constant in ent(s_k)), checked in stage 1
- [x] Entity IRIs: `C_E` in the shape (Def. 3), `sel(t)` after Def. 2, `ent(s)` = `sel(t)` ∩ I satisfying `C_E`; replaces authorities (no index or vocabulary change)
  - [ ] Experiment: compare source selection with and without `C_E` on queries with constant IRIs (FedShop, LargeRDFBench) against FedUP
  - [ ] Future work: `sel(t)` for class and other data-dependent targets
- [x] O1–O3 taxonomy of object constraints in the source selection (`C_O` as a set of options, `obj` as a union over options, links through `N(c)`); "never a subject" assumption dropped, ASK prunes `N(c)` per (shape, predicate)
  - [ ] `si:Reach` example in `code/example_shape_index.ttl` (shape, predicate, reached shapes, `prov:generatedAtTime`)
  - [ ] ASK query: restrict `?x` to entities of `s_i` (target or required predicate) to avoid false positives from other shapes of the same endpoint
- [ ] Running example: exercise `C_E` or a node target, so `sel`/`ent` are illustrated
- [x] Choose how to avoid the disjunction explosion: (A) coarse summary first then refine
- [ ] Soundness proposition: representativeness for every subexpression (closed shapes, coverage, links)
- [ ] Filter check (use the commented TODO SPARQL sentences)
- [ ] Complexity remark (summary size per shape, alternative cap)
- [ ] Extraction: detect links between datasets and reuse the same shape IRI to preserve joins

# Expressiveness
- [ ] HiBISCuS/FedUP ("any" for literals, comment already in the text)
- [ ] Characteristic sets (Odyssey)
- [ ] RDF Molecule Templates (MULDER)

# Bibliography and submission
- [ ] Odyssey bib entry: volume/pages/doi
- [ ] Incomplete entries: cortes2025shacl, fernandez2023extracting, hanski2025observations (empty journal), Munoz2018 (author and editor)
- [ ] Abbas group ShEx containment citation
- [ ] Supplemental material: anonymous link
- [ ] Overfull boxes (kinds paragraph, coverage equation)
