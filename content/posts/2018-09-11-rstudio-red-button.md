---
layout: post
title:  "Things I forget: RStudio Server red button"
date:   2018-09-10
categories: 
  - productivity
tags:
  - R
  - RStudio
  - "things I forget"
---

How to blow up Rstudio and restart everything:

```bash
rm -rf ~/.rstudio
rstudio-server kill-all
```

Only do this if you know what you are doing. Or at least feeling pretty bold.

Related note: It's a good idea to turn off workspace saving and reloading of `.RData` when using RStudio server.
