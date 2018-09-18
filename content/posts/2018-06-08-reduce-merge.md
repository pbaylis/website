---
layout: post
title:  "Things I forget: Reduce merge"
date:   2018-06-01
categories: 
  - programming
tags:
  - R
  - "things I forget"
---

I always forget how to run a reduce merge.

```r
Reduce(function(x, y) merge(x, y, all=TRUE), list(df1, df2, df3))
# OR #
Reduce(function(...) merge(..., all=TRUE), list(df1, df2, df3))
```

Sources: [SO 1](https://stackoverflow.com/questions/14096814/merging-a-lot-of-data-frames), [SO 2](https://stackoverflow.com/questions/2209258/merge-several-data-frames-into-one-data-frame-with-a-loop), [Performance of merge](https://stackoverflow.com/questions/4322219/whats-the-fastest-way-to-merge-join-data-frames-in-r/4483202?noredirect=1#comment39346690_4483202)
