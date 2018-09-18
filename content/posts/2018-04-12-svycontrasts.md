---
layout: post
title:  "Linear combinations of coefficients in R"
date:   2018-04-12
categories: 
  - econometrics
tags: 
  - r
  - lincom
---

One of the few features I miss from Stata is the very-intuitive `lincom` command. I haven't found an easy equivalent in R, but most of the time I recreate that functionality with `survey::svycontrast`. But, I always forget the syntax.

```R
library(survey)
library(data.table)

N <- 100
dt <- data.table(x1 = rnorm(N), x2 = rnorm(N))
dt[, y := 1 + 3 * x1 - 2 * x2 + rnorm(N, 0, 0.5)]

fit <- lm(y ~ x1 + x2, data = dt)

# Can pass an unnamed vector with the right number of coefficients
svycontrast(fit, c(0, 2, 1))
# Or a named vector with any number of coefficients (as long as the names match)
svycontrast(fit, c("x2" = 1, "x1" = 2))
```
