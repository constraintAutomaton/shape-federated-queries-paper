#import "@preview/abbr:0.2.3"

= Approach
 

== FedQPL for Dynamic Federations

=== Operator Extension

We propose to extend the definition of a federation member to $upright("fm") := (G, I, S)$, where $S$ represents the subweb that the federation member is part of. The subweb $S$ is defined by the tuple $(D, R)$, where $D$ is the set of IRIs that the subweb encompasses and $R$ contains summary information about the subweb.

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

Exclusive groups are triple patterns that appear can be exclusive answer by a federation member.
By determining those groups the query plan can be optimized by removing those triple patterns from the unions of the plan to be replace by a single $upright("req")^(T_i)_(f_i)$ given that the exclusive group target the federation member $f_i$ with the set of triple patterns $T_i$.

=== Federation Member Acquisition mechanism

== FedQPL formalization of LTQP
