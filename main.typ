#import "@preview/fine-lncs:0.1.0": lncs, institute, author, theorem, proof

#let inst_gent = institute("Universiteit Gent", 
  email: "{firstname.lastname}@ugent.be"
)

#show: lncs.with(
  title: "Shape Index Journal",
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
  ],
  keywords: ("Linked Data"),
  bibliography: bibliography("refs.bib")
)

#include "sections/plan.typ"