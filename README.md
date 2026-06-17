![StataMin](https://img.shields.io/badge/stata-2015-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-ntwrk) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-ntwrk) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-ntwrk) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-ntwrk) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-ntwrk)

[Installation](#Installation) | [Syntax](#Syntax) | [Examples](#Examples) | [Feedback](#Feedback) | [Change log](#Change-log)

---

# ntwrk v1.0 (beta)
(17 Jun 2026)

`ntwrk` is a Stata package for network analysis and visualization from edge-list data. It takes a simple edge list — three variables representing the origin node, destination node, and link weight — and computes a rich set of node-level network measures before drawing the graph using one of several layout algorithms.

The command supports directed and undirected networks, optional weighted centrality calculations, flexible node and link styling, curved arcs with arrowheads, and export of all generated coordinates and attributes for downstream use.

**Computation note:** edge-list rows are first collapsed by (`from`, `to`) summing `value`. All centrality and layout algorithms are then applied to the resulting binary adjacency matrix (an edge exists whenever the collapsed value is > 0). Weighted variants rescale edge strengths by the collapsed value when `weighted` is specified.

## Network Measures

Node-level measures are requested via `measure(namelist)`. When `measure()` is omitted, `degree` is computed. When an empty string is passed, all measures are computed. Multiple names can be supplied as a space- or comma-separated list (e.g. `measure(degree between pagerank)`).

| Measure | Description |
|---|---|
| `degree` | Total (undirected) degree: number of distinct neighbours regardless of direction. |
| `indegree` | Number of edges pointing **into** a node (in-degree). In undirected graphs equals `degree`. |
| `outdegree` | Number of edges pointing **out of** a node (out-degree). In undirected graphs equals `degree`. |
| `between` | **Betweenness centrality** — the fraction of all shortest paths in the network that pass through a node. High values indicate bridge or bottleneck nodes. Normalised by $(n-1)(n-2)$ for directed graphs and halved for undirected. |
| `closeness` | **Closeness centrality** — the reciprocal of the average shortest-path distance from a node to all reachable nodes. Nodes that can quickly reach all others score high. Computed on inbound distances (reversed graph). |
| `harmonic` | **Harmonic centrality** — sum of reciprocal distances to all other reachable nodes, normalised by $n-1$. Handles disconnected graphs gracefully because unreachable pairs contribute zero rather than infinity. Computed on inbound distances. |
| `clustering` | **Local clustering coefficient** — the fraction of a node's pairs of neighbours that are themselves connected. Measures how tightly knit the local neighbourhood is. |
| `transitivity` | **Global transitivity (network-level)** — ratio of closed triangles to all connected triples in the graph. A single graph-level scalar assigned identically to every node in the output. |
| `eccentricity` | **Eccentricity** — the maximum shortest-path distance from a node to any other reachable node. The minimum eccentricity across all nodes is the graph *radius*; the maximum is the graph *diameter*. |
| `eigenval` | **Eigenvalue centrality score** — the dominant eigenvalue of the adjacency matrix, reported as a constant for the graph. Companion to `eigenvec`. |
| `eigenvec` | **Eigenvector centrality** — each node's component in the principal eigenvector of the adjacency matrix. A node scores high if it is connected to other high-scoring nodes. |
| `katz` | **Katz centrality** — a damped version of eigenvector centrality that also credits nodes for *all* paths (not just shortest), with longer paths discounted by an attenuation factor $\alpha$ (default $\alpha = 0.1/\lambda_{\max}$). |
| `pagerank` | **PageRank** — the stationary distribution of a random walker who follows edges with probability $(1-d)$ and teleports with probability $d$ (damping factor, default 0.85). Widely used to rank nodes in directed graphs. |
| `hits` | **HITS (Hyperlink-Induced Topic Search)** — computes two scores per node: *hub* (a good hub points to good authorities) and *authority* (a good authority is pointed to by good hubs). Both scores are stored as separate variables. |

All measures except `transitivity` and `eigenval` produce a per-node variable. When `weighted` is specified, path-based measures (betweenness, closeness, harmonic, eccentricity) use edge weights as distances, and spectral measures (eigenvec, katz, pagerank, hits) use the weighted adjacency matrix.

## Layout Options

The node positions used for drawing are determined by `layout(name)`. The default layout is `fr`.

| Layout | Description |
|---|---|
| `fr` | **Fruchterman–Reingold** (default) — a force-directed algorithm that treats edges as springs and nodes as repelling charges. Produces organic, aesthetically pleasing layouts for general networks. Randomised; use `seed()` for reproducibility. |
| `kk` | **Kamada–Kawai** — a stress-minimisation layout that positions nodes so that their graph-theoretic distances match their Euclidean distances as closely as possible. Well-suited to smaller, dense graphs. |
| `spectral` | **Spectral layout** — uses the eigenvectors of the graph Laplacian to embed nodes into two dimensions. Tends to reflect community structure and produce symmetric layouts. |
| `star` | Places one node at the centre and distributes all remaining nodes evenly around a single circle. Useful for hub-and-spoke topologies. |
| `sphere` | Distributes all nodes uniformly on a circle (spherical shell in 2D); helpful for highlighting cross-network connections. |
| `grid` | Arranges nodes on a regular rectangular grid. No topological information is encoded; best used when node labels matter more than positions. |
| `random` | Places nodes at uniformly random coordinates within the canvas. Use `seed()` to fix placement. |
| `bipartite` | Two-column layout that places nodes on two vertical tracks based on their role (source vs. destination in the edge list). Appropriate for two-mode or bipartite networks. |

Canvas dimensions are controlled with `width()` and `height()` (default 150 × 150). A random seed for stochastic layouts is set with `seed()`.

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
ssc install graphfunctions, replace
```


If these are already installed, then also please periodically check for updates:

```stata
ado update, update
```

## Syntax

```stata
ntwrk value [if] [in], from(varname) to(varname) [options]
```

| Option group | Options |
|---|---|
| **Measures** | `measure(namelist)`, `weighted` |
| **Parameters** | `iterations(#)`, `tolerance(#)`, `radius(#)` |
| **Layout** | `layout(star\|fr\|sphere\|grid\|random\|spectral\|kk\|bipartite)`, `seed(#)`, `width(#)`, `height(#)` |
| **Links** | `lquantile(#)`, `lwidth(str)`, `lalpha(#)`, `reduce(#)`, `lscale`, `lscalefactor(#)`, `lprop`, `lpropfactor(#)`, `lpalette(str)` |
| **Nodes** | `mquantile(#)`, `mvar(varname)`, `msize(str)`, `malpha(#)`, `mlapha(#)`, `msymbol(str)`, `mscale`, `mscalefactor(#)`, `mlcolor(str)`, `mlwidth(str)`, `mprop`, `mpropfactor(#)`, `mpalette(str)` |
| **Arcs** | `arc`, `arcn(#)`, `arcradius(#)`, `arrowsize(str)` |
| **Output** | `nograph`, `save`, `replace`, `saveprefix(str)`, `novalues`, `format(str)` |

Valid measure names for `measure()`: `degree`, `indegree`, `outdegree`, `between`, `closeness`, `harmonic`, `clustering`, `transitivity`, `eccentricity`, `eigenval`, `eigenvec`, `katz`, `pagerank`, `hits`. Multiple names may be space- or comma-separated. Omitting `measure()` computes `degree` only; passing an empty string computes all measures.

See the help file for full details:

```stata
help ntwrk
```

## Examples

Load the data:

```stata
use "https://github.com/asjadnaqvi/stata-ntwrk/raw/refs/heads/main/data/BACI_HS22_Y2024_country.dta", clear
```

### Minimal baseline

```stata

ntwrk value if value > 100, from(ex_iso3) to(im_iso3) ///
	layout(fr) seed(1234) novalues ///
	mlabsize(1.2) lwidth(0.30) lalpha(75) malpha(90)
```

![Minimal baseline](/figures/ntwrk_01_baseline_default.png)

### Cleaner Fruchterman-Reingold layout

```stata
ntwrk value if value > 100, from(ex_iso3) to(im_iso3) ///
	measure(degree between) mvar(degree) ///
	layout(fr) seed(1234) novalues ///
	lpalette(cividis) mpalette(viridis) ///
	lscale mscale lscalefactor(0.50) mscalefactor(0.45) ///
	mlabsize(1.2) ///
	lalpha(75) malpha(90)
```

![Fruchterman-Reingold layout](/figures/ntwrk_02_fr_seeded_clean.png)

### 3. Layout gallery

The commands below use the same data and baseline styling; the figures are shown in pairs so the no-arc and arc versions sit next to each other.

```stata
ntwrk value if value > 100, from(ex_iso3) to(im_iso3) ///
	measure(degree between pagerank) mvar(pagerank) ///
	layout(fr) seed(1234) novalues ///
	lpalette(rocket) msize(8) lwidth(0.6) ///
	lscale mscale mlcolor(black)

ntwrk value if value > 100, from(ex_iso3) to(im_iso3) ///
	measure(degree between pagerank) mvar(pagerank) ///
	layout(fr) seed(1234) novalues ///
	lpalette(rocket) msize(8) lwidth(0.6) ///
	lscale mscale mlcolor(black) arc
```

| Layout | No arc | Arc |
|---|---|---|
| Fruchterman-Reingold `layout(fr)` | ![Fruchterman-Reingold layout](/figures/ntwrk_06_layout_fr.png) | ![Fruchterman-Reingold arc layout](/figures/ntwrk_06_layout_fr_arc.png) |
| Kamada-Kawai `layout(kk)` | ![Kamada-Kawai layout](/figures/ntwrk_06_layout_kk.png) | ![Kamada-Kawai arc layout](/figures/ntwrk_06_layout_kk_arc.png) |
| Spectral `layout(spectral)` | ![Spectral layout](/figures/ntwrk_06_layout_spectral.png) | ![Spectral arc layout](/figures/ntwrk_06_layout_spectral_arc.png) |
| Star `layout(star)` | ![Star layout](/figures/ntwrk_06_layout_star.png) | ![Star arc layout](/figures/ntwrk_06_layout_star_arc.png) |
| Sphere `layout(sphere)` | ![Sphere layout](/figures/ntwrk_06_layout_sphere.png) | ![Sphere arc layout](/figures/ntwrk_06_layout_sphere_arc.png) |
| Grid `layout(grid)` | ![Grid layout](/figures/ntwrk_06_layout_grid.png) | ![Grid arc layout](/figures/ntwrk_06_layout_grid_arc.png) |
| Random `layout(random)` | ![Random layout](/figures/ntwrk_06_layout_random.png) | ![Random arc layout](/figures/ntwrk_06_layout_random_arc.png) |
| Bipartite `layout(bipartite)` | ![Bipartite layout](/figures/ntwrk_06_layout_bipartite.png) | ![Bipartite arc layout](/figures/ntwrk_06_layout_bipartite_arc.png) |
| Shell `layout(shell)` | ![Shell layout](/figures/ntwrk_06_layout_shell.png) | ![Shell arc layout](/figures/ntwrk_06_layout_shell_arc.png) |
| Spiral `layout(spiral)` | ![Spiral layout](/figures/ntwrk_06_layout_spiral.png) | ![Spiral arc layout](/figures/ntwrk_06_layout_spiral_arc.png) |

### 4. Styling showcase

```stata
ntwrk value if value > 100, from(ex_iso3) to(im_iso3) ///
	measure(degree) mvar(degree) layout(fr) seed(42) ///
	lquantile(6) mquantile(6) lscale mscale ///
	lscalefactor(0.45) mscalefactor(0.45) ///
	lpalette(rocket) mpalette(cividis) mprop noval ///
	lalpha(72) malpha(50) mlabsize(1.2) msize(10) mlwidth(0.06) arc ///
	title("ntwrk showcase: BACI 2024", size(small)) ///
	subtitle("Filter: value > 100", size(vsmall))
```

![Styling showcase](/figures/ntwrk_08_styling_showcase.png)

### 5. Publication-style preset

```stata
ntwrk value if value > 100, from(ex_iso3) to(im_iso3) ///
	measure(pagerank) mvar(pagerank) weighted layout(fr) seed(2026) ///
	lquantile(10) lscale mscale mscalefactor(0.50) ///
	lpalette(tab Orange-Gold, reverse) ///
	malpha(50) mpalette(white) mprop mlapha(100) msize(8) mlabsize(1.5) ///
	mlcolor(black) mlwidth(0.25) novalues lwidth(0.6) arc ///
	title("Global trade network (BACI HS22, 2024)", size(medsmall)) ///
	subtitle("Nodes: countries | Links: value > 100", size(vsmall))
```

![Publication preset](/figures/ntwrk_10_publication_preset.png)

The same pattern can be adapted for weighted analyses, different layouts, or export-only runs using `nograph save`.

## Feedback

Please open an issue to report bugs, feature requests, or other suggestions:

https://github.com/asjadnaqvi/stata-ntwrk/issues

## Change log

**v1.0 (beta) (17 Jun 2026)**
- First public beta release.
