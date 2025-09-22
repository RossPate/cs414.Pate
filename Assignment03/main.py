from tokenizer import tokenize
from parser import Parser

if __name__ == "__main__":
    from tokenizer import tokenize

    commands = [
        "ls",
        "cd folder1\\subdir",
        "cat README.TXT",
        "print DOC1.PRN",
        "exec GAME.EXE",
        "cd",
        "ls folder1\\bad\\path"
    ]

    for cmd in commands:
        try:
            tokens = tokenize(cmd)
            parser = Parser(tokens)
            ast = parser.parse()
            print(f"Command: {cmd}")
            print("AST:", ast)
        except SyntaxError as e:
            print(f"Command: {cmd}")
            print("Error:", e)
        print()