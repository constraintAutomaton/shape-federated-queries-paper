#import "@preview/abbr:0.2.3"

= Approach
 

== FedQPL for Dynamic Federations

=== Operator Extension

We propose to extend the definition of a federation member to $upright("fm") := (G, I, S)$, where $S$ represents the subweb that the federation member is part of.
The subweb $S$ is defined by the tuple $(D, R)$, where $D$ is the set of IRIs that the subweb encompasses and $R$ contains summary information about the subweb.

// We propose to extend FedQPL with the following operators $upright("ask")^upright("tp")_f$ which represent a request of the existence of a triple pattern to a federation member.

=== Expending Query Plan
// How are we gonna model request to index informations

To model an extending query plan, we propose using the concept of series.
At step $s$, the query engine performs a query with the FedQPL expression $phi_s$ using federation $upright("Fm")_s$.
A next step, is taken when a new federation member is discovered.

More formally, let $bold(F) = (upright("Fm")_1, upright("Fm")_2, ..., upright("Fm")_n)$ be a series of federations $upright("Fm")$,
and $bold(E) = (phi_1, phi_2, ..., phi_n)$ be a series of FedQPL expressions $phi$.
The series $bold(F)$ is monotonically increasing, such that $upright("Fm")_i subset upright("Fm")_j$ for all $i < j$.

The creation of $phi_(s)$ from a previous state $phi_(s-1)$ depends on the source assignment algorithm $upright("Sa")$.
For some source assignment algorithm it is possible to create an incremental version to improve the computation.
In the following sections we will explore some source assignment algorithms.

==== Exhaustive Source Assignments

The #abbr.a[ESA] algorithm @cheng2020fedqpl produce plans of the form 

$phi_i = upright("mj") ( 
upright("mu") ({upright("req")^({t_1})_(f_1), ..., upright("req")^({t_1})_(f_n)}),
...,
upright("mu") ({upright("req")^({t_m})_(f_1), ..., upright("req")^({t_m})_(f_n)})
)$ 
adding a new federation member $f_j$ to the plan is trivial it consists of adding a new operator $upright("req")^(upright("tp")_i)_(f_j)$ to all the $upright("mu")$ operators.

==== FedX

The FedX algorithm's source selection process @schwarte2011fedx consists of two parts: first, identifying the relevant data sources for each triple pattern, and second, determining exclusive groups to optimize query execution.

A FedX query plan use as a basis an #abbr.a[ESA] query plan.
It optimize it by identifing the irrelevant data source for each triple patterns.
To perform this operation it send `ASK` queries ($upright("ask")^upright("tp")_f$) and when the response of the ask queries are negative the $upright("req")^(upright("tp"))_(f)$ operator in the plan is removed.

Exclusive groups are sets of triple patterns that can be exclusively answered by a single federation member.
By identifying these groups, the query plan can be optimized by removing the corresponding triple patterns from unions in the plan and replacing them with a single $upright("req")^(T_i)_(f_i)$,
where the exclusive group $T_i$ targets the federation member $f_i$.

In an expending plan context, the first part of the algorithm is simple it simply consists of sending `ASK` queries to the new federation members to determine in which union ($upright("mu")$) the new federation members must be integrated. However, for exclusive grouping it is a bit more complex
// Let's think about it later. There is a problem of lost of results I think we reorder operators

$upright("mj") ({upright("req")^(T_i)_(f_i), upright("req")^({t in T_i})_(f_j)})$
== A Federated Query Interpretation of LTQP

LTQP while a different query paradigm has some similarities with federated queries to the extend that we propose that for the context of query planning a similar model can be used.
To understand those similarities we first need to engage with federated queries using variables as IRI for there `SERVICE` clauses.
We are going to refer to those federations as _dynamic federation(s)_.

SPARQL 1.1 allows the use of variables as IRIs for endpoints targeted by SERVICE clauses @w3SPARQLQuery.
In this paper we are going to refer to the
While the language does not impose syntactic restrictions to prevent queries over an infinite set of federation members, the concept of _Service-Safeness_ @buildAranda2013 provides such restrictions to guarantee a sufficient, but not necessary, condition for the query to be processed over a finite set of endpoints.
@code_example_fed_query_var present an example query

#figure(
```rq
PREFIX ex: <http://example.org/>
PREFIX dbo: <http://dbpedia.org/ontology/>

SELECT ?scientist ?birthPlace
WHERE {
  # First, discover available endpoints from a registry
  ?registry ex:hasEndpoint ?scientistService .
  ?registry ex:hasEndpoint ?biographyService .

  # Query the first service to find scientists
  SERVICE ?scientistService {
    ?scientist a dbo:Scientist ;
               ex:relatedDataAt ?biographyService .
  }

  # Query the second service for biographical data
  SERVICE ?biographyService {
    ?scientist dbo:birthPlace ?birthPlace .
  }
}
```,
caption: [Federated SPARQL query using variable endpoints discovered during the execution],
) <code_example_fed_query_var>

// We will need to define somewhere the rechability criteria
LTQP can also produce dynamic federations, though it's concept of reachability criteria @hartig2012foundations.
Reachability criteria being boolean functions have more expressivity than the dynamic federation mechanism of SPARQL 1.1 which is restricted by the expressivity of SPARQL, however we 
can model an abstraction that could take into consideration any generator of federation members.
This would also in the context of LTQP consider other dynamic federation models such as the language LDQPL @hartigLDQL and the Subweb Specifications Language (SWSL) @Bogaerts2021LinkTW

== FedQPL formalization of LTQP
// adaptative query planning!!!!!!

Adaptative 

Canvas based query plan

=== Implementation