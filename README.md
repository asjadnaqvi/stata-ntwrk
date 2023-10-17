
![network](https://github.com/asjadnaqvi/stata-network/assets/38498046/4d2b8476-4616-4586-9908-fac24c425695)

![StataMin](https://img.shields.io/badge/stata-2015-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-network) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-network) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-network) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-network) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-network)

---

[Installation](#Installation) | [Syntax](#Syntax) | [Examples](#Examples) | [Feedback](#Feedback) | [Change log](#Change-log)

---

# network v1.0 (beta)
(17 Oct 2023)

This package allows users to draw network plots in Stata. The package is still beta is constantly being updated. Please continue to check here for newer versions. Please also feel free to submit requests in the Issues section.


## Installation

The package can be installed via SSC or GitHub. The GitHub version, *might* be more recent due to bug fixes, feature updates etc, and *may* contain syntax improvements and changes in *default* values. See version numbers below. Eventually the GitHub version is published on SSC.

SSC (** **):

```
coming soon
```

GitHub (**v1.0**):

```
net install network, from("https://raw.githubusercontent.com/asjadnaqvi/stata-network/main/installation/") replace
```



The `palettes` package is required to run this command:

```
ssc install palettes, replace
ssc install colrspace, replace
```

Even if you have these packages installed, please check for updates: `ado update, update`.

If you want to make a clean figure, then it is advisable to load a clean scheme. These are several available and I personally use the following:

```
ssc install schemepack, replace
set scheme white_tableau  
```

You can also push the scheme directly into the graph using the `scheme(schemename)` option. See the help file for details or the example below.

I also prefer narrow fonts in figures with long labels. You can change this as follows:

```
graph set window fontface "Arial Narrow"
```


## Syntax

The syntax for the latest version is as follows:

```applescript
        network from to value [if] [in] [, degree indegree outdegree between closeness eigenval eigenvec katz pagerank hits iterations(num)
               tolerance(num) layout(star|fr|sphere) lcats(num) ncats(num) nvar(string) ]
```

See the help file `help network` for details.

The command expects an edge list as an input:

```
network from to value [, network measures] [layout measures]
```





## Examples

Get the example data from GitHub:

```
use "https://github.com/asjadnaqvi/stata-network/blob/main/data/trade_data.dta", clear first
```

Let's test the `network` command:


```
network ex_iso2 im_iso2 value if value > 50000
```

<img src="/figures/network1.png" height="500">

```
network ex_iso2 im_iso2 value if value > 50000, layout(sphere) 
```

<img src="/figures/network2.png" height="500">

```
network ex_iso2 im_iso2 value if value > 50000, layout(sphere) mvar(degree) 
```

<img src="/figures/network3.png" height="500">

```
network ex_iso2 im_iso2 value if value > 50000, layout(sphere) mvar(degree) msize(1.6) mcat(10)
```

<img src="/figures/network4.png" height="500">

```
network ex_iso2 im_iso2 value if value > 50000, layout(sphere) ///
	mvar(degree) msize(1.6) mcat(10) lcat(15) lw(0.6)
```

<img src="/figures/network5.png" height="500">

```
network ex_iso2 im_iso2 value if value > 50000, layout(star) ///
	mvar(degree) msize(1.3) mcat(10) lcat(15) lw(0.6)	
```

<img src="/figures/network6.png" height="500">

```
network ex_iso2 im_iso2 value if value > 50000, layout(fr) ///
	mvar(degree) msize(1.3) mcat(10) lcat(15) lw(0.6)
```

<img src="/figures/network7.png" height="500">

```
network ex_iso2 im_iso2 value if value > 50000, layout(fr) ///
	mvar(degree) msize(1.3) mcat(10) lcat(15) lw(0.6) ///
	malpha(90) lalpha(50)
```

<img src="/figures/network8.png" height="500">

```
network ex_iso2 im_iso2 value if value > 50000, layout(fr) ///
	mvar(degree) msize(1.3) mcat(10) lcat(15) lw(0.6) ///
	malpha(90) lalpha(50)	
```

<img src="/figures/network9.png" height="500">

```
network ex_iso2 im_iso2 value if value > 50000, ///
	indegree outdegree katz closeness eigenval eigenvec hits ///
	layout(fr) mvar(indegree) msize(1.3)  lw(0.6) ///
	malpha(90) lalpha(50)	
```

<img src="/figures/network10.png" height="500">

```
network ex_iso2 im_iso2 value if value > 50000, ///
	indegree outdegree katz closeness eigenval eigenvec hits ///
	layout(star) mvar(indegree) msize(1.3)  lw(0.6) ///
	malpha(90) lalpha(50) reduce(0.5)	
```

<img src="/figures/network11.png" height="500">


### Exporting the data

We can export the layout and measures using the following options:

```
network ex_iso2 im_iso2 value if value > 50000, indegree outdegree between katz closeness eigenval eigenvec hits  ///
	savedata layout(fr) nograph
```

Here we export a file that can be loaded and customized:

```
use _network.dta	
```




## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-network/issues) to report errors, feature enhancements, and/or other requests.


## Change log

**v1.0 (17 Oct 2023)**
- Beta release.







