#import "@preview/algorithmic:1.0.5"
#import algorithmic: style-algorithm, algorithm-figure
#show: style-algorithm


- Union over join planning
  - we are more expressive because of unions in shapes
- Join ordering
- Query Rewriting using Shapes
  - with optional it might be implicitly done
  - Distinct statement is not something they talked about
- Bring shapes to normal forms
  - non-deterministic planning
- Handling of filter expressions
  - Filter to prolog
- Some information are properties of the federation
- Better filter pushdown
- Compare source selection alone
  - Does FedX source selection redundant??
- Addind lusail pruning into it

= Union over join planning

We define a federation member to $upright("fm") := (G, I, S)$, where $S$ is the set of ShEx shapes tied to the federation.
We assume that every node in $G$ is cover by the validation procedure of the set of $S$ and we assume no overlaps between shapes.

We can use query-shape containement and alignment for the detection of exclusive group and query relevant federation members.
We need to tied the $upright("tp") in Q_{upright("starT")}$ with the alignment/containment.

Algorithm to know if two shapes can be join given shape $s_1$ and shape $s_2$.

We define $pi$ the set of every shape, $Pi$ the set of every node kind (`IRI`, `Literal`, `BNode`, `NonLiteral`), $Gamma$ the set of native types ${"xsd:float", "xsd:string", ...}$ and $gamma$ the types with literal facet.

We first find all the joinable types.

$upright("Jt") = {t| (a, t) in Sigma times Gamma and t in Pi}$


#algorithm-figure(
  "Shape join",
  vstroke: .5pt + luma(200),
  {
    import algorithmic: *
    Function(
      "Shape join",
      ($s_1$, $s_2$),
      {
        Assign[$upright("commonProp")$][$emptyset$]
        For($(a_1,t_1) in Sigma_1 times Gamma_1$,{
          If($t_1 in pi$,{
            If($upright("iri")(t_1) eq upright("iri")(s_2)$,{
              Return[$Sigma_2 times Gamma_2$]
            }) 
            Comment[The shape share a property with the type $t_1$]
            
            For($(a_2, t_2) in Sigma_2 times Gamma_2$,{
              For($(a_(t_1),t_(t_1)) in Sigma_(t_1) times Gamma_(t_1)$,{
                If($a_(t_1) eq a_2$, {
                  Assign[$upright("commonProp")$][$upright("commonProp") union (a_2,t_2)$]
                })
              })

            })
          })
        }) 
        
        Return[$upright("commonProp")$]
      },
    )
  }
)





