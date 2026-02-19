// Context
Federated queries of RDF data is a young field.
SPARQL 1.1 specify how to perform such queries using `SERVICE` clauses.
Such clauses necessitate the query issuer to have an a good understanding of the distribution of the data between the federation member.
Automatic source selection of federated query is an even younger field that attempt to solve the problem of having a deep understanding of the distribution of data.
Such algorithm, become even more useful when large federation are considered however few algorithm currently support the querying of federation larger than 12 members.
// Need
The only current open source algoritm able to perform such queries is called Fedup.
The Fedup algorithm relies on building a custom summary of the federation member content to perform calculation to optimize query planning.
However, those summaries are expensive to build and so far can only be used by this specific algorithm.
We propose that such approach is restrictive and does not create an insentive for the wildspread of large scale federated queries.
// Task
In this paper we propose to use RDF data shapes as summary to be used in an algorithm using the Fedup approach.
We posit that RDF data shapes being a standard and having multiple uses is a better suited summary of information furthermore
they enable better optimization potential then the custom summary proposed by the Fedup algorithm.
// Object
In this paper, we formalze our approach, we prove how our approach is strictly more expressive than the fedup custom summary and we present a benchmark of the approach.
// Findings

// Conclusion
