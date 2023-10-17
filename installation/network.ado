*! network v1.0 (beta)
*! Asjad Naqvi (asjadnaqvi@gmail.com, @AsjadNaqvi)


*** Source of most of the routines are from:
* R: 	  https://igraph.org/
* Python: https://networkx.org/


** TODO:
** closeness failing with isolates
** pagerank failing for some networks


cap prog drop network

prog def network, sortpreserve

	version 15
	
	syntax varlist(min = 3 max = 3) [if] [in] ,  	 												///     // from, to, value
		[ between indegree outdegree closeness eigenval eigenvec katz pagerank hits	] 	///  	// node measures
		[ ITERations(real 100) TOLerance(real 1e-6) radius(real 5) ]   										///		// common parameters
		[ layout(string)                            ] 											///		// draw the graphs
		[ LCATs(real 10) LWidth(real 1) LAlpha(real 80) reduce(real 0)   ] 					///		// link options
		[ MCATs(real 10) mvar(string) MSize(string) MAlpha(real 80) MSYMbol(string)   	]			///									// node options
		[ savedata saveprefix(string) NOGRaph palette(string) ]      // saving options

		
	// check dependencies
	cap findfile colorpalette.ado
	if _rc != 0 {
		display as error "The palettes package is missing. Install the {stata ssc install palettes, replace:palettes} and {stata ssc install colrspace, replace:colrspace} packages."
		exit
	}		
	
	if !inlist("`layout'", "", "star", "fr", "sphere") {
		di as error "Valid options for {opt layout()} are {it:star}, {it:fr}, or {it:sphere}."
		exit
	}
		
		
	marksample touse, strok	
	
	
	tokenize "`varlist'"
	
	local f `1'  // from
	local t `2'  // to 
	local v `3'  // value
	
	
	
	
preserve
	qui {	
	// store original information in a copy
	
		
		tempfile _network_copy
		qui keep if `touse'
		collapse (sum) `v', by(`f' `t')  // ensure uniqueness
		compress
		save `_network_copy'
	

	// make sure variables are numeric
	if (substr("`: type `f''",1,3) == "str") & (substr("`: type `t''",1,3) == "str") { 
	
		// numerify the string variables	
		tempvar _numerify
		keep `f' `t'
		cap ren `f'	_v1
		cap ren `t' _v2
		gen serial = _n
		reshape long _v, i(serial) j(layer)
		cap drop layer serial
		duplicates drop _v, force
		sort _v
		encode _v, gen(_vnum)
		save `_numerify', replace
		

		// swap from
		use `_network_copy', clear
		ren `f' _v
		merge m:1 _v using `_numerify'
		keep if _m==3
		drop _m _v
		ren _vnum `f'
		
		// swap to
		ren `t' _v
		merge m:1 _v using `_numerify'
		keep if _m==3
		drop _m _v
		ren _vnum `t'

		order `f' `t'
	}

	
	save `_network_copy', replace

	****** pass to Mata
	mata: points = st_data(., ("`varlist'")); square = square(points); binary = binary(square)
	
	
	// prepare a matrix for storing results
	mata: exports = J(rows(binary), 0, .); mylist = ""
	
	
	// degree is always returned
		mata: degree     = degree(binary)
		mata: exports 	= exports , degree
		mata: mylist = mylist + " degree"
		mata: st_local("header", mylist)
	
	
	
	if "`between'"   != "" {
		mata: between    = between(binary)
		mata: exports 	= exports , between
		mata: mylist = mylist + " between"
		mata: st_local("header", mylist)
	}

	
	if "`indegree'"  != "" {
		mata: indegree   = indegree(binary)
		mata: exports 	= exports , indegree
		mata: mylist = mylist + " indegree"
		mata: st_local("header", mylist)		
	}
	

	if "`outdegree'" != "" {
		mata: outdegree  = outdegree(binary)
		mata: exports 	= exports , outdegree
		mata: mylist = mylist + " outdegree"
		mata: st_local("header", mylist)		
	}	
	

	if "`closeness'" != "" {
		mata: closeness  = closeness_centrality(binary)
		mata: exports 	= exports , closeness
		mata: mylist = mylist + " closeness"
		mata: st_local("header", mylist)			
	}

	
	if "`eigenval'"  != "" {
		mata: eigenval   = eigenvalue_centrality(binary, `iterations', `tolerance')
		mata: exports 	= exports , eigenval
		mata: mylist = mylist + " eigenval"
		mata: st_local("header", mylist)			
	}	
		
		
	if "`eigenvec'"  != "" {
		mata: eigenvec  = eigenvectorcent(binary)
		mata: exports 	= exports , eigenvec
		mata: mylist    = mylist + " eigenvec"
		mata: st_local("header", mylist)			
	}
	
		
	if "`katz'" 	 != "" {
		mata: katz  	= katz_centrality(binary, 0.1, 1)
		mata: exports   = exports , katz
		mata: mylist    = mylist + " katz"
		mata: st_local("header", mylist)		
	}
	
	
	if "`pagerank'"  != "" {
		mata: pagerank  = pagerank(binary, 0.85, `iterations', `tolerance')
		mata: exports 	= exports , pagerank
		mata: mylist    = mylist + " pagerank"
		mata: st_local("header", mylist)			
	}

	
	if "`hits'"  	 != "" {
		mata: hits(binary, `iterations', `tolerance', hub=., authority=.)
		mata: exports 	= exports , hub, authority
		mata: mylist = mylist + " hub authority"
		mata: st_local("header", mylist)		
	}



	*****************************
	*****      layouts		*****
	*****************************

	
	tempfile _layout_nodes
	
	
	drop `v'
	duplicates drop `f' `t', force  // reduce 1
	
	gen id = _n
	
	cap ren `f' _id1
	cap ren `t' _id2
	reshape long _id, i(id) j(node)
	duplicates drop _id, force  // reduce 2
	cap drop id node
	sort _id
	
	
	
	if "`layout'" == "star" | "`layout'"== "" {
		gen double angle = (_n * 2 * -_pi / _N)
		gen double _x = `radius' * cos(angle)
		gen double _y = `radius' * sin(angle)
		
	}
	
	
	if "`layout'" == "fr" {
		mata: positions = fr_layout(binary, 1000, 20, 20 )
		mata: st_matrix("positions", positions)
		mat colnames positions = "_check" "_x" "_y"
		svmat positions, n(col)
	}
	
	
	if "`layout'" == "sphere" {
		mata: sphere = layout_sphere(binary)
		mata: st_matrix("sphere", sphere)
		mat colnames sphere = "_check" "_x" "_y" "_z"
		svmat sphere, n(col)
		cap drop _z
	}	

	keep _id _x _y
	sort _id	
	compress

	save `_layout_nodes'
	
	
	*******************************
	*** get the links in order  ***
	*******************************
	
	use `_network_copy', clear
	
	cap ren `f' _id

	merge m:1 _id using `_layout_nodes'
	keep if _m==3
	cap drop _m
	cap ren _x _fx
	cap ren _y _fy

	cap ren _id `f'
	cap ren `t' _id

	merge m:1 _id using `_layout_nodes'
	keep if _m==3
	cap drop _m
	cap ren _x _tx
	cap ren _y _ty
	cap ren _id `t'

	gen _control = 0

	// replace own flows
	gen _ownflow = `f'==`t'
	
	
	// reduce the length of the links by  r    
	
	
	
	tempvar dx dy p1x p1y p2x p2y L rate
	gen double `p1x' = _fx
	gen double `p1y' = _fy
	
	gen double `p2x' = _tx
	gen double `p2y' = _ty
	
	
	// reduce by x% points
	/*
	local r2 = ((100 - `reduce') / 100) / 2
	
	replace _fx = ((1 - `r2') * `p2x') + (`r2' * `p1x')
	replace _fy = ((1 - `r2') * `p2y') + (`r2' * `p1y')
	replace _tx = ((1 - `r2') * `p1x') + (`r2' * `p2x')
	replace _ty = ((1 - `r2') * `p1y') + (`r2' * `p2y')	
	*/
	
	
	// reduce by a fixed length
	gen double `dx' = `p2x' - `p1x'
	gen double `dy' = `p2y' - `p1y'
	
	gen double `L' = sqrt((`p2x' - `p1x')^2 + (`p2y' - `p1y')^2)  // hypotenuse
	local deltaL   = `reduce'
	gen double `rate' = `deltaL' / `L'
	
	
	replace _fx = ((1 - `rate') * `p2x') + (`rate' * `p1x')
	replace _fy = ((1 - `rate') * `p2y') + (`rate' * `p1y')
	replace _tx = ((1 - `rate') * `p1x') + (`rate' * `p2x')
	replace _ty = ((1 - `rate') * `p1y') + (`rate' * `p2y')		
	
	
	drop `dx' `dy' `p1x' `p1y' `p2x' `p2y' `L' `rate'
	
	save `_network_copy', replace
	
	// add the nodes with attributes 
	
	// add node attributes back to Stata
		use `_layout_nodes', clear
		mata st_matrix("exports", exports)
		mat colnames exports = `header'
		svmat exports, n(col)
		save `_layout_nodes', replace
	

	
	// add node data
	use  `_network_copy', replace
	append using `_layout_nodes'
	recode _control (.=1)

	sort _control _id
	
	lab de _control 0 "Links" 1 "Nodes"
	lab val _control _control
	

	************
	*** plot ***
	************

	if "`nograph'" != "" {
		local graph ""
	}
	else {
		local graph "graph"
	}
	
	if "`graph'" != "" {
		
		***** weight the links
		xtile lquant = `v', n(`lcats')   // tokenize
		
		if "`palette'" == "" local palette tableau
		
		colorpalette `palette', nograph
		
		local clr1 "`r(p1)'"
		local clr2 "`r(p2)'"
		
		// weighted lines
		levelsof lquant, local(lvls)
		
		foreach x of local lvls {
			local lwgt = (sqrt(`x' * 2) / 3) * `lwidth'
			
			local arrows `arrows' (pcarrow _fy _fx _ty _tx if !_ownflow & lquant==`x', msize(small) lw(`lwgt') lc("`clr1'%`lalpha'") mc("`clr1'%`lalpha'")  )  ||
			
		}
	
		
		// weighted nodes
		
		***** weight the nodes
		if "`mvar'" 	!= "" xtile mquant = `mvar', n(`mcats')
		if "`msymbol'" 	== "" local msymbol circle	
		if "`msize'"    == "" local msize   3	

		
		if "`mvar'" 	!= "" {
		
			levelsof mquant, local(lvls)
			
			foreach x of local lvls {
				local mwgt = (sqrt(`x' * 2) * `msize')
				
				local dots `dots' (scatter _y _x if _control & mquant==`x'	, msymbol("`msymbol'") mlabpos(0) mcolor("`clr2'%`malpha'") mlab(_id) msize(`mwgt')   ) 
				
			}
		}
		else {
				local dots 		  (scatter _y _x if _control   				, msymbol("`msymbol'") mlabpos(0) mcolor("`clr2'%`malpha'") mlab(_id) msize(`msize')    )
			
			
		}
	
	
	
		// final plot
	
	
	
	
		twoway ///
			`arrows'   /// 
			`dots'   /// 
			, ///
			legend(off) ///
				xscale(off) yscale(off)	///
				xlabel(, nogrid) ylabel(, nogrid) ///
				aspect(1) xsize(1) ysize(1) 
				
	}
	
	
	**************
	*** export ***
	**************
	
	if "`savedata'" != "" {
		compress 
		cap drop _check
		order _control
		save "`saveprefix'_network.dta", replace
		noi di in yellow "File `saveprefix'_network.dta sucessfully exported."
	}
	

	}
	
	
restore	
	
end


*************************************************
*********	 Mata routines below 	   **********
*************************************************


*************************
// 	   square a list   //  
*************************

cap mata mata drop square()

mata:
real matrix square(real matrix X)
	{

		real scalar maxsize
		real matrix sqr
	
		maxsize = max(uniqrows(vec(X[.,1::2])))
		sqr =  J(maxsize, maxsize, .)

		for ( i=1; i<=maxsize; i++) {
		 	for ( j=1; j<=maxsize; j++) {
		 		sqr[i,j] = min(select(X[.,3], (X[.,1] :== i :& X[.,2] :== j)))
		 	}
		}

		sqr = editmissing(sqr, 0)
		return (sqr)
	}
end

*************************
// 	  binary matrix    //  
*************************

cap mata mata drop binary()

mata:
real matrix binary(real matrix X)
	{
	return (X :> 0)
	}
end


*** betweenness centrality: from NW commands



***************
// dequeue   //  // stacking function from nwcommands
***************

capture mata: mata drop dequeue()

mata:

real scalar function dequeue(real vector A)
{
	a = A[1]
	for (i=1; i < cols(A); i++) { 
		A[i] = A[i+1]
	}
	if (cols(A) == 1) { 
		A = J(1,0,.)
	}
	else {
		A = A[1..cols(A) - 1]
	}
	return (a)
}

end

****************
//  between   //  //  from nwcommands. 
****************


capture mata: mata drop between()

mata:

real vector between(real matrix A)
{

	adjacencyList = J(rows(A), rows(A) - 1, .)
	
	for (m=1; m<=rows(A); m++) {
		k = 1
		for ( n=1; n<=rows(A); n++) {
			if ( m!=n & A[m,n]>0) adjacencyList[m, k++] = n
		}
    }
	
	betcen = J(1, rows(A),0)
	for (s=1; s<=rows(A); s++) {
		Stack = J(1,0,.)
		P     = J(rows(A),rows(A),.)
		nP    = J(rows(A),1,1)
		S     = J(1,rows(A),0)
		S[s]  = 1
		D     = J(1,rows(A),-1)
		D[s]  = 0
		Queue = J(1,0,.)
		Queue = (cols(Queue) ? Queue, s : s)
		
		while (cols(Queue)) {
			v 		= dequeue(Queue)
			Stack 	= (cols(Stack)? v,Stack : v)
			
			for (j=1; j<=sum(adjacencyList[v,.] :< .); j++) {
				
				w = adjacencyList[v,j]
				if (D[w] < 0) {
					Queue = (cols(Queue) ? Queue, w : w)
					D[w] = D[v] + 1
				}
				if (D[w] == D[v] + 1) {
					S[w]        = S[w] + S[v]
					P[w, nP[w]] = v;
					nP[w]       = nP[w]+1
				}     
			}	
		}
		
		Dd = J(1,rows(A),0)
		
		while (cols(Stack)) {
			w = dequeue(Stack)
  
			for (j=1; j<nP[w]; j++) {
				v     = P[w,j]
				Dd[v] = Dd[v] + (S[v] / S[w]) * (1 + Dd[w])
			}
			if (w != s) betcen[w] = betcen[w] + Dd[w]
		}
	}
	return (betcen')
}
end


////////////////////////
// undirected degree  //
////////////////////////

cap mata: mata drop degree()

mata:
real vector degree(real matrix X) {
    num 	= rows(X)
    degree 	= J(num, 1, 0)
	
	for (i=1; i<=num; i++) { 
        degree[i] = colsum(X[.,i]) +  colsum(X'[.,i])   // indegree + outdegree
    }
    return (degree)
}
end

////////////////////////
// 		indegree  	  //
////////////////////////

cap mata: mata drop indegree()

mata:
real vector indegree(real matrix X) {
    num 		= rows(X)
    indegree 	= J(num, 1, 0)
	
	for (i=1; i<=num; i++) { 
        indegree[i] = colsum(X[.,i]) 
    }
    return (indegree)
}
end



cap mata: mata drop outdegree()

mata:
real vector outdegree(real matrix X) {
    num 		= rows(X)
    outdegree 	= J(num, 1, 0)
	
	for (i=1; i<=num; i++) { 
        outdegree[i] = colsum(X'[.,i]) 
    }
    return (outdegree)
}
end


////////////////////////////////////
// 		closeness centrality  	  //  // failing for dangling nodes.
////////////////////////////////////


cap mata: mata drop BFS()    // Breadth-First Search algorithm: https://en.wikipedia.org/wiki/Breadth-first_search

mata:

real vector BFS(real matrix G, real scalar source) 
{
    real scalar N, level
    real vector seen, dists
    real matrix thislevel, nextlevel

    N = rows(G)
    seen  = J(N, 1, .)  // Initialize with missing values
    dists = J(N, 1, .) // Distances initialized to missing
    level = 0
    thislevel = J(N, 1, 0)
    nextlevel = J(N, 1, 0)
    nextlevel[source] = 1

    while (sum(nextlevel) > 0) {
        thislevel = nextlevel
        nextlevel = J(N, 1, 0)

        for (i=1; i<=N; i++) {
            if (thislevel[i] == 1 & missing(seen[i])) {
                seen[i]  = 1
                dists[i] = level
                for (j=1; j<=N; j++) {
                    if (G[i,j] == 1 & missing(seen[j])) {
                        nextlevel[j] = 1
                    }
                }
            }
        }
        level++
    }
    return (dists)
}
end

cap mata: mata drop closeness_centrality()  

mata:
real vector closeness_centrality(real matrix G) {

    real matrix closeness, bfs_lengths

    N = rows(G)
    closeness = J(N, 1, .)

    for (i=1; i<=N; i++) {
        sp_lengths = BFS(G, i)
        closeness[i] = (N - 1) / sum(bfs_lengths)
    }

	// editmissing(closeness, 0)
	
    return (closeness)
}
end

////////////////////////////////////
// 		eigenvalue centrality  	  //
////////////////////////////////////


cap mata: mata drop eigenvalue_centrality()

 
mata:
real vector eigenvalue_centrality(real matrix G, real scalar max_iter, real scalar tol) {

    real vector x, x_new

    N = rows(G)
    x = J(N, 1, 1) // Initialize with equal values
    x = x :/ sqrt(rowsum(x:^2)) // Normalize

    for (i=1; i<=max_iter; i++) {
        x_new = G * x
		
        x_new = x_new :/ sqrt(colsum(x_new :^ 2)) // Normalize

        // Check convergence
        diff = sqrt(colsum((x_new :- x):^2))
        if (diff < tol) break

        x = x_new
    }

    return (x)
}

end

////////////////////////////////////
// 		eigenvector centrality    //   // check. Not so sure about this.
////////////////////////////////////

cap mata: mata drop eigenvectorcent() 
 
mata: 
 
    real vector eigenvectorcent(real matrix A)
    {
        symeigensystem(A, X=., L=.)  // symeigensystem is for real eigen vectors
        eigenvectorcentrality = X[.,1] / sum(X[.,1]) // Normalize to 1

		return (eigenvectorcentrality)
    }
end

////////////////////////////////
// 		katz centrality  	  //
////////////////////////////////

cap mata: mata drop katz_centrality() 
 
mata: 
 
real vector katz_centrality(real matrix G, real scalar alpha, real scalar beta)   // alpha and beta are open parameters
{
    katz = beta * luinv(I(rows(G)) - alpha * G) * J(rows(G), 1, 1)
    return (katz)
}

end

////////////////////////////////
// 		pagerank              //  // need more testing for dangling node: out degree = 0
////////////////////////////////

cap mata: mata drop pagerank() 
 
mata: 
 
real matrix pagerank(real matrix G, real scalar alpha, real scalar max_iter, real scalar tol)
{
    real scalar iter, n, nbr, wt, N
	real matrix W, x, p, dangling_weights, dangling_nodes, xlast, danglesum
    
    N = rows(G)
	W = G
	
    W =  W :/ rowsum(W)
	
	   // Identify dangling nodes (nodes without outgoing links)
	dangling_nodes = selectindex(rowsum(W) :== 0)

	
	W = editmissing(W, 1/N) // give equal probability to dangling nodes. THIS NEEDS TO BE CHECKED!!
		

	x = J(N, 1, 1/N)  // Initialize PR vector with equal probability
	p = J(N, 1, 1/N)  // Initialize personalization vector


	dangling_weights = p // Initialize dangling_weights
	


	
	// Power iteration
    for (iter=1; iter<=max_iter; iter++) {
        xlast = x
         x = J(N, 1, 0)

		danglesum = alpha * sum(xlast[dangling_nodes])

        for (n=1; n<=N; n++) {
            for (nbr=1; nbr<=N; nbr++) {
                
				if (W[n, nbr] != 0) {
                    wt = W[n, nbr]
					x[nbr] = x[nbr] + alpha * xlast[n] * wt

                }
            }
			
            x[n] = x[n] + danglesum * dangling_weights[n] + (1 - alpha) * p[n]

        }

		if (sum(abs(x - xlast)) < (N * tol)) {
			return (x)
        }
    }

}
end


/////////////////////
// 		HITS       //
/////////////////////

cap mata: mata drop hits() 
 
mata: 
 
// Define the HITS function
    void hits(real matrix A, real scalar max_iter, real scalar tol, real vector hub, real vector aut)
    {
        real matrix prev_a, prev_h

        // Initialize authority and hub scores to 1
        aut = J(rows(A), 1, 1)
        hub = J(rows(A), 1, 1)

        i = 0
        diff_a = tol + 1
        diff_h = tol + 1
        
        while ((diff_a > tol | diff_h > tol) & i < max_iter) {
            
			// Save previous scores for convergence check
            prev_a = aut
            prev_h = hub

            // Update authority and hub scores
            aut = A * (A' * hub)
            hub = (A' * aut)

            // Normalize the vectors
            norm_a = sqrt(sum(aut :* aut))
            norm_h = sqrt(sum(hub :* hub))
            aut = aut / norm_a
            hub = hub / norm_h

            // Calculate the differences to check for convergence
            diff_a = max(abs(aut - prev_a))
            diff_h = max(abs(hub - prev_h))

            i++
        }

    }
end


***************************************************
**************** layout algorithms ****************
***************************************************

*** Fruchterman-Reingold algorithm

cap mata: mata drop fr_layout() 
 
mata: 
 
real matrix fr_layout(real matrix A, real scalar iterations, real scalar width, real scalar height)
{
    real matrix pos, disp, delta, force, distance, unit_delta
    real scalar k, t, area
    
    n = rows(A)
    pos = runiform(n, 2) :* (width, height) // initial random positions
    
	
    area = width * height
    k = sqrt(area/n)
    t = width/10

	
    for (iter=1; iter<=iterations; iter++) {
        disp = J(n, 2, 0)
        
        // Calculate repulsive forces
        for (i=1; i<=n; i++) {
            for (j=i+1; j<=n; j++) {
                delta = pos[i,.] - pos[j,.]
                distance = sqrt(delta*delta')
                
				
                if (distance > 0) {
                    force = (k^2 / distance) * delta / distance
                    disp[i,.] = disp[i,.] + force
                    disp[j,.] = disp[j,.] - force
                }
            }
        }
		
        
        // Calculate attractive forces
        for (i=1; i<=n; i++) {
            for (j=i+1; j<=n; j++) {
                
				if (A[i,j] | A[j,i]) {
                    delta = pos[i,.] - pos[j,.]
                    distance = sqrt(delta*delta')
                    
                    if (distance > 0) {
                        force = (distance^2 / k) * delta / distance
                        disp[i,.] = disp[i,.] - force
                        disp[j,.] = disp[j,.] + force
                    }
                }
            }
        }
        
        // Update positions
		pos = pos + (disp :/ sqrt(disp :*disp)) :* min((t, k))
        
       // Implement a cooling function
        t = cool(t, iter, iterations) 
		index = (1::n)
		
		return (index, pos)	
		
    }
}

end


*** FR cooling function

cap mata: mata drop cool() 

mata:

real scalar cool(real scalar t, real scalar iter, real scalar max_iter)
{
    return (t * (1 - iter/max_iter)) // Linear cooling
}
end



**** sphere ****

cap mata: mata drop layout_sphere() 
 
mata: 


real matrix layout_sphere(real matrix G)
{
	real scalar N, sqrN, phi
	real matrix res
	
	N = rows(G)
	
    sqrN = sqrt(N)
    phi = 0

    res = J(N, 3, .)


    for (i = 1; i <= N; i++) {
       
        if (i == 1) {    // Avoid division by zero or slightly negative 1-z*z
            z = -1
            r = 0
        } 
        else if (i == N) {
            z = 1
            r = 0
        }
        else { // compute z, r, and update phi
            z = -1 + 2 * (i - 1) / (N - 1)
            r = sqrt(1 - z^2)
            phi = phi + 3.6 / (sqrN * r)
        }
        
        // convert to Cartesian coordinates
        x = r * cos(phi)
        y = r * sin(phi)
        
        res[i, 1] = x
        res[i, 2] = y
        res[i, 3] = z
    }
	
	index = (1::N)
	
	return (index, res)
	
}

end



