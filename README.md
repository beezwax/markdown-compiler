# Simple Markdown Parser
The following is a minimalistic Ruby implementation of a markdown compiler, it
translates markdown to HTML.

The main purpose of this library is to explain basic compiler design techniques
so it's not made to be fast, but easy to read and understand.

## Run Tests
To run tests just run `rake`.

## Parsed Markdown Subset Grammar
Pseudo-definition of the grammar parsed:

    Paragraph      := Sentence+ NEWLINE{2,} | Sentence+ EOF
    Sentence       := EmphasizedText | BoldText | Text
    EmphasizedText := UNDERSCORE BoldText UNDERSCORE
    BoldText       := UNDERSCORE UNDERSCORE TEXT UNDERSCORE UNDERSCORE
                    | TIMES TIMES TEXT TIMES TIMES

This matches a subset of Markdown. All-caps terms are tokens, they are the
lowest-level match, basically terminals.
