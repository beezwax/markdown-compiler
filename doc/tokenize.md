# The Tokenizer
A tokenizer is just a black box which takes an input and returns a list of
tokens. In our case, we'll have the following tokens: `UNDERSCORE`; `TIMES`;
`PARENTHESIS_OPEN`; `PARENTHESIS_CLOSE`; `BRACKET_OPEN`; `BRACKET_CLOSE`;
`NEWLINE`; `TEXT` and `EOF`.

So, for example, for the input `_Hello(` it should return `[UNDERSCORE, "Hello",  PARENTHESIS_OPEN]`.
Note that the tokenizer is quite simple, it doesn't care whether the syntax is
valid or not, it just regognizes the bulding blocks.
