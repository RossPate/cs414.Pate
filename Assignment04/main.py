from tokenizer import tokenize
from parser import Parser

commands = [
    "set $x = 3 + 4",
    "echo $x",
    "cat $x",
    "exec GAME.EXE",
    "set $name = 7 * (2 + $x)"
]

for cmd in commands:
    try:
        tokens = tokenize(cmd)
        parser = Parser(tokens)
        ast = parser.parse()
        print(f"Command: {cmd}")
        print("AST:", ast)
        print("Symbol Table:", parser.symbol_table)
    except SyntaxError as e:
        print(f"Command: {cmd}")
        print("Error:", e)
    print()