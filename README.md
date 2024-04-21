# MathJax3Eqno Extension For Quarto

This filter adds features for complex mathematical equations and equation numbering from MathJax3, as suggested by @eeholmes [here](https://github.com/quarto-dev/quarto-cli/issues/4136).
It is mainly meant as a proof-of-concept, but might be useful for the time being :-).

With this filter, you get

- equation **numbering within section**, also for markdown displayed equations (in `$$`..`$$`)
- tags via `\tag` also for markdown equations.

The filter transforms markdown equations into LaTeX equations that are handled by MathJax.

### Caveats

- Equations can only be referenced via LaTeX `\ref` or `\eqref`; quarto markdown references via `@eq-` are no longer working,
- All LaTeX equations are numbered, unless you use the starred version `\begin{equation*}` or `\notag`. Markdown equations are only numbered if they have a reference label,
- The **only** supported output formats are **pdf and html**,
- It does **not** (yet) work as one would expect for **html-books**: section numbering starts in each chapter with 1 again, not with the chapter number. Please write / vote for an issue or send a PR if you desperately want to use the extension with books. This would require a more extensive hack... Update: I have gotten a vote for this and will implement the book feature soonish (spring 2024). If you are faster, send a PR
- it requires MathJax3, therefore quarto $\geq 1.3.x$, where $x$ is unknown (I have $x = 353$)
- Does not work with parse-latex extension, use [parse-latex-noeq](https://github.com/ute/parse-latex-noeq) instead.

## Installing

```bash
quarto add ute/mathjax3eqno
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

## Using

Add the filter to your yaml, and set `number-sections` to `true`. Currently, there are no further options. 
Then write and refer to equations as you would do in LaTeX. Labelled markdown equations are supported when the label starts with `#eq-`.

```text
---
filters: [mathjax3eqno]
number-sections: true
---
# First Section
First equation
$$
   \lim_{n\to\infty} \exp(n) = \infty
$${#eq-toinf}

And another one:
$$
  a^2 + b^2 = c^2 \tag{$\ast$}
  \label{eq-py}
$$

# Second Section
Refer to \eqref{eq-toinf} and solve
\begin{equation}
  e = mc^2
\end{equation}
Then ponder about \eqref{eq-py}
```
renders as

![image](https://github.com/ute/mathjax3eqno/assets/5145859/3c6b6353-7384-4777-91b1-46cbebde662a)

Here is the source code for a minimal example: [example.qmd](example.qmd).

