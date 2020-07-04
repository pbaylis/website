---
layout: post
title:  "Conley standard errors and high dimensional fixed effects"
date:   2015-10-12
draft: true
categories:
  - econometrics
tags:
  - spatial
---

_Update (April 2018): This is deprecated, since I no longer use Stata._


For my JMP, I cluster my standard errors two ways, across both geographies and time. During a recent seminar, one of the audience members asked me why I wasn't using spatial standard errors instead, for example those described in [Conley (2008)](http://www.dictionaryofeconomics.com/article?id=pde2008_S000450).

A case where this might matter is as follows: suppose I'm worried about correlated variation in both my left- and right-hand side variables between observations that are near each other (putting aside correlation across time for now since the concept is equivalent). One typical solution, equivalent to what I was using, is to cluster at some geographic level, say by county. If the correlations only occur within each county, then this is sufficient. If, however, observations across county lines are correlated (e.g. [Kansas City](https://goo.gl/maps/1TuZd9icj812), then the standard errors I estimate may be too small. Conley standard errors solve this problem. In fact, one of my advisers, Sol Hsiang, implements these errors for both [Matlab and Stata](http://www.fight-entropy.com/2010/06/standard-error-adjustment-ols-for.html). I also found a [version for R](https://gist.github.com/devmag/f18ec223df7aef78402b), though I haven't tested it.

However, I have a lot of data and multiple dimensions of fixed effects, so I am using Sergio Correia's fantastic [reghdfe](https://github.com/sergiocorreia/reghdfe) Stata package. He is planning to implement Conley standard errors, but hasn't gotten around to it yet. Thiemo Fetzer implements a [solution](http://www.trfetzer.com/conley-spatial-hac-errors-with-fixed-effects/) using both Sol's code, but it uses reg2hdfe (which is similar, but generally slower than reghdfe) and looks complicated.

Instead, I use `hdfe`, which does the demeaning for reghdfe, to partial out my fixed effects. Then I run Sol's code on the demeaned data. I've posted the code without context below, to give an example:

    hdfe afinn_score_std tmean_b*, clear absorb(gridNum statemonth) \\\
        tol(0.001) keepvars(gridNum date lat lng)

    ols_spatial_HAC afinn_score_std tmean_b*, lat(lat) lon(lng) \\\
        time(date) panel(gridNum) distcutoff(16) lagcutoff(7) disp

This appears to be much too slow for my dataset (>2 million obs at different locations, more than a year of daily data). I found an updated version in R from [Thiemo Fetzer again](http://freigeist.devmag.net/economics/936-spatial-temporal-autocorrelation-correction-with-r-conley.html), but this too isn't fast enough for my needs, even though the matrix operations are implemented in C++. I may try to write my own (in Julia?) at some point, but for now the best solution will be to estimate them for a subset of my data.
