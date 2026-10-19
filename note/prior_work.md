# Prior work to check against SGSC / SASS

Goal: decide, for each work, whether it already gives one of the claimed advantages of SGSC:

- (A) disjunction / co-occurrence pruning (e.g. `foaf:name` and `foaf:givenName` never on the same subject)
- (B) object-level constraints (node kind, datatype, nested shape)
- (C) filter-aware pruning (`C ∧ k` satisfiability)
- (D) standard, reusable summary format
- (E) scales to large federations (> 12 members)

Status legend: **verified** = checked in the paper text during this session; **partial** = only abstract/metadata checked; **unverified** = from memory, check before citing.

---

## 1. Odyssey: characteristic sets for federated SPARQL — **verified**

- Montoya, Skaf-Molli, Hose. *The Odyssey Approach for Optimizing Federated SPARQL Queries.* ISWC 2017, LNCS.
- arXiv: https://arxiv.org/abs/1705.06135 (HTML: https://ar5iv.labs.arxiv.org/html/1705.06135)
- What it does:
  - Summarises each source by its **characteristic sets (CS)**, meaning the exact set of predicates an entity has, with counts.
  - "only CSs including all of the query's properties are relevant"; "properties in each star-shaped subquery are used to identify relevant CSs and sources".
  - Links between stars: characteristic pairs (CP) and federated characteristic pairs (FCP); entity synopsis to detect cross-dataset links ("never misses any relevant sources").
- Overlap with SGSC:
  - **(A) yes.** A source with CSs `{name, mbox}` and `{givenName, familyName, mbox}` has no CS containing `{name, givenName}`, so the star is pruned. This is exactly the Listing "user alt" argument.
  - (B) no, (C) no, (D) no (custom statistics), (E) evaluated on FedBench (~9 sources).
- Questions to answer:
  - Is a shape's exclusive branch anything more than a characteristic set? (Shapes can be *coarser* than CSs, since one branch can cover several CSs via optional `?`/`*` cardinalities.)
  - Odyssey uses CS for cost estimation as well. Do we need cardinalities?

## 2. MULDER / RDF Molecule Templates (RDF-MTs) — **verified (definition), partial (algorithm)**

- Endris, Galkin, Lytra, Mami, Vidal, Auer. *MULDER: Querying the Linked Data Web by Bridging RDF Molecule Templates.* DEXA 2017, LNCS 10438, pp. 3–18. (I said ICWE earlier; that was wrong, it is DEXA.)
  - Extended version: *Querying Interlinked Data by Bridging RDF Molecule Templates*, TLDKS 2018 (https://link.springer.com/10.1007/978-3-662-58415-6_1).
- Definition (from FedSDM demo paper, Endris, Vidal, Auer, https://events.tib.eu/fileadmin/data/dils2018/paper/paper_18.pdf):
  "An RDF-MT rm is described in terms of: the RDF class of rm, cardinality, set of predicates and the cardinality of each predicate, and the links to other RDF-MTs in the federation or in the same RDF dataset." Used "for decomposition, source selection, and planning of a federated query".
- Related systems by the same group: Ontario (semantic data lake), FedSDM, BOUNCER (privacy-aware, DEXA 2018).
- Overlap with SGSC:
  - An RDF-MT is essentially a **class-based shape without disjunction**: class + predicate set + links (≈ `@Shape` references).
  - (A) partial: one predicate set per class, so no exclusive alternatives inside a class. (B) partial: links between templates ≈ nested shape refs; no datatypes. (C) no. (D) no (custom RDF vocabulary). (E) unverified.
- Questions: how do RDF-MT "links" compare to nested shape constraints for cross-endpoint join pruning?

## 3. Lothbrok — **partial**

- Aebeloe, Montoya, Hose. *Optimizing SPARQL Queries over Decentralized Knowledge Graphs.* Semantic Web 14(6):1121–1165, 2023. Preprint arXiv 2208.14692.
- Peer-to-peer setting; focuses on cardinality estimation, locality awareness, fragmentation. Characteristic sets appear in the keywords; how they are used is **not yet checked**.
- Relevance: mainly to the LTQP / decentralised direction in `note/plan.typ`, less to FedUP-style federation.

## 4. Already cited, re-read with the questions above

- HiBISCuS (Saleem & Ngonga Ngomo, ESWC 2014): authority-based hypergraph pruning. **This is the baseline the expressiveness proof must subsume**, including authorities.
- FedUP (Aimonier-Davat et al.): our direct baseline.
- Kashif et al. 2021, Abbas et al. 2018: shapes for *centralised* query optimisation.
- SPLENDID (VoID).

## 5. Origin of characteristic sets — **unverified (from memory)**

- Neumann & Moerkotte. *Characteristic Sets: Accurate Cardinality Estimation for RDF Queries with Multiple Joins.* ICDE 2011. Centralised, but the original definition.

## 6. Searched, nothing found

- "SHACL shapes source selection federated SPARQL": no work using standard SHACL/ShEx as source descriptions for federated source selection showed up. This is the gap the paper can claim (D). Worth one more search on Google Scholar / DBLP before submission.

---

## Possible positioning (to discuss)

| Work      | (A) co-occurrence | (B) object constraints | (C) filters | (D) standard | (E) large fed. |
|-----------|-------------------|------------------------|-------------|--------------|----------------|
| HiBISCuS  | no                | authorities only       | no          | no           | no             |
| FedUP     | no                | authorities, `any`     | via sols    | no           | yes            |
| Odyssey   | yes (CS)          | no                     | no          | no           | ?              |
| MULDER    | partial (per class) | links only           | no          | no           | ?              |
| SGSC/SASS | yes               | yes                    | yes         | yes          | to show        |

Cells marked `?` still need checking.
