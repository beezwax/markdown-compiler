# Simple Markdown Parser
The following is a minimalistic Ruby implementation of a markdown compiler, it
translates markdown to HTML.

The main purpose of this library is to explain basic compiler design techniques
so it's not made to be fast, but easy to read and understand.

For more information about the project, or if you are interested in learning how
to write compilers from scratch, see the `doc` directory.

## Run Tests
To run tests just run `rake`.

## Parsed Markdown Subset Grammar
Pseudo-definition of the grammar parsed:

    Paragraph          := SentenceAndNewline
                        | SentenceAndEOF

    SentenceAndNewline := Sentence+ NEWLINE NEWLINE

    SentencesAndEOF    := Sentence+ NEWLINE EOF
                        | Sentence+ EOF

    Sentence           := EmphasizedText
                        | BoldText
                        | Text

    EmphasizedText     := UNDERSCORE BoldText UNDERSCORE

    BoldText           := UNDERSCORE UNDERSCORE TEXT UNDERSCORE UNDERSCORE
                        | STAR STAR TEXT STAR STAR

    Text               := TEXT

This matches a subset of Markdown. All-caps terms are tokens, they are the
lowest-level match, basically terminals.
