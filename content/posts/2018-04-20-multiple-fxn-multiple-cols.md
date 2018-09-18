---
layout: post
title:  "r data.table: apply multiple functions to multiple columns"
date:   2018-04-20
categories: 
  - programming
tags:
  - R
  - "data.table"
---

```r
my.summary = function(x) list(mean = mean(x), median = median(x))
DT[, as.list(unlist(lapply(.SD, my.summary))), .SDcols = c('a', 'b')]
```

N.B.: This can be slow for very large datasets -- the `as.list(unlist())` formulation is the culprit. Possible to remove that, set colnames manually, and melt for speed.

[Source](https://stackoverflow.com/questions/29620783/data-table-in-r-apply-multiple-functions-to-multiple-columns)
