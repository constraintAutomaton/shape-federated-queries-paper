// Context
Federated querying of RDF data sources using SPARQL 1.1 relies on `SERVICE` clauses,
which require the query issuer to know how data is distributed across federation members.
Automatic source selection algorithms address this requirement,
but few currently support federations larger than 12 members.
// Need
The only open-source algorithm capable of querying such large federations is Fedup,
which constructs custom summaries of federation member's content to optimize query planning.
However, these summaries are expensive to build and are usable only by Fedup itself,
limiting their broader applicability and reducing incentives for adoption of large-scale federated querying.
// Task
We propose using RDF data shapes as an alternative summary representation within the Fedup approach.
RDF data shapes are a W3C standard with uses beyond source selection,
making them more reusable than Fedup's custom summaries.
// Object
We formalize our approach, prove that RDF data shapes are strictly more expressive
than Fedup's custom summaries, and present a benchmark evaluation.
// Findings
// Conclusion
