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

Sometimes RStudio Server takes too long to load, or errors out. This is the easiest way I've found to blow it up and restart (note that unsaved files won't be saved, obviously):

```bash
rm -rf ~/.rstudio
rstudio-server kill-all
```

Related note: It's a good idea to turn off workspace saving and reloading of `.RData` when using RStudio server.
