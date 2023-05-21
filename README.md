# Mathjax3 Extension For Quarto

This filter adds features for complex mathematical equations and equation numbering from MathJax3, as suggested by @eeholmes [here](https://github.com/quarto-dev/quarto-cli/issues/4136).
It is mainly meant as a proof-of-concept, but might be useful for the time being :-).

With this filter, you get

- equation **numbering within section**, also for markdown displayed equations (in `$$`..`$$`)
- tags via `\tag` also for markdown equations.

The filter transforms markdown equations into LaTeX equations that are handled by MathJax.

### Caveats

- Equations can only be referenced via LaTeX `\ref` or `\eqref`; quarto markdown references via `@eq-` are no longer working,
- All LaTeX equations are numbered. Markdown equations are only numbered if they have a reference label,
- The **only** supported output formats are **pdf and html**.

## Installing

```bash
quarto add ute/mathjax3
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

## Using

Add the filter to your yaml, and set `number-sections` to `true`. Currently, there are no further options. 
Then write and refer to equations as you would do in LaTeX. Labelled markdown equations are supported when the label starts with `#eq-`.

```text
---
filters: [mathjax3]
number-sections: true
---
# Intro
First equation
$$
   \lim_{n\to\infty} \exp(n) = \infty
$${#eq-toinf}

# Second section
Refer to \eqref{eq-toinf} and solve
\begin{equation}
  e = mc^2
\end{equation}

```

Here is the source code for a minimal example: [example.qmd](example.qmd).

