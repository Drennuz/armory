# main driver program
# 17-Jun-2013

from classes import Scanner, Lexer
from symbols import *

SOURCE = 'source'

def test_scanner():
    print("line\tcol\tcharacter")
    f = open(SOURCE, 'r')
    source_text = f.read()
    scanner = Scanner(source_text)
    while True:
        ch = scanner.get()
        print(ch)
        if ch.EOF:
            break
    f.close()

def test_lexer():
    print("Line\tCol\t" + '{:.<12}'.format('Token') + "\tText")
    f = open(SOURCE, 'r')
    source_text = f.read()
    lexer = Lexer(source_text)
    while True:
        token = lexer.get()
        if (token.token_type != COMMENT) and (token.token_type != WHITESPACE):
            print(token)
        if token.token_type == EOF:
            break
    f.close()

if __name__ == '__main__':
    test_lexer()

