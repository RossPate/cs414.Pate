from ast import ASTNode
class Parser:    
    def __init__(self, tokens):
        self.symbol_table = {}
        self.tokens = tokens
        self.pos = 0

    def current(self):
        return self.tokens[self.pos] if self.pos < len(self.tokens) else ("EOF", "")

    def match(self, expected_type, expected_value=None):
        token_type, token_value = self.current()
        if token_type == expected_type and (expected_value is None or token_value == expected_value):
            self.pos += 1
            return token_value
        return None

    def expect(self, expected_type, expected_value=None):
        result = self.match(expected_type, expected_value)
        if result is None:
            raise SyntaxError(f"Expected {expected_type} {expected_value}, got {self.current()}")
        return result

    def parse(self):
        return self.parse_command()

    def parse_command(self):
        token_type, token_value = self.current()
        if token_type == "KEYWORD":
            if token_value == "ls":
                return self.parse_ls()
            elif token_value == "cd":
                return self.parse_cd()
            elif token_value == "cat":
                return self.parse_cat()
            elif token_value == "print":
                return self.parse_print()
            elif token_value == "exec":
                return self.parse_exec()
            elif token_value == "set":
                return self.parse_set()
            elif token_value == "echo":
                return self.parse_echo()
        raise SyntaxError(f"Unknown command: {token_value}")

    def parse_ls(self):
        self.expect("KEYWORD", "ls")
        folder = self.parse_folder_path(optional=True)
        return ASTNode("LS", children=[folder] if folder else [])

    def parse_cd(self):
        self.expect("KEYWORD", "cd")
        folder = self.parse_folder_path(optional=True)
        return ASTNode("CD", children=[folder] if folder else [])

    def parse_cat(self):
        self.expect("KEYWORD", "cat")
        filename = self.expect("FILENAME")
        return ASTNode("CAT", value=filename)

    def parse_print(self):
        self.expect("KEYWORD", "print")
        filename = self.expect("FILENAME")
        return ASTNode("PRINT", value=filename)

    def parse_exec(self):
        self.expect("KEYWORD", "exec")
        filename = self.expect("FILENAME")
        return ASTNode("EXEC", value=filename)

    def parse_set(self):
        self.expect("KEYWORD", "set")
        var_name = self.expect("VARIABLE")
        self.expect("OPERATOR", "=")
        expr = self.parse_expr()
        self.symbol_table[var_name] = "<expr>"  # placeholder for now
        return ASTNode("SET", value=var_name, children=[expr])

    def parse_echo(self):
        self.expect("KEYWORD", "echo")
        var_name = self.expect("VARIABLE")
        return ASTNode("ECHO", value=var_name)

    def parse_expr(self):
        node = self.parse_term()
        while self.match("OPERATOR", "+") or self.match("OPERATOR", "-"):
            op = self.tokens[self.pos - 1][1]
            right = self.parse_term()
            node = ASTNode("EXPR", value=op, children=[node, right])
        return node

    def parse_term(self):
        node = self.parse_factor()
        while self.match("OPERATOR", "*") or self.match("OPERATOR", "/"):
            op = self.tokens[self.pos - 1][1]
            right = self.parse_factor()
            node = ASTNode("TERM", value=op, children=[node, right])
        return node

    def parse_factor(self):
        if self.match("VARIABLE"):
            return ASTNode("VAR", value=self.tokens[self.pos - 1][1])
        elif self.match("STRING"):
            return ASTNode("STR", value=self.tokens[self.pos - 1][1])
        elif self.match("OPERATOR", "("):
            expr = self.parse_expr()
            self.expect("OPERATOR", ")")
            return expr
        else:
            raise SyntaxError(f"Unexpected token in factor: {self.current()}")

    def parse_folder_path(self, optional=False):
        parts = []
        while True:
            folder = self.match("FOLDERNAME")
            if folder:
                parts.append(folder)
                if not self.match("SEPARATOR"):
                    break
            else:
                break
        if not parts and not optional:
            raise SyntaxError("Expected folder path")
        return ASTNode("FOLDER_PATH", children=[ASTNode("FOLDER", value=p) for p in parts]) if parts else None