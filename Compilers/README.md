Parser/Compiler exercise in Python
=====

Notes
-----
* Lexer: symbol table. `<ident, ID>`, `ID` refers to ID in symbol table; operators like `'+'` not stored (`token = '+'`) 
* `lex`: cannot handle nested structures --> `yacc`
* Terminals: <i>tokens</i>; (symbols like operators are tokens of their own)
* Parse tree:
    * Root == <i> start </i>
    * Leaf == <i> terminal </i>
    * Interior node == <i> nonterminal</i>
    * Interial node --> Children == Production rule
* Syntax directed translation: action with each grammar rule

Files
-----

* `source`: test language
* `symbols.py`: token definition
* `classes.py`: Classes (Char, Scanner, Token, Lexer, Node, Parser)


