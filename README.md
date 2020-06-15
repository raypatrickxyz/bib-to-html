# bib-to-html
Accepts a BibTeX .bib file on standard input and emits a valid HTML page with a list of books sorted by category on standard output.

# usage
From the command line, you can use `cat example.bib | ./bib-to-html.sh >example.html` or
`./bib-to-html.sh <example.bib >example.html`.

# Notes
This script relies on your adding two non-standard tags to your BibTeX file. Here is a sample entry:
```
@book{example,`
  title = "Example Book",
  author = "Example Author",
  publisher = "Example Publisher",
  year = "Example year",
  description = "This is the description. It can contain any printable character but must be on one line.",
  category = "Example Category"
}
```
The 'description' tag may be empty but it must be present. Currently the category tag must be present and non-empty.
Tags may appear in any order.
