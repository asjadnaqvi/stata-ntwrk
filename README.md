![StataMin](https://img.shields.io/badge/stata-2015-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-ntwrk) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-ntwrk) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-ntwrk) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-ntwrk) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-ntwrk)

[Installation](#Installation) | [Syntax](#Syntax) | [Examples](#Examples) | [Feedback](#Feedback) | [Change log](#Change-log)

---

# ntwrk v1.0 (beta)
(02 Jun 2026)

`ntwrk` is a Stata package for network analysis and visualization from edge-list data.

The command computes node-level network statistics and draws directed network graphs with multiple layout options. It supports weighted links for display classes and labels, optional curved arcs, and export of generated graph coordinates and attributes.

Computation note: edge-list rows are first collapsed by (`from`, `to`) using the sum of `value`. Centrality and layout algorithms are then computed on a binary adjacency matrix (edge exists if collapsed value > 0).

## Installation

The package can be installed via SSC or GitHub. The GitHub version might be more recent due to bug fixes and feature updates.

SSC (pending):

```stata
* ssc install ntwrk, replace
```

GitHub (v1.0 beta):

```stata
net install ntwrk, from("https://raw.githubusercontent.com/asjadnaqvi/stata-ntwrk/main/installation/") replace
```

Required packages:

```stata
ssc install palettes, replace
ssc install colrspace, replace
```

Optional package (used with `arc` option):

```stata
ssc install graphfunctions, replace
```

If these are already installed, check for updates:

```stata
ado update, update
```

## Syntax

The basic command is:

```stata
ntwrk from to value, [options]
```

Main option groups include:

- Network measures: `indegree`, `outdegree`, `between`, `closeness`, `harmonic`, `clustering`, `transitivity`, `eccentricity`, `eigenval`, `eigenvec`, `katz`, `pagerank`, `hits`
- Parameters: `iterations()`, `tolerance()`, `radius()`
- Layout: `layout(star|fr|sphere|grid|random|spectral|kk|bipartite)`, `seed()`, `width()`, `height()`
- Links: `lquantile()`, `lwidth()`, `lalpha()`, `reduce()`, `lscale`, `lscalefactor()`, `lpalette()`, `novalues`
- Nodes: `mquantile()`, `mvar()`, `msize()`, `malpha()`, `mscale`, `mscalefactor()`, `mpalette()`
- Arcs: `arc`, `arcn()`, `arcradius()`, `arrowsize()`
- Output: `nograph`, `savedata`, `saveprefix()`

See the help file for full details:

```stata
help ntwrk
```

## Examples


## Feedback

Please open an issue to report bugs, feature requests, or other suggestions:

https://github.com/asjadnaqvi/stata-ntwrk/issues

## Change log

**v1.0 (beta) (02 Jun 2026)**
- First public beta release.
