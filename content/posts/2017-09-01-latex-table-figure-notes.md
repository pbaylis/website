---
layout: post
title:  "Best practices: Table and figure notes"
date:   2017-09-01
categories: 
  - writing
tags: 
  - latex
published: false
---

_Update (May 2018): Deprecated, superceded by April 14, 2018 post._

Best practices for including table and figure notes in a document. Uses `threeparttable`. The key for images is to wrap the image in a 1x1 tabular.

{% highlight latex %}
{% raw  %}
\documentclass[12pt]{article}
\usepackage{graphicx}
\usepackage{booktabs}
\usepackage{blindtext} % Lorem ipsum
\usepackage{threeparttable}

\title{Latex table and figure notes example}
\author{Patrick Baylis}
\begin{document}
\maketitle

\newcommand{\notestext}[1]{%
 \begin{tablenotes}[para, flushleft]
 \hspace{6pt}
 #1
 \end{tablenotes}
}

\newcommand{\notes}[1]{\notestext{\emph{Notes:~}~#1}}

\section{Table test}

\begin{table}[!htbp]
	\caption{Table caption}
	\label{tablabel}
	\centering
	\begin{threeparttable}
		\begin{tabular}{@{}lllll@{}}
		\toprule
		Squash & Yams & Apples & Bananananananas and really long name & Fruits \\ \midrule
		1      & 4.5  & 3.5    & 9.999   & 1      \\
		2      & 1.5  & 5      & 3       & 0      \\
		3      & 3.7  & 3      & 1       &        \\ \bottomrule
		\end{tabular}
		\notes{\blindtext}
	\end{threeparttable}
\end{table}

\clearpage
\section{Figure test}

\begin{figure}[!htbp]
	\caption{Figure caption}
	\label{figlabel}
	\centering
	\begin{threeparttable}
		\begin{tabular}{c}
			\includegraphics{narwhals.jpg}
		\end{tabular}
		\notes{\blindtext}
	\end{threeparttable}
\end{figure}

\end{document}
{% endraw  %}
{% endhighlight %}
