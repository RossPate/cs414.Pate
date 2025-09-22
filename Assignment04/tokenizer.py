import re

KEYWORDS = {"ls", "cd", "cat", "print", "exec"}
TOKEN_REGEX = {
    "KEYWORD": r"\b(?:ls|cd|cat|print|exec|set|echo)\b",
    "VARIABLE": r"\$[a-zA-Z0-9]+",
    "FILENAME": r"[a-zA-Z0-9]{1,8}\.[a-zA-Z0-9]{1,3}",
    "FOLDERNAME": r"[a-zA-Z0-9]{1,8}",
    "SEPARATOR": r"\\",
    "OPERATOR": r"[+\-*/=()]",
    "STRING": r"[a-zA-Z0-9]+",
    "WHITESPACE": r"\s+",
    "UNKNOWN": r"."
}

def tokenize(command):
    tokens = []
    i = 0
    while i < len(command):
        match = None
        for token_type, pattern in TOKEN_REGEX.items():
            regex = re.compile(pattern)
            match = regex.match(command, i)
            if match:
                text = match.group(0)
                if token_type != "WHITESPACE":
                    tokens.append((token_type, text))
                i = match.end()
                break
        if not match:
            raise ValueError(f"Unexpected character at position {i}: {command[i]}")
    return tokens