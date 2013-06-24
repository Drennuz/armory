Elementary lex/yacc implementation in Python

Lex
-----
### Instructions:

* Download `lex.py`

* Import lex:

```python
from lex import *
```

* Specify rules

Rules are a list of `(pattern, name, function)` tuples. 

`pattern` is the regex expression that'll be passed into `re.compile(pattern)`. `pattern` can also be a list of patterns for the same token name.

`name` is the name of the token

`function` is a function taking 1 argument. Actual token value will be `function(matchedString)`

This is a sample rules list:

```python
rules = [
    (['if', 'print'], 'KEYWORD'),
    ([r'<', r'=', r';'], 'SYMBOL'),
    ('\w+', 'IDENTIFIER'),
    ('\d+', 'NUMBER', lambda x: float(x)),
]
```


* Initialize lexer

```python
lexer = Lex(rules)
lexer.input(source)
```

`source` is the input text to be lexed, `rules` is the rules list specified in step 2.

The major function to use is `lexer.token()`, which reads `source` and return one token at a time. 

*  `example.py` is an example.

### Limitations
* Lex cannot process nested structures

Parser
------
Parser is dependent on lexer. The main entry point is `parser.prog()` function.

```python
from parser import *
parser = Parser(lexer)
print(parser.prog())
```

Files:

* parser_basic.py implements a parser supporting arithmatic operations and print statements. See example.py

Notes:

* shift-reduce conflicts: shift
* reduce-reduce conflicts: use first rule in the listing
* syntax tree: interior node == operators; parse tree: interior node == nonterminals


### Todo
* Refactor to OOP style [DONE]
* Support substitution patterns
* Support regex ordering: longest match first (currently in the order of patterns)
* Add positional information (line & char number)


