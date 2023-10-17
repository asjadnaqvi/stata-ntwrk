{smcl}
{* 17October2023}{...}
{hi:help network}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-network":network v1.0 (beta) (GitHub)}}

{hline}

{title:NETWORK}

{p 4 4 2}
{cmd:NETWORK} implements the various algorithms for evaluating network measures and plotting networks.

{p 4 4 2}
The routines are based on R's {browse "https://igraph.org/":igraph} and Python's {browse "https://networkx.org/":NetworkX} libraries. 

{p 4 4 2}
The package is still in its initial stages so please report bugs and enhancements in the {browse "https://github.com/asjadnaqvi/stata-network/issues":GitHub issue} section


TODO:
- Fix centrality
- Fix pagerank
- Add support for link weights
- Add support for custom node attributes
- Add option for expanding or contracting layouts

{marker syntax}{title:Syntax}

{p 8 15 2}
{cmd:network} {it:from to value} [if] [in] {cmd:[}, 
	 {cmd:degree} {cmd:indegree} {cmd:outdegree} {cmd:between} {cmd:closeness} {cmd:eigenval} {cmd:eigenvec} {cmd:katz} {cmd:pagerank} {cmd:hits}
	 {cmdab:iter:ations}(num) {cmdab:tol:erance}(num) 
	 {cmd:layout}({it:star}|{it:fr}|{it:sphere})
	 {cmd:lcats}(num) {cmd:ncats}(num) {cmd:nvar}(string)
	{cmd:]}

Note that the input requires an edge list with from, to, value, as numeric variables. 


{p 4 4 2}
The options are described as follows:

{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt network from to value}}The command requires and edge list with numeric {it:from} a numeric {it:to} variables and a numeric {it:value} variable.{p_end}


{p 4 4 2}
{it:{ul:Node measures}}

{p2coldent : {opt degree}}Node degree = indegree + outdegree. This measure is always calculated.{p_end}

{p2coldent : {opt indegree}}Node in-degree. Stores "indegree" variable in the nodes attributes file.{p_end}

{p2coldent : {opt outdegree}}Node out-degree. Stores "outdegree" variable.{p_end}

{p2coldent : {opt between}}Betweenness centrality. Stores "between" variable.{p_end}

{p2coldent : {opt closeness}}Closeness centrality. Stores "closeness" variable. BUGGED! MIGHT NOT WORK WITH SOME NETWORKS.{p_end}

{p2coldent : {opt eigenval}}Eigenvalue centrality. Stores "eigenval" variable.{p_end}

{p2coldent : {opt eigenvec}}Eigenvector centrality. Stores "eigenvec" variable.{p_end}

{p2coldent : {opt katz}}Katz centrality. Stores "katz" variable.{p_end}

{p2coldent : {opt pagerank}}Google's Pagerank algorithm. Stores "pagerank" variable. BUGGED! MIGHT NOT WORK WITH SOME NETWORKS.{p_end}

{p2coldent : {opt hits}}Hyperlink-Induced Topic Search (HITS) algorithm which returns "hub" and "authority" variables.{p_end}

{p 4 4 2}
{it:{ul:Network parameters}}

{p2coldent : {opt iter(num)}}Number of iterations. Default is {opt iter(100)}.{p_end}

{p2coldent : {opt tol:erance(num)}}Tolerance level for convergence. Default is {opt tol(1-e6)}.{p_end}

{p2coldent : {opt radius(num)}}Radius for the "star" layout. Default is {opt radius(5)}.{p_end}


{p 4 4 2}
{it:{ul:Network layouts}}

{p 4 4 2}
Users can chose from the following layout options:

{p2coldent : {opt layout(star)}}Star layout. Everything is in a circle. Default layout.{p_end}

{p2coldent : {opt layout(fr)}}Fruchterman-Reingold layout. A force-directed layout algorithm. Strength of ties determine repulsion and attraction.{p_end}

{p2coldent : {opt layout(sphere)}}Layout the nodes on a sphere. The z-dimension is also returned but dropped for now. 
BUGGED! END CATEGORIES ARE DRAWN IN THE MIDDLE IN SOME NETWORKS.{p_end}


{p 4 4 2}
{it:{ul:Link parameters}}

{p2coldent : {opt lcat:s(num)}}Link width categories determined by {it:num} percentiles. Default is {opt lcats(10)}.{p_end}

{p2coldent : {opt lw:idth(num)}}Link width multiplier. Default is {opt lw(1)}.{p_end}

{p2coldent : {opt la:lpha(num)}}Transparency of the links. Default is {opt la(80)}.{p_end}

{p2coldent : {opt reduce(num)}}The amount of length of links to reduce defined in pixels. Default is {opt reduce(0)}.{p_end}


{p 4 4 2}
{it:{ul:Node or marker parameters}}

{p2coldent : {opt mcat:s(num)}}Marker size categories determined by {it:num} percentiles. Default is {opt mcats(10)}.{p_end}

{p2coldent : {opt mvar(str)}}The variable for determining the size of the markers. This can be any returned variable defined above.
Default is {opt mvar(between)} which is always returned.{p_end}

{p2coldent : {opt ms:ize(str)}}The size multiplier of the markers. Default is {opt ms(3)}.{p_end}

{p2coldent : {opt ma:lpha(num)}}Transparency of the nodes. Default is {opt ma(80)}.{p_end}

{p2coldent : {opt msym:bol(num)}}Symbol of the nodes. Default is {opt msym(circle)}.{p_end}

{p 4 4 2}
{it:{ul:Additional options}}

{p2coldent : {opt palette(str)}}Any valid palette in the colorpalette package. Default is {opt palette(tableau)}.{p_end}

{p2coldent : {opt nograph}}Do no draw the graph.{p_end}

{p2coldent : {opt savedata}}Export the graph file with the drawing coordinates and network measures.
Default name is {it:_network.dta}. The file will be saved in the set directory.{p_end}

{p2coldent : {opt saveprefix(str)}}Add a prefix to the exported file: {it:(prefix)_network.dta}.{p_end}

{title:Dependencies}

The {browse "http://repec.sowi.unibe.ch/stata/palettes/index.html":palette} package (Jann 2018, 2022) is required for {cmd:network}:

{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}

Even if you have these installed, it is highly recommended to update the dependencies:
{stata ado update, update}

{title:Examples}

See {browse "https://github.com/asjadnaqvi/stata-network":GitHub} for examples.


{title:Version history}

- {bf:1.0}: Beta release.


{title:Package details}

Version      : {bf:network} v1.0 (beta)
This release : 17 Oct 2023
First release: 17 Oct 2023
Repository   : {browse "https://github.com/asjadnaqvi/network":GitHub}
Keywords     : Stata, networks, graphs, measures
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}


{title:How to cite this package}

{p 4 8 2}Naqvi, A. (2023). network v1.0: A Stata package for network analysis. {browse "https://github.com/asjadnaqvi/stata-network":https://github.com/asjadnaqvi/stata-network}.


{title:Feedback and issues}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-joyplot/issues":GitHub} by opening a new issue.


{title:References}

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.

{p 4 8 2}Jann, B. (2022). {browse "https://ideas.repec.org/p/bss/wpaper/43.html":Color palettes for Stata graphics: An update}. University of Bern Social Sciences Working Papers No. 43. 


{title:Other visualization packages}

{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb joyplot}, 
	{helpb marimekko}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb streamplot}, {helpb sunburst}, {helpb treecluster}, {helpb treemap}

