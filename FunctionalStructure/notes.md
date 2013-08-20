* lazy: arguments are evaluated in a demand-driven fashion, value is cached once evaluated. 
* strict: worst case running time; lazy: amortized cost

### Chap2 Persistence
* append: O(1) in imperative; O(n)

### Chap3
TODO: binomial heap
    * binomial tree: rank r+1: linking 2 rank r trees, one as sub left tree; 2**r nodes
    * binomial heap: list of binomial tree in increasing rank
    * analagous to binary number; size n --> log(n+1) trees

RB tree
* empty nodes are considered black
* no two consecutive red; every path to empty contains equal #black
* maximum depth: 2log(n+1)
* balance: rewrite black-red-red as red-black-black

### Chap4 Lazy
* evaluated only when needed; then cached.
* stream vs lazy list: forcing is incremental vs complete
* drop & reverse: complete / monolithic

### Chap5 Amortization
* physicist method: potential = length of rear list


