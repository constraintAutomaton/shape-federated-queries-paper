#import "@preview/abbr:0.2.3"
#import "@preview/algorithmic:1.0.7": algorithm, Function, If, ElseIf, Else, For, Assign, Return, Line, IfElseChain

= Shape-Guided Federation <sec-approach>

We propose _Shape-Guided Federation_, an approach that replaces the costly custom summaries
used by HiBISCuS and FedUP with RDF data shapes, which are increasingly published alongside
SPARQL endpoints and offer greater expressiveness at no additional construction cost.
We first define our summary structure, the #abbr.a("SGSC") (@sec-sgsc), then present
#abbr.a("SASS"), our shape-aware adaptation of FedUP's result-aware source-selection
algorithm (@sec-sass).

== Endpoint Summaries via RDF Data Shapes <sec-sgsc>

The HiBISCuS algorithm @saleem2014hibiscus proposes a summary approach, later refined by FedUP @aimonierdavat:hal-04538238, to improve federated query performance.
These summaries are #abbr.pls("KG") that, for each endpoint, characterize the predicates available for #abbr.a("RDF") terms with respect to the endpoint's _authority_#footnote[The authority as defined by the #link("https://datatracker.ietf.org/doc/html/rfc3986")[Uniform Resource Identifier (URI): Generic Syntax] specification.] in its IRI.
In this paper, we use _authority_ to denote the endpoint-identifying IRI component in expressions of the form `http://{authority}/schema/{rest}`.
If evaluating a query over the summary yields an empty bag, then evaluating the same query over the federation also yields an empty bag @aimonierdavat:hal-04538238.
#footnote[From Definition 3.3 of FedUP: Querying Large-Scale Federations of SPARQL Endpoints @aimonierdavat:hal-04538238]
It has to be noted that usally those summaries produce #abbr.pls[KG] significantly smaller then the ones hosted in the endpoints.

We propose a different summarization approach, based on RDF data shapes.
At an abstract level, HiBISCuS-type summaries already capture structural regularities of endpoint data, and RDF shape languages provide a standard mechanism to represent this structure.
We therefore use RDF data shapes to obtain a reusable and more expressive alternative to the custom summaries used by HiBISCuS and FedUP.

We call this summary an #abbr.a("SGSC").
Formally, we consider a finite set of #abbr.pls[KG] ${"kg"_1, ..., "kg"_n}$ and, for each $"kg"_i$, a finite set of shape-based constraints $C_i$.
We define:
#set math.equation(numbering: "(1)")
$ "SGSC" = {"kg"_1 #sym.mapsto C_1, "kg"_2 #sym.mapsto C_2, ..., "kg"_n #sym.mapsto C_n} $ <eq-sgsc-def>
#set math.equation(numbering: none)
where $"kg"_i$ is a #abbr.a[KG] and each $C_i$ is the set of constraints associated with that #abbr.a[KG].

Shape languages can express exclusive unions between sets of triple constraints.
In an #abbr.a("SGSC"), each admissible alternative can be represented as a distinct constraint set for a #abbr.a[KG], which makes the #abbr.a[KG]-level summary explicit.
HiBISCuS-type summaries do not natively encode such exclusivity without introducing additional semantics.

#figure(
  [
    ```shex
    ex:UserShape CLOSED {
      (
        foaf:name .
        |
        foaf:givenName . ;
        foaf:familyName .
      ) ;
      foaf:mbox .
    }
    ```
  ],
  caption: [ShEx example with an exclusive choice of user name representation.],
  kind: "listing",
  supplement: [Listing],
) <fig-user-alt>

For example, consider the ShEx shape in @fig-user-alt.
It describes users that must have a `foaf:mbox` and either:
- a `foaf:name`, or
- a `foaf:givenName` and a `foaf:familyName`.

In terms of Equation @eq-sgsc-def, we model these two alternatives as two distinct admissible constraint sets.
These distinct sets enable optimization by showing that some joins over available predicates are unsatisfiable for a given endpoint.
For example, a join on the same subject between a triple with predicate `foaf:name` and a triple with predicate `foaf:givenName` cannot be satisfied by any admissible set for that endpoint; therefore, the engine can safely prune this join from the query plan for the corresponding federation member.
This illustrates one dimension in which #abbr.a("SGSC") is more expressive than HiBISCuS-type summaries.


RDF data shapes not only express joins of triples sharing the same subject; they also express further constraints on the objects of such triples.

#figure(
  [
    ```shex
    ex:UserShape CLOSED {
      rdf:type [foaf:Person foaf:User] ;
      foaf:name LITERAL ;
      foaf:mbox IRI ;
      ex:hobby @ex:Hobby ;
    }

    ex:Hobby {
      foaf:name xsd:string ;
    }
    ```
  ],
  caption: [ShEx example using object constraint.],
  kind: "listing",
  supplement: [Listing],
) <fig-shex-object-constraint>

For instance, the ShEx schema in @fig-shex-object-constraint illustrates:
- a type constraint `rdf:type [foaf:Person foaf:User]`, restricting admissible subjects;
- a nested shape constraint `ex:hobby @ex:Hobby`, which requires that the object of `ex:hobby` satisfies the `ex:Hobby` shape;
- the shape `ex:Hobby` itself, which constrains hobbies to have a `foaf:name` of type `xsd:string`.

In our terminology, all these conditions are encoded in the sets $C_i$ of an #abbr.a("SGSC").
Such constraints can be expressed in SPARQL by using functions such as `isIRI` and `datatype`, or by additional triple patterns ensuring that the object satisfies another shape.
#footnote[#link("https://www.w3.org/TR/sparql11-query/#func-rdfTerms")[SPARQL 1.1 RDF term functions]]
For nested shape constraints, this translation relies on combining triple-pattern matching with these SPARQL expressions.
This is another aspect in which #abbr.a("SGSC") is more expressive than HiBISCuS-type summaries: FedUP uses the term `"any"` when an object is a literal @aimonierdavat:hal-04538238, whereas an #abbr.a("SGSC") can encode substantially more precise object-level conditions.



== Shape-Aware Source Selection <sec-sass>
We call our approach _#abbr.a("SASS")_: a result-aware source-selection procedure that operates over an #abbr.a("SGSC") rather than a plain HiBISCuS-type summary.
To position SASS with respect to prior work, we first restate the Result-Aware source-selection procedure used in FedUP.
@alg-fedup-result-aware is reproduced from FedUP (Algorithm 1)@aimonierdavat:hal-04538238.

#figure(
  algorithm(
    Function("A", ($Q$, $F$), {
      Return[$"mu"(A'(Q, F))$]
    }),
    Function([$A'$], ($Q$, $F$), {
      Assign[$Phi_o$][$emptyset$]
      IfElseChain(
        [$Q$ is a triple pattern $"tp"$], {
          Assign[$Phi_o$][$Phi_o union lr({"req"_("tp")^f | f in F})$]
        },
        [$Q$ is $(P_1 join P_2)$], {
          Line[$Phi_1, Phi_2 arrow.l A'(P_1, F), A'(P_2, F)$]
          Assign[$Phi_o$][$Phi_o union lr({"mj" lr({phi_1, phi_2}) | phi_1 in Phi_1 and phi_2 in Phi_2})$]
        },
        [$Q$ is $(P_1 union P_2)$], {
          Line[$Phi_1, Phi_2 arrow.l A'(P_1, F), A'(P_2, F)$]
          Assign[$Phi_o$][$Phi_o union lr({phi | phi in Phi_1 or phi in Phi_2})$]
        },
        [$Q$ is $(P_1 join.l P_2)$], {
          Line[$Phi_1, Phi_2 arrow.l A'(P_1, F), A'(P_2, F)$]
          For([$phi_1 in Phi_1$], {
            Assign[$Phi_("join")^(phi_1)$][$lr({phi_2 | phi_2 in Phi_2 and "sols"("mj" lr({phi_1, phi_2})) eq.not emptyset})$]
            IfElseChain(
              [$Phi_("join")^(phi_1) = emptyset$], {
                Assign[$Phi_o$][$Phi_o union lr({phi_1})$]
              },
              {
                Assign[$Phi_o$][$Phi_o union lr({"leftjoin"(phi_1, mu Phi_("join")^(phi_1))})$]
              }
            )
          })
        },
        [$Q$ is $(P "FILTER" R)$], {
          Assign[$Phi$][$A'(P, F)$]
          Assign[$Phi_o$][$Phi_o union lr({"filter"_R (phi) | phi in Phi})$]
        }
      )
      Return[$lr({phi | phi in Phi_o and "sols"(phi) eq.not emptyset})$]
    })
  ),
  caption: [Result-Aware source-selection procedure reproduced from FedUP (Algorithm 1) @aimonierdavat:hal-04538238.],
  kind: "listing",
  supplement: [Algorithm],
) <alg-fedup-result-aware>
// I could calculate the time complexity of the algorithm

The $"sols"(phi)$ function evaluates query plan $phi$ against a HiBISCuS-type summary,
returning the bag of results it produces.
The goal of the result-aware source-selection algorithm is to generate an exhaustive set of
relevant query plans and to evaluate each plan over the summary to determine which federation
members cannot produce results for it.

We propose to replace $"sols"(phi)$ with $"sols"_{"SGSC"}(phi)$ throughout this algorithm.
This modification is necessary because our proposed summary is not a #abbr.a("KG"); it is an
exclusive union of #abbr.a("SGSC") branches, each paired with a shape constraint.

Algorithm @alg-sols-SGSC presents $"sols"_{"SGSC"}(phi)$.
The idea is to iterate over every branch of the exclusive union in $S$ and check whether that
branch alone can answer the query derived from $phi$.
For this purpose, we extend the signature of $"sols"$ to $"sols"(phi, "S")$, where $"S"$ is the set of
#abbr.a("KG") instances over which the query is evaluated.
The helper function $"constraint"$ collects all `FILTER` expressions from the query plan into
a single conjunctive expression; it also rewrites each ground term (IRI or literal) in a triple
pattern into a fresh variable and adds an equality filter between that variable and the original term.

In @alg-sols-SGSC, the condition $r_"bag" != emptyset and C and k$ has two purposes.
First, $r_"bag" != emptyset$ confirms that evaluating $phi$ against branch $"kg"$ yields at
least one result on the summary.
Second, the conjunct $C and k$ checks whether the shape constraints $C$ of the branch are
satisfiable together with the filter expression $k$ derived from $phi$.
A branch that fails this satisfiability check is pruned: even if it produces results on the
summary, those results cannot satisfy the query's filter constraints given the shape of the data.

#figure(
  algorithm(
    Function($"sols"_"SGSC"$, ($phi$, $S$), {
      For([$"kg" mapsto C in S$], {
        Assign[$r_("bag")$][$"sols"(phi, "kg")$]
        Assign[$k$][$"constraint"(phi)$]

        IfElseChain([$r_("bag") != emptyset and C and k$], {
          Return[$r_("bag")$]
        })
      })
      Return[$#sym.emptyset$]
    })
  ),
  caption: [$"sols"_{"SGSC"}(phi, "S")$ determines whether a query plan $phi$ can be answered by any member of the federation.],
  kind: "listing",
  supplement: [Algorithm],
) <alg-sols-SGSC>

// time complexity here too
==== Soundness
#abbr.a("SASS") preserves the soundness guarantee of FedUP
@aimonierdavat:hal-04538238: if $"sols"_"SGSC"(phi, S) = emptyset$, then no member of the
federation can produce a non-empty result for $phi$.
This follows from the #abbr.a("SGSC") definition: by construction, every endpoint's data
conforms to at least one branch $"kg" arrow.r C$ in $S$.
If every branch fails the condition $r_"bag" != emptyset and C and k$, then no conforming
endpoint can satisfy both the structural requirements of $phi$ and its filter constraints,
and the federation engine may safely prune this plan.

// there is more to say here
