---
layout: post
title:  "Dealing with a lack of support in fixed effect-dummy variable combinations"
date:   2017-02-03
draft: true
categories:
  - econometrics 
tags: 
  - r
publish: false
---

_Update (May 2018): I think this is mostly dumb and produced by my own confusion. Disregard._

Suppose we want to estimate the effect of, say, binned temperature \\( T_1, T_2, T_3 \\) on an outcome \\( y \\), but we suspect that there are different effects in different regions \\( R_a, R_b \\). Because we want to test if the effects are statistically different by region, we'd prefer to do this in the same regression. Here's the regression model we would run:

$$ y_i = \alpha + \beta_1 R_{bi} + \beta_2 T_{1i} + \beta_3 T_{3i} + \beta_4 [R_b \times T_1]_i + \beta_5 [R_b \times T_3]_i + \varepsilon_i $$

Note that \\( T_2 \\) and \\( R_a \\) are the omitted categories. If we have observations for every combination of region and temperature, here's how we would interpret our results:

Interpretations:
  - \\( R_a \times T_1 \\): \\( \alpha + \beta_2 \\)
  - \\( R_a \times T_2 \\): \\( \alpha \\)
  - \\( R_a \times T_3 \\): \\( \alpha + \beta_3 \\)
  - \\( R_b \times T_1 \\): \\( \alpha + \beta_1 + \beta_2 + \beta_4 \\)
  - \\( R_b \times T_2 \\): \\( \alpha + \beta_1 \\)
  - \\( R_b \times T_3 \\): \\( \alpha + \beta_1 + \beta_3 + \beta_5 \\)

But suppose the were no moderate temperature days (\\( T_2 \\)) in \\( R_b \\). Can we run this regression using a dataset that looks like this?

| \\( y \\) | \\( \alpha \\) | \\( R_b \\) | \\( T_1 \\) | \\( T_3 \\) | \\( R_b \times T_1 \\) | \\( R_b \times T_3 \\) |
|:-:|:---:|:---:|:---:|:---:|:---------:|:---------:|
| 1 |  1| 0  |  1  |  0  |     0     |     0     |
| 8 |  1| 0  |  0  |  0  |     0     |     0     |
| 1 |  1| 0  |  0  |  1  |     0     |     0     |
| 9 |  1| 1  |  1  |  0  |     1     |     0     |
| -3 |  1| 1  |  0  |  1  |     0     |     1     |

Well, yes, but we should be careful.  This makes \\( R_b \\) colinear with the sum of \\( R_b \times T_1 \\) and \\( R_b \times T_3 \\), which means that R or Stata will drop one the three.

Suppose it drops \\( R_b \\):

Then we have the following regression model:

$$ y_i = \alpha + \beta_2 T_{1i} + \beta_3 T_{3i} + \beta_5 [R_b \times T_3]_i + \varepsilon_i $$

And the following interpretations have changed:
  - \\( R_b \times T_1 \\): \\( \alpha + \beta_2 + \beta_4 \\)
  - \\( R_b \times T_2 \\): NA
  - \\( R_b \times T_3 \\): \\( \alpha + \beta_3 + \beta_5 \\)

Different things happen if the other variables were dropped. Ultimately, the fix here is to just ignore coefficients which don't appear in the final model when summing up. Actually less complicated than I thought. Still, another solution is to either limit bins so that they include all region-temperature combinations (unrealistic in my use case, since my "regions" are actually seasons) or to implement a splined model or something similar.

---

Another puzzle I haven't figured out. If I estimate a model with fixed effects that take out the level of, say, region, can I still plot compare response functions for different regions? I mean... all \\( \beta_1 \\) introduces is a mean shift.
