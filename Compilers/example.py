
from lex import *
from parser_basic import *
import sys

def main():

    if len(sys.argv) < 2:
        print("Usage: python3 example.py [text]", file = sys.stderr)
        sys.exit(1)
    
    token_rules = [
        (r'\+', 'PLUS'),
        (r'-', 'MINUS'),
        (r'\*', 'TIMES'),
        (r'/', 'DIVIDES'),
        (r'".*"', 'STRING'),
        ('print', 'PRINT'),
        (';', 'EOL'),
        ('\s+', 'WHITESPACE'),
        ('\d+', 'NUMBER', lambda x: float(x)),
    ]
    
    with open(sys.argv[1], 'r') as f:
        source = f.read()
    
    lexer = Lex(token_rules)
    lexer.input(source)
    
    parser = Parser(lexer)
    parser.prog()

if __name__ == '__main__':
    main()
