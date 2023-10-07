{smcl}
{* 06October2023}{...}
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
- Add support for weighted network measures.
- Add support for matrix or mata networks.
- Add support for labels and string variables.
- Add support for curved egdes.


{marker syntax}{title:Syntax}

{p 8 15 2}
{cmd:network} {it:from to value} [if] [in] {cmd:[}, 
	 {cmd:between} {cmd:degree} {cmd:indegree} {cmd:outdegree} {cmd:closeness} {cmd:eigenval} {cmd:eigenvec} {cmd:katz} {cmd:pagerank} {cmd:hits}
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

{p2coldent : {opt between}}Betweenness centrality.{p_end}

{p2coldent : {opt degree}}Node degree.{p_end}

{p2coldent : {opt indegree}}Node in-degree.{p_end}

{p2coldent : {opt outdegree}}Node our-degree.{p_end}

{p2coldent : {opt closeness}}Closeness centrality.{p_end}

{p2coldent : {opt eigenval}}Eigenvalue centrality.{p_end}

{p2coldent : {opt eigenvec}}Eigenvector centrality.{p_end}

{p2coldent : {opt katz}}Katz centrality.{p_end}

{p2coldent : {opt pagerank}}Google's Pagerank algorithm.{p_end}

{p2coldent : {opt hits}}Hyperlink-Induced Topic Search (HITS) algorithm which returns "hub" and "authority" measures.{p_end}

{p 4 4 2}
{it:{ul:Node parameters}}

{p2coldent : {opt iter(num)}}Number of iterations. Default is {opt iter(100)}.{p_end}

{p2coldent : {opt tol:erance(num)}}Tolerance level for convergence. Default is {opt tol(1-e6)}.{p_end}


{p 4 4 2}
{it:{ul:Network layouts}}

{p 4 4 2}
Users can chose from the following layout options:

{p2coldent : {opt layout(star)}}Star layout. Everything is in a circle. Default layout.{p_end}

{p2coldent : {opt layout(fr)}}Fruchterman-Reingold layout. A force-directed layout algorithm. Strength of ties determine repulsion and attraction.{p_end}

{p2coldent : {opt layout(sphere)}}Layout the nodes on a sphere. The z-dimension is also returned but dropped for now.{p_end}

{p 4 4 2}
{it:{ul:Layout parameters}}

{p2coldent : {opt lcats(num)}}Edge width determined by num percentiles. Default is {opt lcats(5)}.{p_end}

{p2coldent : {opt ncats(num)}}Node sizes determined by num percentiles. Default is {opt ncats(5)}.{p_end}

{p2coldent : {opt nvar(str)}}The variable that determines the node size. This needs to be a valid node-level variable generated from one of 
the network measures. Highly recommended to specify this in the second step after generating the measures.{p_end}


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
This release : 06 Oct 2023
First release: 06 Oct 2023
Repository   : {browse "https://github.com/asjadnaqvi/network":GitHub}
Keywords     : Stata, networks, graphs, measures
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}


{title:How to cite this package}

{p 4 8 2}Naqvi, A. (2023). network v1.0: A Stata package for network analysis. {browse "https://github.com/asjadnaqvi/stata-network":https://github.com/asjadnaqvi/stata-network}.


{title:Acknowledgments}

{p 4 4 2}
The package greatly benefited from.... 



{title:Feedback and issues}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-joyplot/issues":GitHub} by opening a new issue.


{title:References}

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.

{p 4 8 2}Jann, B. (2022). {browse "https://ideas.repec.org/p/bss/wpaper/43.html":Color palettes for Stata graphics: An update}. University of Bern Social Sciences Working Papers No. 43. 


{title:Other visualization packages}

{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb joyplot}, 
	{helpb marimekko}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb streamplot}, {helpb sunburst}, {helpb treecluster}, {helpb treemap}

