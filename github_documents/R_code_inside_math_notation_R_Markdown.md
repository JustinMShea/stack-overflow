R code inside math notation R Markdown
================

[Question Link](https://stackoverflow.com/questions/45360684/r-code-inside-math-notation-r-markdown/45361147#45361147)
----------------------------------------------------------------------------------------------------------------------

In R Markdown, I can get an inline r code chunk to run inside single $ math notation (only with a \* before), but not double $$ math notation:

-   *H*<sub>*o*</sub> = 2

works, but:

*H*<sub>*o*</sub> = 2

doesn't work, and neither does:

*H*<sub>*o*</sub> = 2

The double `$$` is more flexible being able to put math notation on multiple lines, but how can you add inline code chunks inside?

Answer
------

I ran your example and it worked fine for me!

*H*<sub>*o*</sub> = 2

Perhaps you should check your version of rmarkdown and knitr. I have noticed over the years that version updates, and sometimes even using the most recent dev version, can fix a litany of small issues that arise.

Using R 3.4.1, here are my `knitr` and `rmarkdown` versions:

``` r
citation()
```

    ## 
    ## To cite R in publications use:
    ## 
    ##   R Core Team (2017). R: A language and environment for
    ##   statistical computing. R Foundation for Statistical Computing,
    ##   Vienna, Austria. URL https://www.R-project.org/.
    ## 
    ## A BibTeX entry for LaTeX users is
    ## 
    ##   @Manual{,
    ##     title = {R: A Language and Environment for Statistical Computing},
    ##     author = {{R Core Team}},
    ##     organization = {R Foundation for Statistical Computing},
    ##     address = {Vienna, Austria},
    ##     year = {2017},
    ##     url = {https://www.R-project.org/},
    ##   }
    ## 
    ## We have invested a lot of time and effort in creating R, please
    ## cite it when using it for data analysis. See also
    ## 'citation("pkgname")' for citing R packages.

``` r
citation("knitr")
```

    ## 
    ## To cite the 'knitr' package in publications use:
    ## 
    ##   Yihui Xie (2017). knitr: A General-Purpose Package for Dynamic
    ##   Report Generation in R. R package version 1.16.
    ## 
    ##   Yihui Xie (2015) Dynamic Documents with R and knitr. 2nd
    ##   edition. Chapman and Hall/CRC. ISBN 978-1498716963
    ## 
    ##   Yihui Xie (2014) knitr: A Comprehensive Tool for Reproducible
    ##   Research in R. In Victoria Stodden, Friedrich Leisch and Roger
    ##   D. Peng, editors, Implementing Reproducible Computational
    ##   Research. Chapman and Hall/CRC. ISBN 978-1466561595
    ## 
    ## To see these entries in BibTeX format, use 'print(<citation>,
    ## bibtex=TRUE)', 'toBibtex(.)', or set
    ## 'options(citation.bibtex.max=999)'.

``` r
citation("rmarkdown")
```

    ## 
    ## To cite package 'rmarkdown' in publications use:
    ## 
    ##   JJ Allaire, Joe Cheng, Yihui Xie, Jonathan McPherson, Winston
    ##   Chang, Jeff Allen, Hadley Wickham, Aron Atkins, Rob Hyndman and
    ##   Ruben Arslan (2017). rmarkdown: Dynamic Documents for R. R
    ##   package version 1.6.
    ##   https://CRAN.R-project.org/package=rmarkdown
    ## 
    ## A BibTeX entry for LaTeX users is
    ## 
    ##   @Manual{,
    ##     title = {rmarkdown: Dynamic Documents for R},
    ##     author = {JJ Allaire and Joe Cheng and Yihui Xie and Jonathan McPherson and Winston Chang and Jeff Allen and Hadley Wickham and Aron Atkins and Rob Hyndman and Ruben Arslan},
    ##     year = {2017},
    ##     note = {R package version 1.6},
    ##     url = {https://CRAN.R-project.org/package=rmarkdown},
    ##   }
