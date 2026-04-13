#import "@preview/abbr:0.2.3"

= Foundation

This section introduces the query-plan notation used in the remainder of the paper.

== FedQPL

FedQPL @cheng2020fedqpl is a formal query plan language for federated querying.
We model a federation as a finite set of federation members $F$; each member $f in F$ provides access (via an interface) to an RDF #abbr.a[KG].

In this paper, we use the following subset of FedQPL operators:

$ phi ::= "req"_("tp")^f | "mu"(Phi) | "mj"(Phi) | "filter"_R(phi) | "leftjoin"(phi_1, phi_2) $

Here, $"tp"$ is a triple pattern, $Phi$ is a finite set of FedQPL expressions, $f$ is a federation member, and $R$ is a SPARQL filter condition.
Intuitively, $"req"_("tp")^f$ requests answers to $"tp"$ from $f$.
The operators $"mu"(Phi)$ and $"mj"(Phi)$ denote the union and (multi-)join of the subplans in $Phi$, respectively.
The operator $"filter"_R(phi)$ filters the solutions of $phi$ by $R$, and $"leftjoin"(phi_1, phi_2)$ denotes the standard left outer join.

Following FedUP @aimonierdavat:hal-04538238, we write $"sols"(phi)$ for the bag of solution mappings obtained by evaluating a plan $phi$ over an endpoint summary.
