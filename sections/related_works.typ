#import "@preview/abbr:0.2.3"

= Related Works <sec-related>

== Decentralized Web Querying

Multiple efforts have been made to render web information machine-readable and enable automated agents to query it across distributed sources.
An early example is WebSQL @Mendelzon1996, which supports conjunctive queries over hyperlinked web documents, though without a shared data model for interlinking results across independent sources.
The Semantic Web addresses this through RDF @w3ConceptsAbstract, a common graph-based data model that allows data published by independent parties to be meaningfully combined and queried.

One querying paradigm over this distributed graph is #abbr.a("LTQP") @hartig2012foundations @Bogaerts2021LinkTW, in which an engine dynamically discovers relevant data by following RDF links at runtime.
While flexible, LTQP offers weak performance guarantees because the set of sources consulted is determined only during execution.

_Federated querying_ takes a more controlled approach: a fixed set of SPARQL endpoints is queried jointly via the `SERVICE` clause @w3SPARQLFederated @BuilAranda2013, enabling query optimization prior to execution.
A core challenge in federation is _source selection_: determining which endpoints can contribute results to a given query without contacting all of them.
Automatic source selection approaches can be divided into two categories.
The first relies on pre-built summaries of endpoint content: SPLENDID @gorlitz2011splendid, a pioneer of this direction, exploits VoID dataset descriptions @w3DescribingLinked to identify relevant endpoints at planning time.
The second issues analytic queries directly against endpoints: FedX @schwarte2011fedx, which pioneered this approach, sends ASK queries at runtime to determine which endpoints can contribute to each triple pattern.

Both categories degrade beyond approximately twelve federation members @dang2023fedshop.
FedUP @aimonierdavat:hal-04538238, inspired by the summary approach of HiBISCuS @saleem2014hibiscus, is currently the only open-source system to address this scale,
using custom knowledge graph summaries to evaluate candidate query plans before execution.
The present paper proposes replacing these custom summaries with RDF data shapes,
which have already been used to optimize centralized SPARQL queries @kashif2021 @Munoz2018.

== RDF Data Shapes

RDF data shapes are schema languages for describing the expected structure of RDF graphs.
Two standardized languages exist: Shape Expressions (ShEx) @Gayo2018 @Boneva2017 and Shapes Constraint Language (SHACL) @Gayo2018b.
Both languages share similar expressiveness for most practical use cases @Gayo2018c.
Tools exist to automatically extract RDF data shape from existing  @fernandez2023extracting.

Their primary application is data validation; they also help describe and communicate data structures, generate data, and drive user interfaces @Gayo2018a @Gayo2018c.
They have also been used for SPARQL query optimization @Abbas2018 @kashif2021.
