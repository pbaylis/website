---
layout: post
title:  "R performance tests"
date:   2017-02-03
categories:
  - programming
tags:
  - R
  - performance
---

_Update (May 2018): Never completed this. I filled it out a bit here. I never really use this date conversion code since it's fairly specific._

### R date conversion speed test (as.IDate vs fast_strptime)

```r
require(data.table)
require(lubridate)

n <- 10000000
x <- rep("2014-01-01", n)

system.time(r1 <- as.IDate(x, format="%Y%m%d"))
system.time(r2 <- as.IDate(parse_date_time(x, orders="%Y%m%d", exact=T)))
system.time(r3 <- as.IDate(fast_strptime(x, format="%Y%m%d")))
```

Winner: `fast_strptime` by a factor of two over the `IDate` parser (which is also the `Date` parser?).

### Pattern matching (grep vs str)
What's the fastest way to match strings? This code compares `grep` to `stri_detect_*` (from the `stringi` package), considering both fixed and regex matching.
```
library(microbenchmark)
library(stringi)
library(ggplot2)

R <- 100000
g <- replicate(R, paste0(sample(c(letters[1:5]," "), 10, replace=TRUE),
                               collapse=""))

m <- microbenchmark(
  grep(" ", g ),
  stri_detect_regex(g, " "),
  grep(" ", g, perl=TRUE),
  grep(" ", g, fixed=TRUE),
  stri_detect_fixed(g, " ")
)
autoplot(m)
```

![png](/assets/img/pattern_matching_benchmark.png)

Results are similar for `gsub`. For a comparison of `stringi` to `stringr`, see [here](https://rud.is/b/2017/02/06/strung-out-on-string-ops-a-brief-comparison-of-stringi-and-stringr/).

See also [here](https://stackoverflow.com/questions/19458724/how-do-i-speed-up-text-searches-in-r) for improving grep performance.

### Read CSV (fread vs read_csv)
I use `fread` (from the `data.table` package) for my day-to-day data munging in R, but occasionally `read_csv` (from the `readr` package) is more useful, for example when CSVs are formatted in a tricky way or when I'd prefer to have dates read in automatically. It's helpful to know what kind of performance tradeoff I'm making. Following code tests timings on reading both character and numeric vectors. Timings in comments in seconds.

```
library(data.table)
library(readr)
library(stringi)

# Create test dataframes
n <- 10000000
df1 <- data.frame(x=stri_rand_strings(n, 5, '[A-Z]'))
df1$x <-as.character(df1$x)
df2 <- data.frame(x=round(rnorm(n), 3))

dt1 <- data.table(df1)
dt2 <- data.table(df2)

system.time(write_csv(df1, "dt1_df.csv")) # 3.8
system.time(write_csv(df2, "dt2_df.csv")) # 3.1
system.time(fwrite(dt1, "dt1_dt.csv")) # 0.6
system.time(fwrite(dt2, "dt2_dt.csv")) # 1.3

system.time(in.df1 <- read_csv("dt1_df.csv")) # 4.9
system.time(in.df2 <- read_csv("dt2_df.csv")) # 2.2
system.time(in.dt1 <- fread("dt1_dt.csv")) # 2.7
system.time(in.dt2 <- fread("dt2_dt.csv")) # 1.0
```
So `data.table` is about three times as fast at writing and two times at fast at reading.

### Write CSV (fwrite vs write_csv)
Unsubstantiated claims: `fwrite` is faster. Not sure what the deal with `write_csv` is.
