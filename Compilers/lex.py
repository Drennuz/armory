import re

class Token:
    def __init__(self, name, value = None, f = lambda val: val):
        self.name = name
        self.value = f(value)

    def __str__(self):
        if self:
            return 'Token: name = ' + self.name + ' value = ' + repr(self.value)

class Lex:
    def __init__(self, rules):
        self.rules = rules
        
        self.patterns = []
        self.token_names = []
        self.f = []
        self.eof = False
       
        for rule in self.rules: # supporting a list of patterns for same token type
            regexs = rule[0]
            if not isinstance(regexs, list):
                regexs= [regexs]
            
            for regex in regexs:
                self.patterns.append(re.compile(regex))
                self.token_names.append(rule[1])
                if len(rule) > 2:
                    self.f.append(rule[2])
                else:
                    self.f.append(lambda val: val)

    def input(self, source):
        self.text = source
    
    def token(self):

        matches = [pattern.search(self.text) for pattern in self.patterns]
        starts = [m.start() if m is not None else len(self.text) for m in matches]
        ends = [m.end() if m is not None else 0 for m in matches]

        min_starts = min(starts)
        index = starts.index(min_starts)

        if min_starts == len(self.text):
            self.eof = True
            return None

        else:
            self.text = self.text[ends[index]:]
            return Token(self.token_names[index], matches[index].group(), self.f[index])
            
