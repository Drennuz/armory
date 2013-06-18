from symbols import *

class Char:
    def __init__(self, text, line_num, col_num, file_pos, EOF = False):
        self.text = text
        self.line_num = line_num
        self.col_num = col_num
        self.file_pos = file_pos
        self.EOF = EOF

    def __str__(self): # override print method
        text = self.text
        if text == ' ': text = '    space'
        elif text == '\n': text = '    newline'
        elif self.EOF: text = '    eof'
        elif text == '\t': text = '    tab'

        return str(self.line_num) + '\t' + str(self.col_num) + '\t' + repr(text)

class Scanner:
    def __init__(self, source_text):
        self.source = source_text
        self.line_counter = 0
        self.col_counter = 0
        self.current_pos = 0
        # for stepback function
        self.pre_line_counter = 0
        self.pre_col_counter = 0
        self.pre_current_pos = 0

    def stepback(self):
        self.current_pos = self.pre_current_pos
        self.line_counter = self.pre_line_counter
        self.col_counter = self.pre_col_counter

    def get(self): # get next char
        self.pre_line_counter = self.line_counter
        self.pre_col_counter = self.col_counter
        self.pre_current_pos = self.current_pos

        if self.current_pos == len(self.source): # reached EOF
            text = ''
            ch = Char(text, self.line_counter, self.col_counter, self.current_pos, True)
        else:
            text = self.source[self.current_pos]
            ch = Char(text, self.line_counter, self.col_counter, self.current_pos, False)
        self.col_counter += 1
        if text == '\n':
            self.line_counter += 1
            self.col_counter = 0
        self.current_pos += 1
        return ch
        
class Token:
    def __init__(self, token_type, text, line_num = 0, col_num = 0):
        self.token_type = token_type
        self.text = text
        self.line_num = line_num
        self.col_num = col_num

    def __str__(self):
        return str(self.line_num) + '\t' + str(self.col_num) + '\t' + '{:.<12}'.format(self.token_type) + '\t' + repr(self.text)

class LexerError(Exception): pass

class Lexer:
    def __init__(self, source_text):
        self.scanner = Scanner(source_text)

    def get(self):
        text = ''
        c1 = self.scanner.get()
        line_num = c1.line_num
        col_num = c1.col_num

        def get_continuous(c1, text, chars): # handle identifier/whitespace/numerals
            while (not c1.EOF) and (c1.text in chars):
                text += c1.text
                c1 = self.scanner.get()
            self.scanner.stepback()
            return text

        if not c1.EOF:
            c2 = self.scanner.get()
            # deal with 2-char cases first
            if c1.text + c2.text == '/*': # start comment
                text += c1.text
                while c1.text + c2.text != '*/':
                    c1 = c2
                    c2 = self.scanner.get()
                    text += c1.text
                text += c2.text
                return Token(COMMENT, text, line_num, col_num) 
            elif (c1.text + c2.text) in TwoCharSymbols:
                text += c1.text + c2.text
                return Token(SYMBOL, text, line_num, col_num)

            # 1-char case; stepback first
            else:
                self.scanner.stepback()
                if c1.text in OneCharSymbols:
                    text += c1.text
                    return Token(SYMBOL, text, line_num, col_num)
                elif c1.text in WHITESPACE_CHARS:
                    return Token(WHITESPACE, get_continuous(c1, text,WHITESPACE_CHARS), line_num, col_num)
                elif c1.text in NUMBER_STARTCHARS: # numbers
                    return Token(NUMBER, get_continuous(c1, text,NUMBER_CHARS), line_num, col_num)
                elif c1.text in STRING_STARTCHARS: # string
                    start_quote = c1.text
                    text += c1.text
                    c1 = self.scanner.get()
                    while c1.text != start_quote:
                        text += c1.text
                        c1 = self.scanner.get()
                    text += c1.text
                    return Token(STRING, text, line_num, col_num)
                elif c1.text in IDENTIFIER_STARTCHAR: # Identifier/Keywords/Types
                    text = get_continuous(c1, text, IDENTIFIER_CHARS)
                    if text in Keywords:
                        return Token(KEYWORD, text, line_num, col_num)
                    elif text in Types:
                        return Token(TYPE, text, line_num, col_num)
                    else:
                        return Token(IDENTIFIER, text, line_num, col_num)

        else: # return EOF
            return Token(EOF, c1.text, line_num, col_num)
                
class Node:
    def __init__(self, token = None):
        self.level = 0
        self.token = token
        self.children = []
    
    def addNode(self, node):
        node.level += self.level + 1 # root.level == 0
        self.children.append(node)

    def __str__(self):
        s = '      ' * self.level
        if self.token is None: # root
            s += 'ROOT\n'
        else:
            s += self.token.text + '\n'
        for child in self.children:
            s += str(child)
        return s

class ParserError(Exception): pass

class Parser:
    def __init__(self, source):
        self.lexer = Lexer(source)
        self.token = None # point to token to be processed
        self.ast = None # ast is the root node
   
    def consume(self, token):
        if self.found(token):
            self.getToken()
        else:
            raise ParserError("expect " + str(token) + " found:" + str(self.token))

    def found(self, token):
        return self.token.token_type == token.token_type and self.token.text == token.text
    
    def getToken(self):
        self.token = self.lexer.get()
        while self.token.token_type == WHITESPACE or self.token.token_type == COMMENT:
            self.token = self.lexer.get()

    def parse(self):
        self.program()            
        return self.ast

    def program(self):
        node = Node()
        self.getToken()
        while self.token.token_type != EOF:
            self.statement(node)
        self.ast = node
    
    def statement(self, node):
        identNode = Node(self.token)
        self.consume(self.token)
        operatorNode = Node(self.token)
        self.consume(Token(SYMBOL, '='))
        node.addNode(operatorNode)
        operatorNode.addNode(identNode)
        self.expression(operatorNode)
        self.consume(Token(SYMBOL, ';'))
    
    def expression(self, node):
        self.term(node)
        if self.token.token_type == SYMBOL and self.token.text == '/':
            node.addNode(Node(self.token))
            self.getToken()
            self.term(node)

    def term(self, node):
        '''
        IDENTIFIER | NUMBER
        '''
        if self.token.token_type == NUMBER:
            self.numLiterals(node)
        elif self.token.token_type == IDENTIFIER:
            self.identLiterals(node)
        else:
            raise ParserError(str(self.token))
    
    def numLiterals(self, node):
        node.addNode(Node(self.token))
        self.getToken() 

    def identLiterals(self, node):
        node.addNode(Node(self.token))
        self.getToken()
