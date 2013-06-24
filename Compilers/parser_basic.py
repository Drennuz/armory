'''
Testing parser: simple arithmatic parser 
'''

from lex import *

class ParseError(Exception):pass

class Parser:
    def __init__(self, lexer):
        self.lexer = lexer
        self.lookahead = self.lexer.token()
        self.value_stack = []

    def match(self, name):
        if self.lookahead.name == name:
            self.lookahead = self.lexer.token()
            while self.lookahead.name == 'WHITESPACE':
                self.lookahead = self.lexer.token()
                if self.lookahead is None:
                    break
        else:
            print(name, self.lookahead)
            raise ParseError 
    
    def prog(self):
        while not self.lexer.eof:
            print(self.expr())
        
    def expr(self):
        self.term()
        while True:
            if self.lookahead.name == 'PLUS':
                self.match('PLUS')
                self.term()
                op2 = self.value_stack.pop()
                op1 = self.value_stack.pop()
                self.value_stack.append(op1 + op2)
            elif self.lookahead.name == 'MINUS':
                self.match('MINUS')
                self.term()
                op2 = self.value_stack.pop()
                op1 = self.value_stack.pop()
                self.value_stack.append(op1 - op2)
            elif self.lookahead.name == 'STRING':
                self.value_stack.append(self.lookahead.value)
                self.match('STRING')
            else:
                break
        self.match('EOL')
        return self.value_stack.pop()

    def term(self):
        self.factor()
        while True:
            if self.lookahead.name == 'TIMES':
                self.match('TIMES')
                self.factor()
                op2 = self.value_stack.pop()
                op1 = self.value_stack.pop()
                self.value_stack.append(op1 * op2)
            elif self.lookahead.name == 'DIVIDES':
                self.match('DIVIDES')
                self.factor()
                op2 = self.value_stack.pop()
                op1 = self.value_stack.pop()
                self.value_stack.append(op1 / op2)
            else:
                break
            
    def factor(self):
        if self.lookahead.name == 'NUMBER':
            self.value_stack.append(self.lookahead.value)
            self.match('NUMBER')
        elif self.lookahead.name == 'PRINT':
            self.match('PRINT')
        else:
            print(self.lookahead)
            raise ParseError
