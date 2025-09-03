= Plan

== What is general goal of that paper

The primary goal of this paper is to demonstrate that, in the context of large decentralized networks, mapping RDF data shapes to a knowledge graph can improve query execution efficiency and reduce network usage by modeling LTQP as a federated query executed over a dynamic federation.

== Why do want to do that?

For reasons of performance and trust, indexing is essential.
However, due to technical limitations, data sovereignty, and the need to support serendipitous discovery, it's not feasible or desirable to index all valuable data particularly across very large networks.
We propose using LTQP as a bridge between indexes.
We consider indexes to be summaries of regions of a network controlled by individual data publishers, which we refer to as subwebs. This approach enables exploratory queries while preserving the trust and performance benefits of indexing.

== Prior Art

There has been work on large-scale federations, such as FedUP #cite(<aimonierdavat:hal-04538238>), as well as our own contribution on shape indexing.
Other research has explored query planning using RDF shapes combined with VoID descriptions #cite(<kashif2021>).
Additionally, there are contributions focused on building statistics over SPARQL endpoints #cite(<Langegger2009>).

== What do we want to prove

- A shape index can improve the performance of federated queries over files compared to other summary methods (e.g., VoID descriptions, histograms, etc.).
  - We might want to consider class constraint with void although this can be more expensive.
- A shape index can also improve the performance of re-executing LTQP queries, particularly when accounting for real-world considerations such as data invalidation.


== What is our contribution

=== Extention of the Old Material

- Additional experiments for pruning:
  - Network-aware oracle to estimate the percentage of relevant resources
  - Measurement of prioritization using the R3 metric (with adaptation for pruning)
  - Measurement of diefficiency metric
  - Evaluation of the relationship between the reduction in HTTP requests and the reduction in query execution time
  - Time complexity of the queries

- Further formalization:
  - Proof of the time complexity of the query subsumption algorithm (already done)

=== New Material

- Formalize LTQP in terms of federated queries
- Adapt FedUP to use a shape index
- Compare shape index with other summary methods
- Evaluate re-execution performance in the context of LTQP
  - Perform a "federated query" over the index while storing the reachability criteria and then perform the traversal over does seed documents
- Formalize an approach for adaptative query planning using shape index
