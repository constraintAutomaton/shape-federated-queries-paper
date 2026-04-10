#import "@preview/abbr:0.2.3"

== Approach

== RDF Data Shape to Summaries

The HiBISCuS algorithm @saleem2014hibiscus proposes a summary approach, later refined by the FedUP algorithm @aimonierdavat:hal-04538238,
to improve the performance of federated queries.
Those summaries are #abbr.pls[KG] that, for each endpoint, characterize the predicates available for RDF terms with respect to the endpoint's _authority_
#footnote[The authority as defined by the #link("https://datatracker.ietf.org/doc/html/rfc3986")[Uniform Resource Identifier (URI): Generic Syntax] specification.]
as it appears in the endpoint IRI.
Here, the authority denotes the IRI component matching the form `http://{authority}/schema/...`.
If the result of a query performed over the summary is an empty bag, then the result of performing the same query over the federation will also be an empty bag @aimonierdavat:hal-04538238.
#footnote[From Definition 3.3 of FedUP: Querying Large-Scale Federations of SPARQL Endpoints @aimonierdavat:hal-04538238]

We propose a different approach to summarization, one that relies on shapes.
At an abstract level, we can observe that HiBISCuS-type summaries already describe some sort of structure that the data inside an endpoint exhibits.
In the world of RDF, RDF data shapes are already a mechanism used for that purpose.
We therefore propose to utilize RDF data shapes to obtain a more reusable and expressive alternative to the custom summaries used by HiBISCuS and FedUP.

We call this summary a #abbr.a("SGSC").
Formally, we consider a finite set of #abbr.pls[KG] ${"kg"_1, ..., "kg"_n}$ and, for each $"kg"_i$, a finite set of shape-based constraints $C_i$.
We define:
$ "SGSC" = {"kg"_1 #sym.mapsto C_1, "kg"_2 #sym.mapsto C_2, ..., "kg"_n #sym.mapsto C_n} $
where $"kg"_i$ is a #abbr.a[KG] and each $C_i$ is a set of constraints associated with that #abbr.a[KG].

// let's define a triple constraint somewhere else, e.g., in a foundations section.
Shape languages can express exclusive unions between sets of triple constraints, which cannot be expressed without additional semantics in a #abbr.a[KG].

#figure(
  [
    `shex
    ex:UserShape CLOSED {
      (
        foaf:name .
        |
        foaf:givenName . ;
        foaf:familyName .
      ) ;
      foaf:mbox .
    }
    `
  ],
  caption: [ShEx example with an exclusive choice of user name representation.],
  kind: "listing",
  supplement: [Listing],
) <fig-user-alt>

For example, consider the ShEx shape in @fig-user-alt.
It describes users that must have a `foaf:mbox` and either:
- a `foaf:name`, or
- a `foaf:givenName` and a `foaf:familyName`.

In terms of our definition, we model these two alternatives as two distinct #abbr.a[KG] in a #abbr.a("SGSC").
These distinct #abbr.a("KG") enable optimization by indicating that certain joins over available predicates are unsatisfiable for a given endpoint.
For example, a join on the same subject between a triple with predicate `foaf:name` and a triple with predicate `foaf:givenName` cannot be satisfied by any of the $"kg"_i$; therefore, the engine can safely prune that join for the corresponding federation member.

RDF data shapes not only express joins of triples sharing the same subject; they also express further constraints on the objects of such triples.

#figure(
  [
    `shex
    ex:UserShape CLOSED {
      rdf:type [foaf:Person foaf:User] ;
      foaf:name LITERAL ;
      foaf:mbox IRI ;
      ex:hobby @ex:Hobby ;
    }

    ex:Hobby {
      foaf:name xsd:string ;
    }
    `
  ],
  caption: [ShEx example using object constraint.],
  kind: "listing",
  supplement: [Listing],
) <fig-shex-object-constraint>

For instance, the ShEx schema in @fig-shex-object-constraint illustrates:
- a type constraint `rdf:type [foaf:Person foaf:User]`, restricting admissible subjects;
- a nested shape constraint `ex:hobby @ex:Hobby`, which requires that the object of `ex:hobby` satisfies the `ex:Hobby` shape;
- the shape `ex:Hobby` itself, which constrains hobbies to have a `foaf:name` of type `xsd:string`.

In our terminology, all these conditions are encoded inside the sets $C_i$ in a #abbr.a("SGSC").
Such constraints can be expressed in SPARQL by using functions like `isIRI` and `datatype`, or by additional triple patterns ensuring that the object satisfies another shape.
#footnote[#link("https://www.w3.org/TR/sparql11-query/#func-rdfTerms")[SPARQL 1.1 RDF term functions]]
In the case of shape constraints, an application of triple pattern matching is necessary, combined with appropriate SPARQL expressions, to faithfully implement the semantics of the corresponding $C_i$.


=== Expressivity

=== Using a #abbr.a("SGSC")
