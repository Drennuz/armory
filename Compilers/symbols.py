Keywords = '''
if
else
print
return
'''
Keywords = Keywords.split()

Types = '''
double
string
'''
Types = Types.split()

OneCharSymbols = '''
=
( )
/ * + -
;
,
'''
OneCharSymbols = OneCharSymbols.split()

TwoCharSymbols = '''
==
<=
>=
!=
++
+=
-=
||
'''
TwoCharSymbols = TwoCharSymbols.split()

import string

IDENTIFIER_STARTCHAR = string.ascii_letters
IDENTIFIER_CHARS = string.ascii_letters + string.digits + '_'

NUMBER_STARTCHARS = string.digits
NUMBER_CHARS = string.digits + '.'

STRING_STARTCHARS = "'" + '"'
WHITESPACE_CHARS = ' \t\n'

SYMBOL = "Symbol"
STRING = "String"
IDENTIFIER = "Identifier"
NUMBER = "Number"
WHITESPACE = "Whitespace"
COMMENT = "Comment"
EOF = "Eof"
TYPE = "Type"
KEYWORD = "Keyword"
