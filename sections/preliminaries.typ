#import "@preview/abbr:0.2.3"

= Preliminaries



== Link Traversal Query Processing

== Federated Queries

Federated Queries in SPARQL are SPARQL queries over a merged knowledge graph

== FedQPL

FedQPL @cheng2020fedqpl is a formal query plan language for federated queries.
It proposes to model federated queries as query over a set of federation members $upright("fm") := (G, I)$, where $G$ is a #abbr.a[KG] and $I$ is an interface.


FedQPL define a number of expressions.
In this paper we consider the following operators.

$phi ::= upright("req")^upright("tp")_f | upright("mu") (Phi) | upright("mj") (Phi) | upright("filter")^R (phi)| upright("leftjoin")(phi, phi)$

Where $phi$ is FedQPL expression and $Phi$ a set of FedQPL expression.
$upright("req")^upright("tp")_f$


== Decentralized Knowledge Graphs and Subweb #cite(<tam2025>, supplement: "section 3.3")

We define a DKG as a KG $G$ materialized in a network of resources $R$.
A resource $r_i #sym.in R$ is mapped to a KG $g_i #sym.subset.eq G$, which is a set of triples #cite(<w3ConceptsAbstract>).
We denote this mapping $r_i #sym.mapsto _(cal("G")) g_i$.
A resource is mapped and exposed by an IRI $"iri"_i$ denoted by $"iri"_i #sym.mapsto _(cal(R)) r_i$.
The network forms a graph where the resources $r_i$ are the nodes and the $"iri"_j #sym.in g_i$ are directed edges starting from $r_i$ to $r_j$.
$G$ is formed by the union of all the $g #sym.in "dom"(R)$. %, such that $G = #sym.union.big _(i=1)^(n)g_i$ given $n$ resources in the network.
A subweb is a (sub)DKG defined by a set of IRIs controlled by a data provider.