#import "@preview/abbr:0.2.3"

== Approach

== RDF Data Shape to Summaries

The HiBISCuS Algorithm @saleem2014hibiscus proposes a summary approach, and later by the FedUp algorithm @aimonierdavat:hal-04538238,
to improve the performance of federated queries.
Those summaries are #abbr.pls[KG] that, for each node (RDF term) and its _authority_#footnote[The authority as defined by #link("https://datatracker.ietf.org/doc/html/rfc3986")[Uniform Resource Identifier (URI): Generic Syntax)], thus from a URL `http://{authority}/schema/...` ], describe the predicates available for each triple in terms of subject and object per endpoint, such that if the result of a query performed over the summary is an empty bag, the result of performing the same query over the federation endpoint will also be an empty bag @aimonierdavat:hal-04538238.
#footnote[From Definition 3.3 of FedUP: Querying Large-Scale Federations of SPARQL Endpoints @aimonierdavat:hal-04538238]


We propose a different approach in terms of summarization, one that relies on shapes.
Indeed, at an abstract level we can observe that HiBISCuS-type summaries describe some sort of shape or structure that the data inside an endpoint exhibits.
In the world of RDF, RDF data shapes are already a mechanism used for that purpose, thus we propose that we can utilize them to have a more reusable and expressive alternative to the custom summaries used by HiBISCuS and FedUp.
We call this summary a #abbr.a("SGSC").
We define
$ "SGSC" = ("KG", "C") $
Where $"KG"$ is a set of #abbr.a[KG] and $"C"$ a set of contraints.

// let's define a triple constraint somewhere else like in a foundation section
Shape languages can express exclusive unions between sets of triple constraints, which cannot be expressed without extra semantic in a #abbr.a[KG].
An example of such constraints

`shex
ex:UserShape {
  (
     foaf:name LITERAL

    |
      foaf:givenName LITERAL+;
      foaf:familyName LITERAL
  );
  foaf:mbox IRI
}
`
From this example an user can be defined by either a `foaf:name` and a `foaf:mbox` or a `foaf:givenName`, a `foaf:familyName` and a `foaf:mbox`.
In a #abbr.a("SGSC") we can express it via two #abbr.a("KG") $"KG" = {"kg"_"name", "kg"_"full name"}$ for does two possibilites.
This can be important source of optmization as such summaries can determine that a query requiring a triple where the predicate
is `foaf:name` and the predicate is `foaf:givenName` with a joining subject, then the query engine can know that this federation member cannot
answer the join of those triple patterns.

=== Expressivity

=== Using a #abbr.a("SGSC")
