#import "@preview/abbr:0.2.3"

= Introduction

The Web has grown into the largest distributed knowledge repository ever assembled,
spanning languages, nations, and institutions across both the developed and the developing world.
Making this information machine-readable and queryable in a principled way has been a long-standing goal of the Semantic Web community.
The  #abbr.a("RDF") @w3ConceptsAbstract provides a common data model for representing structured information as directed graphs,
and SPARQL 1.1 @w3SPARQLQuery provides a standardized query language over RDF data.
Together, they enable a vision in which heterogeneous data sources distributed across the Web
can be queried as if they formed a single, coherent knowledge base.

In practice, however, the data relevant to a given query is rarely hosted at a single endpoint.
SPARQL 1.1 addresses this through _federated querying_ via the `SERVICE` clause @w3SPARQLFederated,
which allows a query to delegate sub-queries to specific remote endpoints.
The fundamental challenge with this approach is that it requires the query issuer to know, in advance,
how data is distributed across federation members, knowledge that is often unavailable or impractical to maintain at scale @hanski2025observations.

_Automatic source selection_ algorithms address this challenge by determining, without prior user knowledge,
which federation members are relevant for a given query.
Existing approaches such as HiBISCuS @saleem2014hibiscus and SPLENDID @gorlitz2011splendid construct
lightweight summaries of endpoint content and use these to prune irrelevant members before query execution.
However, most current source selection algorithms are designed for small to medium federations,
and benchmarks show that performance degrades sharply beyond 12 federation members @aimonierdavat:hal-04538238.
As the Linked Open Data cloud continues to grow, the ability to query large federations efficiently becomes increasingly important.

FedUP @aimonierdavat:hal-04538238 is the only open-source source selection algorithm capable of operating at this scale.#footnote[Lusail @lusail2017 is another algorithm claiming to solve large-scale federation, however its implementation is not publicly available.]
It constructs custom knowledge graph summaries extending the HiBISCuS summary approach#footnote[We refer to this class of summaries as HiBISCuS-type summaries throughout this paper.] to characterize the predicates and authorities of each federation member,
and uses these summaries to evaluate candidate query plans before executing them against the actual endpoints.
While effective, FedUP's summaries are a custom construction: they are expensive to build, must be rebuilt whenever endpoint content changes,
and are not reusable by other tools or consumers.
These properties reduce the incentive for endpoint operators to invest in federation infrastructure.

RDF data shapes, expressed in ShEx or SHACL @Gayo2018c, are a standardized mechanism
for describing the expected structure of RDF graphs.
Shapes are used for endpoint metadata @makelburg2025shacl,
data quality assurance @cortes2025shacl, and continuous integration pipelines @publio2022ontolo @publio2018shark.
Crucially, they capture structural information about an endpoint's content that closely mirrors what FedUP's custom summaries encode,
but as a reusable, standards-compliant artifact with utility well beyond federated query planning.

In this paper, we propose _Shape-Guided Federation_: an approach that replaces FedUP's custom summaries
with RDF data shapes as the foundation for source selection in large-scale federated querying.
Our approach is built on two contributions.
First, we define the _Set of Graph Summaries with Constraint_ (SGSC),
a summary structure that maps endpoint knowledge graphs to sets of shape-based constraints.
Second, we present _Shape-Aware Source Selection_ (SASS),
an adaptation of FedUP's result-aware source-selection algorithm that operates over an SGSC rather than a custom summary.
We show that SGSC is strictly more expressive than HiBISCuS-type summaries in two respects:
it can represent exclusive disjunctions over predicate sets,
enabling the pruning of unsatisfiable joins,
and it encodes precise object-level constraints.

The remainder of this paper is structured as follows.
@sec-related reviews related work on federated SPARQL querying and RDF data shapes.
@sec-approach introduces the Shape-Guided Federation approach, defining #abbr.a("SGSC") (@sec-sgsc) and #abbr.a("SASS") (@sec-sass).
// other sections will come.
