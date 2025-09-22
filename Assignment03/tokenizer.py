import re

KEYWORDS = {"ls", "cd", "cat", "print", "exec"}
TOKEN_REGEX = {
    "KEYWORD": r"\b(?:ls|cd|cat|print|exec)\b",
    "FILENAME": r"\b[a-zA-Z]{1,8}\.[a-zA-Z]{1,3}\b",
    "FOLDERNAME": r"\b[a-zA-Z]{1,8}\b",
    "SEPARATOR": r"\\",
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