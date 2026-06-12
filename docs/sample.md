# Markdown Spec Sample — Full Coverage

This file exercises every element defined in CommonMark 0.31 and the GFM extension spec.
It is intentionally a stress test: odd nesting, edge cases, and boundary conditions throughout.

---

## 1. Thematic Breaks

Three ways to write them:

---

***

___

Thematic breaks with extra spaces and trailing spaces:

-  -  -

*   *   *

_    _    _

---

## 2. ATX Headings

# H1
## H2
### H3
#### H4
##### H5
###### H6

Closing hashes are optional and must be stripped:

# H1 with closing hash #
## H2 with closing hash ##
### H3 with closing hash ###

Inline styles inside headings:

# Heading with **bold** and *italic* and `code`
## Heading with a [link](https://example.com)
### Heading with ~~strikethrough~~

---

## 3. Setext Headings

Setext H1
=========

Setext H2
---------

Setext with inline styles
**bold** and *italic*
======================

---

## 4. Indented Code Blocks

Normal paragraph, then four-space-indented code:

    first indented line
    second indented line
      extra-indented line
    back to base indent

---

## 5. Fenced Code Blocks

Backtick fence, no language:

```
no language tag
```

Backtick fence with language:

```swift
func hello() -> String { "hello" }
```

Tilde fence (alternate delimiter):

~~~python
def hello():
    return "hello"
~~~

Tilde fence with language:

~~~json
{
  "key": "value",
  "number": 42,
  "flag": true,
  "nothing": null
}
~~~

Fence with backticks inside the block:

````
code that contains ``` triple backticks inside
````

Empty code block:

```
```

Code block with only whitespace lines:

```
   
   
```

Long single line (width stress):

```
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
```

---

## 6. HTML Blocks

Block-level raw HTML (type 6 — open tag on its own line):

<div>
  <p>Raw HTML block content</p>
</div>

HTML comment block:

<!-- This is an HTML comment block.
     It spans multiple lines. -->

Processing instruction:

<?xml version="1.0" encoding="UTF-8"?>

CDATA section:

<![CDATA[raw <markup> & "entities" here]]>

---

## 7. Link Reference Definitions

These are block-level definitions; they produce no output themselves.

[ref]: https://example.com "Reference title"
[ref2]: https://example.com/page
  "Title on next line"
[ref3]: https://example.com/long-url
  (Title in parens)

---

## 8. Paragraphs

Single paragraph.

Two paragraphs separated by a blank line.

Paragraph with a hard line break via two trailing spaces:  
Second line of same paragraph.

Paragraph with a hard line break via backslash:\
Second line via backslash break.

Paragraph with soft breaks — single newlines within the source
become either a space or a newline depending on renderer:
line two of soft-break paragraph.
line three of soft-break paragraph.

Paragraph with character references: &amp; &lt; &gt; &quot; &apos; &#42; &#x2A;

Paragraph with backslash escapes: \* \_ \` \[ \] \( \) \# \+ \- \. \! \\ \{ \} \|

---

## 9. Block Quotes

Minimal:

> Single line blockquote.

Multi-line with explicit `>` on each line:

> Line one.
> Line two.
> Line three.

Multi-paragraph (blank line with `>` between):

> First paragraph in blockquote. Runs long enough to confirm the pipe prefix is stable.
>
> Second paragraph in same blockquote.

Lazy continuation (no `>` on continuation lines):

> First line has marker.
Continuation line has no marker — still part of the quote.
> Back to explicit marker.

Nested blockquotes:

> Outer blockquote.
>
> > Inner blockquote nested one level deep.
> >
> > > Doubly nested blockquote.

Blockquote containing a heading:

> ## Heading Inside Blockquote
>
> Paragraph after heading inside blockquote.

Blockquote containing a list:

> - item one
> - item two
> - item three

Blockquote containing a code block:

> ```
> code inside blockquote
> ```

Blockquote containing a table:

> | A | B |
> |---|---|
> | 1 | 2 |

Blockquote with inline styles:

> **Bold**, *italic*, `code`, ~~strikethrough~~, and [a link](https://example.com).

---

## 10. Lists

### 10a. Bullet Lists (tight)

Hyphen marker:

- alpha
- beta
- gamma

Asterisk marker:

* one
* two
* three

Plus marker:

+ foo
+ bar
+ baz

### 10b. Bullet List (loose — blank lines between items)

- First item.

- Second item.

- Third item.

### 10c. Ordered Lists

Period delimiter starting at 1:

1. First
2. Second
3. Third

Period delimiter starting at 42 (start number matters):

42. Forty-two
43. Forty-three
44. Forty-four

Paren delimiter:

1) Item one
2) Item two
3) Item three

### 10d. Nested Lists

- Level 1 item A
  - Level 2 item A1
  - Level 2 item A2
    - Level 3 item A2a
    - Level 3 item A2b
  - Level 2 item A3
- Level 1 item B
  1. Ordered nested under unordered
  2. Second ordered item
- Level 1 item C

### 10e. Lists with Inline Styles

- Plain item
- **Entire item is bold**
- *Entire item is italic*
- `Entire item is inline code`
- ~~Entire item is strikethrough~~
- Item with **bold in the middle** of plain text
- Item with *italic* and **bold** and `code` together
- Item starting **bold** and ending plain
- Item starting plain and ending **bold**

### 10f. Lists with Block Content (loose items)

- Item one with a paragraph.

  Second paragraph inside item one, indented by two spaces.

- Item two with a code block.

  ```
  code inside a list item
  ```

- Item three with a nested blockquote.

  > Quote inside a list item.

### 10g. Task Lists (GFM)

- [ ] Unchecked task
- [x] Checked task
- [X] Also checked (uppercase X)
- [ ] Unchecked with **bold** description
- [x] ~~Checked and struck through~~

---

## 11. Tables (GFM)

### Minimal

| A | B |
|---|---|
| 1 | 2 |

### Column Alignment

| Left | Center | Right | Default |
|:-----|:------:|------:|---------|
| L    |   C    |     R | D       |
| foo  |  bar   |   baz | qux     |

### Inline Styles in Cells

| Style     | Example                    |
|-----------|----------------------------|
| Bold      | **bold cell**              |
| Italic    | *italic cell*              |
| Code      | `code cell`                |
| Strike    | ~~struck cell~~            |
| Link      | [link](https://example.com)|
| Mixed     | **bold** and *italic*      |

### Wide Table (truncation stress)

| Column One Very Long | Column Two Very Long | Column Three Very Long | Column Four Very Long | Column Five Very Long |
|----------------------|----------------------|------------------------|-----------------------|-----------------------|
| data data data data  | data data data data  | data data data data    | data data data data   | data data data data   |
| more data more data  | more data more data  | more data more data    | more data more data   | more data more data   |

### Single Column

| Only Column |
|-------------|
| row one     |
| row two     |

### Header Only (no body rows)

| H1 | H2 | H3 |
|----|----|----|

---

## 12. Inline Elements

### 12a. Code Spans

Minimal: `code`

With spaces inside: ` code with leading and trailing spaces `

With backtick inside using double-backtick delimiter: ``back`tick``

With HTML chars: `<div class="foo">` and `a && b` and `x > y`

Code span inside a longer sentence: the function `computeColumnWidths(_:)` returns an array.

Adjacent code spans: `first``second` — double backtick between, no delimiter confusion.

### 12b. Emphasis (italic)

*single asterisk*

_single underscore_

*emphasis spanning
a soft line break*

Intra-word: foo*bar*baz — CommonMark rules: this may or may not be emphasis depending on flanking.

Mid-sentence: a word *emphasized phrase* and back to normal.

Opening: *italic opens sentence* then plain.

Closing: plain then *italic closes sentence*.

### 12c. Strong Emphasis (bold)

**double asterisk**

__double underscore__

**bold spanning
a soft line break**

Mid-sentence: a word **bold phrase** and back to normal.

Opening: **bold opens sentence** then plain.

Closing: plain then **bold closes sentence**.

### 12d. Nested Emphasis

***triple — bold and italic together***

___triple underscores — bold and italic together___

**bold with *italic inside* it**

*italic with **bold inside** it*

*italic **bold** italic* around bold.

**bold *italic* bold** around italic.

*a **b *c* b** a* — deep nesting.

### 12e. Strikethrough (GFM)

~~struck through~~

~~strikethrough spanning
a soft line break~~

Plain text before ~~struck middle~~ and plain after.

**~~bold and struck~~**

*~~italic and struck~~*

~~**struck and bold**~~

### 12f. Links

Inline link: [link text](https://example.com)

With title: [link text](https://example.com "Link title")

Empty link text: [](https://example.com)

Link with inline styles in text: [**bold link**](https://example.com)

Link with inline styles in text: [*italic link*](https://example.com)

Link with inline styles in text: [`code link`](https://example.com)

Relative link: [relative](./other-file.md)

Fragment link: [fragment](#section-id)

Reference link (full): [reference][ref]

Reference link (collapsed): [ref][]

Reference link (shortcut): [ref]

### 12g. Images

Inline image: ![alt text](https://example.com/image.png)

With title: ![alt text](https://example.com/image.png "Image title")

Empty alt: ![](https://example.com/image.png)

Reference image: ![alt][ref]

Image inside a link: [![alt](https://example.com/img.png)](https://example.com)

### 12h. Autolinks

Angle-bracket autolinks: <https://example.com>

Email autolink: <user@example.com>

GFM bare autolink: https://example.com

GFM bare autolink in prose: visit https://example.com for details.

### 12i. Raw Inline HTML

Span with attribute: <span class="highlight">highlighted</span>

Inline element: <kbd>Ctrl</kbd>+<kbd>C</kbd>

Self-closing: <br/>

### 12j. Hard Line Breaks

Via two trailing spaces:  
next line (two spaces above).

Via backslash:\
next line (backslash above).

### 12k. Character References

Named: &amp; &lt; &gt; &quot; &apos; &copy; &mdash; &ndash; &hellip; &nbsp;

Decimal numeric: &#65; &#66; &#67; (A B C)

Hexadecimal numeric: &#x41; &#x42; &#x43; (A B C)

### 12l. Backslash Escapes

Escaped punctuation that would otherwise be special:

\* \_ \` \[ \] \( \) \# \+ \- \. \! \\ \{ \} \| \~

Escapes inside code spans have no effect: `\* \_ \``

---

## 13. Edge Cases & Boundary Conditions

### Blank heading (just the marker)

#

### Heading with only whitespace after marker

#   

### Paragraph immediately after heading with no blank line
## Heading
Paragraph with no blank line after the heading — both should appear.

### Two headings with no blank line between
## First Heading
## Second Heading

### Blockquote immediately after paragraph
Paragraph.
> Blockquote immediately after — no blank line between them.

### List immediately after paragraph
Paragraph.
- List immediately after — no blank line between them.

### Code block immediately after paragraph
Paragraph.
```
Code block immediately after — no blank line between them.
```

### Empty blockquote

>

### Blockquote with only a blank line

> 

### List item with no content

-  

### Deeply nested list

- a
  - b
    - c
      - d
        - e
          - f

### Ordered list with non-sequential numbers

1. one
3. three (source is 3, not 2)
5. five (source is 5, not 3)

### Mixed tight/loose list (loose wins)

- item one

- item two
- item three

### Inline code with newline (treated as space)

`first line
second line`

### Emphasis with punctuation boundary

*(italic)*

**[bold link](https://example.com)**

### Multiple inline styles on same word

***bold-italic word***

### Link with parentheses in URL

[link](https://example.com/path(with)parens)

### Link title with double quotes

[link](https://example.com "title with 'single' inside")

### Link title with single quotes

[link](https://example.com 'title with "double" inside')

### Escaped chars in link title

[link](https://example.com "title with \"escaped\" quotes")

### Image with complex alt text

![alt with **bold** and *italic*](https://example.com/img.png)

### Table with pipes in cell content (escaped)

| Column | With Pipe    |
|--------|--------------|
| cell   | value \| bar |

### Table with empty cells

| A  | B  | C  |
|----|----|----|
|    | B2 |    |
| A3 |    | C3 |

### Setext heading with no blank line before next block

Setext Heading
--------------
Paragraph immediately after setext heading.

### Fenced code with info string containing spaces

```ruby highlight
puts "info string with space"
```

### Very long paragraph

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam varius, turpis molestie pretium placerat, arcu turpis blandit nunc, a dictum augue quam sit amet lorem.

### Unicode prose

Café, naïve, résumé, Ångström, façade, über, ñoño.

CJK: 日本語テスト、中文测试、한국어 테스트.

Arabic: مرحبا بالعالم

Greek: Ελληνικά

Emoji: 🎉 🚀 ✅ ❌ 📝 🔥

### All inline elements in one paragraph

Here is a paragraph containing **bold**, *italic*, ***bold-italic***, `code`, ~~strikethrough~~, [a link](https://example.com), ![an image](https://example.com/img.png), an autolink <https://example.com>, a character reference &amp;, a backslash escape \*, and a hard break  
all on (roughly) one paragraph.

---

## 14. Combinations

### Blockquote → List → Code

> - Item with `code` and **bold**
>   - Nested item with *italic*
>
> ```swift
> let x = 42
> ```

### List → Blockquote → Table

1. First item.

   > Table inside blockquote inside list item:
   >
   > | X | Y |
   > |---|---|
   > | 1 | 2 |

2. Second item.

### Table after code block

```
code block
```

| After | Code |
|-------|------|
| table | row  |

### Heading → Thematic break → Heading

## Section A

---

## Section B

### Adjacent thematic breaks

---
---

### Paragraph → hard break → inline styles

Line one **bold** plain *italic* `code`  
Line two **bold** plain *italic* `code`  
Line three ~~struck~~ plain ***bold-italic***

---

*End of sample file.*
