{smcl}
{* 02Jun2026}{...}
{hi:help ntwrk}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-ntwrk":ntwrk v1.0 (beta) (GitHub)}}

{hline}

{title:ntwrk}: is a Stata package for network analysis and visualization from edge-list data.

{p 4 4 2}
{cmd:ntwrk} computes a set of node-level network statistics and draws directed network graphs with multiple layouts.
It includes weighted links, optional curved arcs, and export of graph coordinates and attributes.

{p 4 4 2}
Computation notes: edge-list rows are first collapsed by ({it:from}, {it:to}) using the sum of {it:value}. Centrality and layout algorithms are then computed on a binary adjacency matrix (edge exists if collapsed value > 0). Link {it:value} is used for drawing classes (quantiles) and labels.

{p 4 4 2}
Parts of the routines are based on ideas from {browse "https://igraph.org/":igraph} and {browse "https://networkx.org/":NetworkX}.


{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:ntwrk} {it:from to value} {ifin} {cmd:,} [{help ntwrk##measures:{it:network measures}}] [{help ntwrk##common:{it:parameters}}]
	[{help ntwrk##layout:{it:network layout}}] 
	[{help ntwrk##nodes:{it:node options}}]
	[{help ntwrk##links:{it:link options}}] [{help ntwrk##arcs:{it:arc options}}] 
	[{help ntwrk##output:{it:save and export options}}] 



{marker options}{title:Options}

{synoptset 28 tabbed}{...}

{marker required}{dlgtab:Required}

{p2coldent : {opt network} {it:from to value}}Three numeric variables: source node, target node, and link value (edge weight).{p_end}


{marker measures}{dlgtab:Network measures}

{p2coldent : {bf:degree (always returned)}}Total degree computed as indegree + outdegree on the binary directed graph. No option is required for this column; it is always included in node output.{p_end}

{p2coldent : {opt indegree}}In-degree count on the binary directed graph (number of incoming neighbors).{p_end}

{p2coldent : {opt outdegree}}Out-degree count on the binary directed graph (number of outgoing neighbors).{p_end}

{p2coldent : {opt between}}Compute normalized betweenness centrality from unweighted shortest paths (direction respected). Edge magnitudes are not used in path lengths.{p_end}

{p2coldent : {opt closeness}}Compute outward-reach closeness centrality from BFS distances in the directed graph. Unreachable nodes contribute 0; isolated nodes can have closeness 0.{p_end}

{p2coldent : {opt harmonic}}Compute harmonic centrality from BFS distances in the directed graph. Unreachable nodes contribute 0.{p_end}

{p2coldent : {opt clustering}}Compute local clustering coefficient. Neighbor links are treated as connected if either direction exists (undirected-style triangle counting).{p_end}

{p2coldent : {opt transitivity}}Compute global transitivity. Neighbor links are treated as connected if either direction exists (undirected-style triangle counting).{p_end}

{p2coldent : {opt eccentricity}}Compute node eccentricity as the maximum finite directed BFS distance from each node. Nodes with no reachable others return missing.{p_end}

{p2coldent : {opt eigenval}}Compute iterative eigenvalue centrality (controlled by {opt iterations()} and {opt tolerance()}).{p_end}

{p2coldent : {opt eigenvec}}Compute leading-eigenvector centrality.{p_end}

{p2coldent : {opt katz}}Compute Katz centrality. Current fixed internals are Katz alpha=0.1 and beta=1.{p_end}

{p2coldent : {opt pagerank}}Compute PageRank. Current fixed damping is 0.85; {opt iterations()} and {opt tolerance()} govern convergence checks.{p_end}

{p2coldent : {opt hits}}Compute HITS hub/authority scores. {opt iterations()} and {opt tolerance()} govern convergence checks.{p_end}


{marker common}{dlgtab:Parameters}

{p2coldent : {opt iter:ations(num)}}Maximum iterations for iterative routines. Default is {opt iterations(100)}.{p_end}

{p2coldent : {opt tol:erance(num)}}Convergence tolerance. Default is {opt tolerance(1e-6)}.{p_end}

{p2coldent : {opt radius(num)}}Radius used by the {opt layout(star)} layout. Default is {opt radius(5)}.{p_end}


{marker layout}{dlgtab:Layout options}

{p2coldent : {opt layout(star)}}Places nodes around a circle. Controlled by {opt radius()} before normalization. Deterministic.{p_end}

{p2coldent : {opt layout(fr)}}Fruchterman-Reingold force layout (spring-electrical). Uses random initialization, {opt iterations()}, {opt width()}, {opt height()}. Use {opt seed()} for reproducibility.{p_end}

{p2coldent : {opt layout(sphere)}}Fibonacci-style sphere sampling projected to 2D. Useful for spreading many nodes; deterministic.{p_end}

{p2coldent : {opt layout(grid)}}Regular row-column placement over the target frame. Deterministic and fast for large node counts.{p_end}

{p2coldent : {opt layout(random)}}Uniform random placement in the target frame. Use {opt seed()} for reproducibility.{p_end}

{p2coldent : {opt layout(spectral)}}Uses Laplacian eigenvectors (2nd/3rd) from a symmetrized adjacency matrix. Often separates weakly connected groups; deterministic for a fixed graph.{p_end}

{p2coldent : {opt layout(kk)}}Kamada-Kawai spring embedder using all-pairs shortest-path distances. Uses {opt iterations()} and {opt tolerance()} for optimization stopping.{p_end}

{p2coldent : {opt layout(bipartite)}}Two-column layout: source-like nodes on the left, pure targets on the right (fallback split by outdegree vs indegree if needed). Good for sender-receiver structures.{p_end}


{p2coldent : {opt seed(num)}}Random seed applied before computation. This affects stochastic components such as {opt layout(fr)} and {opt layout(random)}.{p_end}

{p2coldent : {opt width(num)}, {opt height(num)}}Target frame dimensions. Defaults are {opt width(150)} and {opt height(150)}.{p_end}


{marker links}{dlgtab:Link options}

{p2coldent : {opt lquant:ile(num)}}Number of link quantile classes for color/width grouping. Default is {opt lquantile(10)}.{p_end}

{p2coldent : {opt lw:idth(num)}}Base line-width multiplier. Default is {opt lwidth(1)}.{p_end}

{p2coldent : {opt la:lpha(num)}}Link transparency. Default is {opt lalpha(80)}.{p_end}

{p2coldent : {opt reduce(num)}}Trim link endpoints by a fixed length before drawing. Default is {opt reduce(0)}.{p_end}

{p2coldent : {opt lscale}}Enable quantile-based link width scaling. Without this option, all links use constant {opt lwidth()}.{p_end}

{p2coldent : {opt lscalefac:tor(num)}}Exponent used in link width scaling when {opt lscale} is on. Default is {opt lscalefactor(0.3333)}.{p_end}

{p2coldent : {opt lpalette(str)}}Color palette for links via {help colorpalette}. The default is {it:eltblue}.{p_end}

{p2coldent : {opt noval:ues}}Suppress edge-value labels.{p_end}


{marker arcs}{dlgtab:Arc options}

{p2coldent : {opt arc}}Draw links as curved arcs instead of straight arrows. Arcs inherit link properties where necessary.{p_end}

{p2coldent : {opt arcn(num)}}Number of sampled points used per arc. Default is {opt arcn(40)}.{p_end}

{p2coldent : {opt arcrad:ius(num)}}Arc radius passed to the arc constructor; controls curvature when {opt arc} is specified.{p_end}

{p2coldent : {opt arrow:size(num)}}Arrowhead size. Default is {opt arrowsize(1.2)}.{p_end}


{marker nodes}{dlgtab:Node options}

{p2coldent : {opt mquant:ile(num)}}Number of node quantile classes. Default is {opt mquantile(10)}.{p_end}

{p2coldent : {opt mvar(varname)}}Variable used for node quantile assignment (node color classes). If omitted, {it:degree} is used.{p_end}

{p2coldent : {opt ms:ize(num)}}Base node size. Default is {opt msize(5)}.{p_end}

{p2coldent : {opt ma:lpha(num)}}Node transparency. Default is {opt malpha(80)}.{p_end}

{p2coldent : {opt msym:bol(str)}}Reserved marker-symbol option. Node areas are currently drawn as circle polygons and labels are drawn separately.{p_end}

{p2coldent : {opt mscale}}Enable node-size scaling. Without this option, all nodes use constant {opt msize()}.{p_end}

{p2coldent : {opt mscalefac:tor(num)}}Exponent used in node scaling when {opt mscale} is on. Default is {opt mscalefactor(0.3333)}.{p_end}

{p2coldent : {opt mpalette(str)}}Color palette for node fills via {help colorpalette}. The default is {it:gs10}.{p_end}


{marker output}{dlgtab:Output and export}

{p2coldent : {opt nogra:ph}}Skip plotting. In the current version, this also bypasses the {opt savedata} export block.{p_end}

{p2coldent : {opt savedata}}Export generated link/node coordinates and attributes to disk.{p_end}

{p2coldent : {opt saveprefix(str)}}Prefix for exported dataset filename. If omitted with {opt savedata}, default prefix is {it:_network}.{p_end}



{p2coldent : {opt *}}Pass standard twoway options that are not explicitly blocked by the command.{p_end}

{synoptline}
{p2colreset}{...}


{title:Dependencies}

{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}

Optional dependency used only with {opt arc}:
{stata ssc install graphfunctions, replace}


{title:Examples}

See {browse "https://github.com/asjadnaqvi/stata-ntwrk":GitHub} for examples.


{hline}

{title:Feedback}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-ntwrk/issues":GitHub} by opening a new issue.


{title:Package details}

Version      : {bf:ntwrk} v1.0 (beta)
This release : 02 Jun 2026
First release: 02 Jun 2026
Repository   : {browse "https://github.com/asjadnaqvi/stata-ntwrk":GitHub}
Keywords     : Stata, networks, graphs, centrality, visualization
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}


{title:Citation guidelines}

Use the package details above and repository URL for software citation until an SSC citation entry is assigned for this package name.


{title:References}

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.

{p 4 8 2}Jann, B. (2022). {browse "https://ideas.repec.org/p/bss/wpaper/43.html":Color palettes for Stata graphics: An update}. University of Bern Social Sciences Working Papers No. 43.


{title:Other visualization packages}

{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb graphfunctions},
	{helpb geoboundary}, {helpb geoflow}, {helpb joyplot}, {helpb marimekko}, {helpb ntwrk}, {helpb polarspike}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb splinefit}, {helpb streamplot}, 
	{helpb sunburst}, {helpb ternary}, {helpb tidytuesday}, {helpb treecluster}, {helpb treemap}, {helpb trimap}, {helpb waffle}, {helpb vcontrol}

Visit {browse "https://github.com/asjadnaqvi":GitHub} for further details.	