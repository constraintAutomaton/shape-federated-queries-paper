#import "@preview/fine-lncs:0.1.0": lncs, institute, author, theorem, proof
#import "@preview/abbr:0.2.3"

#let inst_gent = institute("Ghent University", 
  email: "{firstname.lastname}@ugent.be"
)

#show: lncs.with(
  title: "From Traversal to Dynamic Federation: Rethinking Link Traversal Query Processing through Subwebs and RDF Shapes",
  thanks: "Supported by organization x.",
  authors: (
    author("Bryan-Elliott Tam", 
      insts: (inst_gent),
      oicd: "0000-0003-3467-9755",
    ),
    author("Ruben Taelman", 
      insts: (inst_gent),
      oicd: "0000-0001-5118-256X",
    ),
    author("Pieter Colpaert", 
      insts: (inst_gent),
      oicd: "0000-0001-6917-2167",
    ),
  ),
  abstract: [
    #include "sections/abstract.typ"
  ],
  keywords: ("Linked Data", "LTQP", "Federated Queries"),
  bibliography: bibliography("refs.bib")
)

#abbr.make(
  ("KG", "knowledge graph"),
  ("ESA", "exhaustive source assignments")
)

#include "sections/preliminaries.typ"
#include "sections/approach.typ"