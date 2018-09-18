---
layout: post
title:  "Latex tables again"
date:   2018-04-14
categories: 
  - writing
tags:
  - latex
  - stargazer
  - R
---

Some example R code from a real project to produce nice-looking latex tables for binned regressions. Not everything can be automated, but this generates nice-looking labels for a binned regression and a reasonable layout. `baylisR` is needed for this.

```R
# Tables
library(stargazer)
library(data.table)
library(baylisR)

rm(list=ls())

DB <- "~/Dropbox"
# DB <- "/data1/Dropbox"
IN <- file.path(DB, "01_Work/01_Current/01_MoodTemp/02_Data")
IN_GH <- "/home/pbaylis/github/temperature-sentiment/build/input/"
IN_EST <- file.path(DB, "01_Work/01_Current/01_MoodTemp/03_Results/04_Estimates")
OUT <- file.path("/home/pbaylis/github/temperature-sentiment/analysis/output")
OUT_PROD <- file.path("/home/pbaylis/github/temperature-sentiment/paper/results")

# Main regression table  ----
felm.list <- readRDS(file.path(IN_EST, "reg_cbsa.Rds"))

felms <- list(felm.list$all_vader_s_bins3_c_m_y_d_h,
              felm.list$all_vader_s_bins3_c_date,
              felm.list$all_afinn_s_bins3_c_m_y_d_h,
              felm.list$all_afinn_s_bins3_c_date)

create_nice_numbered_labels <- function(felms, pattern = "tmax") {
  # Assume bins are consistent across felms
  pattern = "tmax"
  felm <- felms[[1]]
  var_names <- grep(pattern, names(coefficients(felm)), value = T)

  matched <- str_match(var_names, "\\(([-Inf0-9]*),([-Inf0-9 ]*)")

  cutpoints_min <- as.numeric(matched[, 2])
  cutpoints_max <- as.numeric(matched[, 3])

  lbls <- sprintf("$T \\in (%g, %g] $", cutpoints_min, cutpoints_max)
  lbls <- sub("\\\\in \\(-Inf, ([0-9]*)?\\]", "\\\\leq \\1", lbls)
  lbls <- sub("\\\\in \\(([0-9]*)?, Inf\\]", "> \\1", lbls)
}


meat <- stargazerw(felms, fragment = T, table.layout = "t",
                   keep = "tmax",
                    covariate.labels = paste0("\\hspace{1em}", create_nice_numbered_labels(felms)))

ncol <- length(felms)
firstline <- sprintf("\\begin{tabular}{l %s}", paste0(rep("D{.}{.}{-3}", ncol), collapse = " "))
lastline <- "\\end{tabular}"

out <- c(firstline,
         "\\toprule",
         paste0("&", latex_special_row(sprintf("(%g)", 1:ncol)), collapse = " "),
         "\\midrule",
         sprintf("\\multicolumn{%g}{l}{Maximum daily temperature $T$} \\vspace{0.5em} \\\\ ", ncol+1),
         meat,
         "\\midrule",
         latex_special_row(c("Month FE", "Yes", ""), align="l"),
         latex_special_row(c("Year FE", "Yes", ""), align="l"),
         latex_special_row(c("DOW, Hol FE", "Yes", ""), align="l"),
         latex_special_row(c("Date FE", "", "Yes"), align="l"),
         "\\bottomrule",
         lastline)

write(out, "~/Desktop/table_test/table_test.tex")
```

Container code:

```latex
\documentclass[12pt]{scrartcl}
\usepackage{threeparttable}
\usepackage{dcolumn} % For booktabs column spacing
\usepackage{booktabs}

\newenvironment{notes}[1][Note]{\begin{minipage}[t]{\linewidth}\normalsize{\itshape#1: }}{\end{minipage}}

\begin{document}

\begin{table}
	\centering
	\begin{threeparttable}
    \caption{Table title}
    \label{tab:lbl}
		\input{table_test}
    \begin{notes}
			* p $<$ 0.1, ** p $<$ 0.05, *** p $<$ 0.01. All regressions include CBSA fixed effects and controls for precipitation.
		\end{notes}
	\end{threeparttable}
\end{table}

\end{document}
```

And finally, what the code produces:

```latex
\begin{tabular}{l D{.}{.}{-3} D{.}{.}{-3} D{.}{.}{-3} D{.}{.}{-3}}
\toprule
&\multicolumn{1}{c}{(1)} & \multicolumn{1}{c}{(2)} & \multicolumn{1}{c}{(3)} & \multicolumn{1}{c}{(4)} \\
\midrule
\multicolumn{5}{l}{Maximum daily temperature $T$} \vspace{0.5em} \\
 \hspace{1em}$T \leq 0 $ & -0.056^{***} & -0.084^{***} & -0.072^{***} & -0.093^{***} \\
  & (0.014) & (0.015) & (0.014) & (0.016) \\
  \hspace{1em}$T \in (0, 3] $ & -0.049^{***} & -0.073^{***} & -0.059^{***} & -0.080^{***} \\
  & (0.013) & (0.013) & (0.012) & (0.013) \\
  \hspace{1em}$T \in (3, 6] $ & -0.039^{***} & -0.060^{***} & -0.051^{***} & -0.069^{***} \\
  & (0.011) & (0.011) & (0.010) & (0.012) \\
  \hspace{1em}$T \in (6, 9] $ & -0.024^{**} & -0.039^{***} & -0.031^{***} & -0.047^{***} \\
  & (0.011) & (0.010) & (0.010) & (0.011) \\
  \hspace{1em}$T \in (9, 12] $ & -0.013^{*} & -0.026^{***} & -0.021^{***} & -0.032^{***} \\
  & (0.008) & (0.008) & (0.007) & (0.009) \\
  \hspace{1em}$T \in (12, 15] $ & 0.004 & -0.012^{***} & -0.005 & -0.016^{**} \\
  & (0.005) & (0.004) & (0.005) & (0.006) \\
  \hspace{1em}$T \in (15, 18] $ & -0.000 & -0.004 & -0.003 & -0.008^{*} \\
  & (0.004) & (0.003) & (0.004) & (0.004) \\
  \hspace{1em}$T \in (18, 21] $ & 0.006^{*} & 0.002 & 0.011^{***} & 0.005^{*} \\
  & (0.003) & (0.002) & (0.003) & (0.003) \\
  \hspace{1em}$T \in (24, 27] $ & 0.001 & 0.005^{**} & 0.001 & 0.003 \\
  & (0.004) & (0.003) & (0.004) & (0.003) \\
  \hspace{1em}$T \in (27, 30] $ & -0.002 & 0.011^{***} & 0.002 & 0.010^{***} \\
  & (0.005) & (0.003) & (0.005) & (0.004) \\
  \hspace{1em}$T \in (30, 33] $ & -0.009^{*} & 0.011^{***} & -0.006 & 0.010^{***} \\
  & (0.005) & (0.003) & (0.006) & (0.004) \\
  \hspace{1em}$T \in (33, 36] $ & -0.017^{***} & 0.009^{**} & -0.015^{*} & 0.009^{*} \\
  & (0.007) & (0.004) & (0.008) & (0.005) \\
  \hspace{1em}$T \in (36, 39] $ & -0.022^{***} & 0.009 & -0.019^{**} & 0.003 \\
  & (0.007) & (0.006) & (0.008) & (0.007) \\
  \hspace{1em}$T > 39 $ & -0.053^{***} & -0.037^{***} & -0.048^{***} & -0.036^{***} \\
  & (0.013) & (0.010) & (0.012) & (0.010) \\
\midrule
\multicolumn{1}{l}{Month FE} & \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{} \\
\multicolumn{1}{l}{Year FE} & \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{} \\
\multicolumn{1}{l}{DOW, Hol FE} & \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{} \\
\multicolumn{1}{l}{Date FE} & \multicolumn{1}{c}{} & \multicolumn{1}{c}{Yes} \\
\bottomrule
\end{tabular}
```
