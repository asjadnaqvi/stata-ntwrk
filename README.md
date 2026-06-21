![StataMin](https://img.shields.io/badge/stata-2015-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-ntwrk) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-ntwrk) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-ntwrk) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-ntwrk) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-ntwrk)

[Installation](#Installation) | [Syntax](#Syntax) | [Examples](#Examples) | [Feedback](#Feedback) | [Change log](#Change-log)
---

<img width="100%" alt="ntwrk_banner" src="https://github.com/user-attachments/assets/6643f77e-0912-475a-9689-9af35140695b" />



# ntwrk v1.0 (beta)
(17 Jun 2026)

`ntwrk` is a Stata package for network analysis and visualization from edge-list data.



## Network Measures

The command supports the following network measures:

| Measure | Description |
|---|---|
| `degree` | Total directed degree, computed as `indegree + outdegree`. With `weighted`, this becomes weighted in-strength plus weighted out-strength. |
| `indegree` | Number of incoming links to a node. With `weighted`, this is the sum of incoming link values. |
| `outdegree` | Number of outgoing links from a node. With `weighted`, this is the sum of outgoing link values. |
| `between` | **Betweenness centrality** on directed shortest paths, normalised by $(n-1)(n-2)$. With `weighted`, path lengths use edge costs $1/\text{value}$. |
| `closeness` | **Closeness centrality** based on inbound distances (computed on the reversed graph), with reachability adjustment for disconnected directed graphs. With `weighted`, distances are from weighted shortest paths. |
| `harmonic` | **Harmonic centrality** as the sum of reciprocal inbound shortest-path distances (reversed graph). Unreachable nodes contribute zero. With `weighted`, distances are from weighted shortest paths. |
| `clustering` | **Local clustering coefficient**: the fraction of a node's pairs of neighbours that are themselves connected. Measures how tightly knit the local neighbourhood is. |
| `transitivity` | **Global transitivity (network-level)**: ratio of closed triangles to all connected triples in the graph. A single graph-level scalar assigned identically to every node in the output. |
| `eccentricity` | **Eccentricity** computed on a symmetrised (undirected) version of the graph as the maximum finite shortest-path distance from each node to reachable nodes. With `weighted`, undirected edge cost uses available direction cost (or the minimum if both directions exist). |
| `eigenval` | Iterative spectral centrality vector (power iteration; controlled by `iterations()` and `tolerance()`). This returns a node-level score vector. |
| `eigenvec` | **Eigenvector centrality**: each node's component in the principal eigenvector of the adjacency matrix. A node scores high if it is connected to other high-scoring nodes. |
| `katz` | **Katz centrality** using inbound influence ($G'$) with default `katzalpha(0.1)` and fixed $\beta=1$. With `weighted`, the weighted adjacency matrix is used. |
| `pagerank` | **PageRank** with damping/follow parameter fixed at `0.85`; teleportation is `0.15`. `iterations()` and `tolerance()` control convergence checks. With `weighted`, transition probabilities use weighted outgoing links. |
| `hits` | **HITS (Hyperlink-Induced Topic Search)**: computes two scores per node: *hub* (a good hub points to good authorities) and *authority* (a good authority is pointed to by good hubs). Both scores are stored as separate variables. |
| `core` | Undirected **core number** (k-core index) computed on the symmetrised topology. |
| `reciprocity` | Node-level reciprocity: share of each node's incident directed ties that are mutual. |
| `ancestors` | Number of nodes that can reach the node via directed paths. |
| `descendants` | Number of nodes reachable from the node via directed paths. |

All listed measures are node-level outputs. `transitivity` is a network-level scalar that is repeated on each node row for convenience, and `hits` returns two node-level variables (`hub` and `authority`).

## Layout Options

The command supports the following network layouts:

| Layout | Description |
|---|---|
| `fr` | **Fruchterman–Reingold** (default): a force-directed algorithm that treats edges as springs and nodes as repelling charges. Produces organic, aesthetically pleasing layouts for general networks. Randomised; use `seed()` for reproducibility. |
| `kk` | **Kamada–Kawai**: a stress-minimisation layout that positions nodes so that their graph-theoretic distances match their Euclidean distances as closely as possible. Well-suited to smaller, dense graphs. |
| `spectral` | **Spectral layout**: uses the eigenvectors of the graph Laplacian to embed nodes into two dimensions. Tends to reflect community structure and produce symmetric layouts. |
| `star` | Places one node at the centre and distributes all remaining nodes evenly around a single circle. Useful for hub-and-spoke topologies. |
| `sphere` | Distributes all nodes uniformly on a circle (spherical shell in 2D); helpful for highlighting cross-network connections. |
| `grid` | Arranges nodes on a regular rectangular grid. No topological information is encoded; best used when node labels matter more than positions. |
| `random` | Places nodes at uniformly random coordinates within the canvas. Use `seed()` to fix placement. |
| `bipartite` | Two-column layout that places nodes on two vertical tracks based on their role (source vs. destination in the edge list). Appropriate for two-mode or bipartite networks. |


## Installation

The package can be installed via SSC or GitHub. The GitHub version might be more recent due to bug fixes and feature updates.

SSC (pending):

```stata
XXXX
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
| **Measures** | `measure(namelist)`, `weighted`, `directedclustering`, `katzalpha(#)` |
| **Parameters** | `iterations(#)`, `tolerance(#)`, `radius(#)` |
| **Layout** | `layout(star\|fr\|sphere\|grid\|random\|spectral\|kk\|bipartite)`, `seed(#)`, `width(#)`, `height(#)` |
| **Links** | `lquantile(#)`, `lwidth(str)`, `lalpha(#)`, `reduce(#)`, `lscale`, `lscalefactor(#)`, `lprop`, `lpropfactor(#)`, `lpalette(str)` |
| **Nodes** | `mquantile(#)`, `mvar(varname)`, `msize(str)`, `malpha(#)`, `mlapha(#)`, `msymbol(str)`, `mscale`, `mscalefactor(#)`, `mlcolor(str)`, `mlwidth(str)`, `mprop`, `mpropfactor(#)`, `mpalette(str)` |
| **Arcs** | `arc`, `arcn(#)`, `arcradius(#)`, `arrowsize(str)` |
| **Output** | `nograph`, `save`, `replace`, `saveprefix(str)`, `novalues`, `format(str)` |


See the help file for full details:

```stata
help ntwrk
```

## Examples

Load the data:

```stata
use "https://github.com/asjadnaqvi/stata-ntwrk/raw/refs/heads/main/data/BACI_HS22_Y2024_country.dta", clear
```

### Minimal example

```stata
ntwrk value if value > 100, from(ex_iso3) to(im_iso3) title("layout(fr) + random seed")
```

![Minimal baseline](/figures/ntwrk_01_baseline_default.png)


```stata
ntwrk value if value > 100, from(ex_iso3) to(im_iso3) seed(1234) title("layout(fr) + fixed seed")
```

![Minimal baseline](/figures/ntwrk_01_baseline_default2.png)

### Exporting node measures

Unweighted network measures:

```stata
ntwrk value if value > 100, from(ex_iso3) to(im_iso3) ///
    measure(degree between indegree outdegree closeness harmonic pagerank hits) ///
    nograph save saveprefix("./data/ntwrk_unweighted_bundle") replace
```

Weighted network measures:

```stata
ntwrk value if value > 100, from(ex_iso3) to(im_iso3) weighted ///
    measure(degree between indegree outdegree closeness harmonic eigenvec katz pagerank hits) ///
    nograph save saveprefix("./data/ntwrk_weighted_bundle") replace	
```

Metrics with directed clustering:

```stata
ntwrk value if value > 100, from(ex_iso3) to(im_iso3) ///
    measure(clustering transitivity reciprocity ancestors descendants core) ///
    directedclustering nograph save saveprefix("./data/ntwrk_measures") replace	
```


### Network graph

```stata
ntwrk value if value > 100, from(ex_iso3) to(im_iso3) ///
    measure(degree between) mvar(degree) ///
    layout(fr) seed(1234) novalues ///
    lpalette(cividis) mcolor(gs14)  ///
    lprop lscale mscale msize(8) mlc(black)  mlabsize(1.2) 
```

![Fruchterman-Reingold layout](/figures/ntwrk_02_fr_seeded_clean.png)

### Layout gallery

The commands below use the same data and baseline styling with and without arcs:

```stata
foreach x in fr kk spectral star sphere grid random bipartite shell spiral {

	ntwrk value if value > 100, from(ex_iso3) to(im_iso3) ///
		measure(pagerank) mvar(pagerank) ///
		layout(`x') seed(1234) novalues ///
		lpalette(rocket) lprop msize(8) lwid(0.6)  ///
		lscale mscale mlc(black) mc(gs14)


	ntwrk value if value > 100, from(ex_iso3) to(im_iso3) ///
		measure(pagerank) mvar(pagerank) ///
		layout(`x') seed(1234) novalues ///
		lpalette(rocket) lprop msize(8) lwid(0.6)  ///
		lscale mscale mlc(black) mc(gs14) arc
}
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




### More detailed examples:

```stata
ntwrk value if value > 100, from(ex_iso3) to(im_iso3) ///
    measure(degree)  mvar(degree) layout(fr) seed(42) ///
    lquantile(6) mquantile(6) lscale lprop mscale ///
    lscalefactor(0.45) mscalefactor(0.45) ///
    lpalette(rocket) mpalette(cividis) mprop noval ///
    lalpha(72) malpha(50) mlabsize(1.2) msize(10) mlwidth(0.06) arc ///
    title("ntwrk showcase: BACI 2024", size(small)) ///
    subtitle("Filter: value > 100", size(vsmall)) 
```

![Styling showcase](/figures/ntwrk_08_styling_showcase.png)


```stata
ntwrk value if value > 80, from(ex_iso3) to(im_iso3) ///
    measure(pagerank) mvar(pagerank) weighted layout(fr) seed(2026) ///
    lquantile(10) lscale mscale mscalefactor(0.50) ///
    lpalette(tab Orange-Gold, reverse) lprop  ///
    malpha(50) mpalette(white) mprop mlalpha(100) msize(8)  mlabsize(1.5) mlcolor(black)  mlwidth(0.25) ///
    novalues lwidth(0.6) arc   ///
    title("Global trade network (BACI HS22, 2024)", size(medsmall)) ///
    subtitle("Nodes: countries | Links: value > 100", size(vsmall)) 
```

![Publication preset](/figures/ntwrk_10_publication_preset.png)


```stata
ntwrk value if value > 100, from(ex_iso3) to(im_iso3) ///
    measure(pagerank) mvar(pagerank) weighted layout(star) seed(2026) ///
    lquantile(10) lscale mscale mscalefactor(0.50) ///
    lpalette(tab Green-Gold, reverse) lprop  ///
    lalpha(72) malpha(0) mlalpha(100) msize(10)  mlabsize(1.8) mlcolor(black)  mlwidth(0.15) ///
    novalues lwidth(0.6) arc  ///
    title("Global trade network (BACI HS22, 2024)", size(medsmall)) ///
    subtitle("Nodes: countries | Links: value > 100", size(vsmall)) 
```

![Publication preset](/figures/ntwrk_10_publication_preset2.png)


## Feedback

Please open an issue to report bugs, feature requests, or other suggestions:

https://github.com/asjadnaqvi/stata-ntwrk/issues

## Change log

**v1.0 (beta) (17 Jun 2026)**
- First public beta release.
