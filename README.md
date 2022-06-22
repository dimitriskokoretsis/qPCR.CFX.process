
<!-- README.md is generated from README.Rmd. Please edit that file -->

# qpcr.CFX.process

<!-- badges: start -->
<!-- badges: end -->

The goal of qpcr.CFX.process is to …

## Installation

You can install the development version of qpcr.CFX.process from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("dimitriskokoretsis/qpcr.CFX.process")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
Cq.data <- data.table::fread("test_data/PCR_Cq_data.csv",check.names=TRUE)
```

``` r
library(qpcr.CFX.process)
qPCR.analysis <- qPCR_analysis_wrap(Cq.data,refgene="reference.gene",control="control.condition")
```

``` r
str(qPCR.analysis,max.level=1)
#> List of 4
#>  $ NTC       :Classes 'data.table' and 'data.frame': 3 obs. of  2 variables:
#>   ..- attr(*, ".internal.selfref")=<externalptr> 
#>  $ std.curve :List of 3
#>  $ unk.rxn   :Classes 'data.table' and 'data.frame': 18 obs. of  5 variables:
#>   ..- attr(*, ".internal.selfref")=<externalptr> 
#>  $ expression:Classes 'data.table' and 'data.frame': 12 obs. of  14 variables:
#>   ..- attr(*, ".internal.selfref")=<externalptr>
```

``` r
qPCR.analysis$NTC
#>                Target      Cq
#> 1: gene.of.interest.1 34.9817
#> 2: gene.of.interest.2     NaN
#> 3:     reference.gene     NaN
```

``` r
str(qPCR.analysis$std.curve,max.level=1)
#> List of 3
#>  $ data        :Classes 'data.table' and 'data.frame':   12 obs. of  5 variables:
#>   ..- attr(*, ".internal.selfref")=<externalptr> 
#>  $ efficiencies:Classes 'data.table' and 'data.frame':   3 obs. of  4 variables:
#>   ..- attr(*, ".internal.selfref")=<externalptr> 
#>   ..- attr(*, "index")= int(0) 
#>   .. ..- attr(*, "__Target")= int(0) 
#>  $ plot        :List of 9
#>   ..- attr(*, "class")= chr [1:2] "gg" "ggplot"
```

``` r
knitr::kable(qPCR.analysis$std.curve$data)
```

| Target             | Sample    | Log.Starting.Quantity | Cq.average | Cq.st.dev |
|:-------------------|:----------|----------------------:|-----------:|----------:|
| gene.of.interest.1 | wild.type |               0.69897 |   25.23430 | 0.0725828 |
| gene.of.interest.1 | wild.type |               0.00000 |   27.52667 | 0.0663588 |
| gene.of.interest.1 | wild.type |              -0.69897 |   28.85363 | 0.0517143 |
| gene.of.interest.1 | wild.type |              -1.39794 |   31.75134 | 0.3046226 |
| gene.of.interest.2 | wild.type |               0.69897 |   30.22927 | 0.2922996 |
| gene.of.interest.2 | wild.type |               0.00000 |   31.25347 | 0.0955177 |
| gene.of.interest.2 | wild.type |              -0.69897 |   34.17942 | 0.7775525 |
| gene.of.interest.2 | wild.type |              -1.39794 |   38.19680 | 0.1825365 |
| reference.gene     | wild.type |               0.69897 |   23.72132 | 0.0051557 |
| reference.gene     | wild.type |               0.00000 |   25.64705 | 0.1495660 |
| reference.gene     | wild.type |              -0.69897 |   28.05309 | 0.0282636 |
| reference.gene     | wild.type |              -1.39794 |   30.23797 | 0.1158650 |

``` r
knitr::kable(qPCR.analysis$std.curve$efficiencies)
```

| Target             |     slope | efficiency | amplification.base |
|:-------------------|----------:|-----------:|-------------------:|
| gene.of.interest.1 | -2.986975 |  1.1616575 |           2.161658 |
| gene.of.interest.2 | -3.838294 |  0.8219331 |           1.821933 |
| reference.gene     | -3.141194 |  1.0813749 |           2.081375 |

``` r
qPCR.analysis$std.curve$plot
#> `geom_smooth()` using formula 'y ~ x'
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />

``` r
knitr::kable(qPCR.analysis$unk.rxn)
```

| Sample            | Biol.rep | Target             | Cq.tech.mean | Cq.tech.sd |
|:------------------|:---------|:-------------------|-------------:|-----------:|
| control.condition | \(1\)    | gene.of.interest.1 |     28.02832 |  0.0654587 |
| control.condition | \(2\)    | gene.of.interest.1 |     27.89776 |  0.2995715 |
| control.condition | \(3\)    | gene.of.interest.1 |     28.51541 |  0.4007701 |
| test.condition    | \(1\)    | gene.of.interest.1 |     26.60088 |  0.3525901 |
| test.condition    | \(2\)    | gene.of.interest.1 |     26.29397 |  0.3872963 |
| test.condition    | \(3\)    | gene.of.interest.1 |     26.99629 |  0.2710789 |
| control.condition | \(1\)    | gene.of.interest.2 |     34.82052 |  0.1395511 |
| control.condition | \(2\)    | gene.of.interest.2 |     35.17060 |  0.4261706 |
| control.condition | \(3\)    | gene.of.interest.2 |     34.63487 |  0.0169556 |
| test.condition    | \(1\)    | gene.of.interest.2 |     31.58958 |  0.4572979 |
| test.condition    | \(2\)    | gene.of.interest.2 |     31.29003 |  0.1214802 |
| test.condition    | \(3\)    | gene.of.interest.2 |     32.79633 |  0.1478419 |
| control.condition | \(1\)    | reference.gene     |     25.83010 |  0.1612462 |
| control.condition | \(2\)    | reference.gene     |     25.57865 |  0.1085469 |
| control.condition | \(3\)    | reference.gene     |     25.55031 |  0.1079168 |
| test.condition    | \(1\)    | reference.gene     |     25.54889 |  0.1246853 |
| test.condition    | \(2\)    | reference.gene     |     25.89713 |  0.2034858 |
| test.condition    | \(3\)    | reference.gene     |     25.80833 |  0.2916914 |

``` r
knitr::kable(qPCR.analysis$expression)
```

| Sample            | Biol.rep | Target             | Cq.tech.mean | reference.gene.Cq.tech.mean | reference.gene.amplification.base | reference.gene.Cq.weighed | Ref.Cq.weighed.mean | GOI.amplification.base | GOI.Cq.weighed | DCq.weighed | control.DCq.weighed | log2.fold.change | fold.change |
|:------------------|:---------|:-------------------|-------------:|----------------------------:|----------------------------------:|--------------------------:|--------------------:|-----------------------:|---------------:|------------:|--------------------:|-----------------:|------------:|
| control.condition | \(1\)    | gene.of.interest.1 |     28.02832 |                    25.83010 |                          2.081375 |                  27.31629 |            27.31629 |               2.161658 |       31.17135 |  -3.8550688 |           -4.174510 |        0.3194415 |   1.2478474 |
| control.condition | \(2\)    | gene.of.interest.1 |     27.89776 |                    25.57865 |                          2.081375 |                  27.05037 |            27.05037 |               2.161658 |       31.02616 |  -3.9757904 |           -4.174510 |        0.1987198 |   1.1476795 |
| control.condition | \(3\)    | gene.of.interest.1 |     28.51541 |                    25.55031 |                          2.081375 |                  27.02040 |            27.02040 |               2.161658 |       31.71307 |  -4.6926716 |           -4.174510 |       -0.5181613 |   0.6982612 |
| test.condition    | \(1\)    | gene.of.interest.1 |     26.60088 |                    25.54889 |                          2.081375 |                  27.01889 |            27.01889 |               2.161658 |       29.58385 |  -2.5649640 |           -4.174510 |        1.6095462 |   3.0515584 |
| test.condition    | \(2\)    | gene.of.interest.1 |     26.29397 |                    25.89713 |                          2.081375 |                  27.38716 |            27.38716 |               2.161658 |       29.24252 |  -1.8553562 |           -4.174510 |        2.3191540 |   4.9903951 |
| test.condition    | \(3\)    | gene.of.interest.1 |     26.99629 |                    25.80833 |                          2.081375 |                  27.29326 |            27.29326 |               2.161658 |       30.02360 |  -2.7303406 |           -4.174510 |        1.4441697 |   2.7210618 |
| control.condition | \(1\)    | gene.of.interest.2 |     34.82052 |                    25.83010 |                          2.081375 |                  27.31629 |            27.31629 |               1.821933 |       30.13612 |  -2.8198319 |           -3.054538 |        0.2347063 |   1.1766672 |
| control.condition | \(2\)    | gene.of.interest.2 |     35.17060 |                    25.57865 |                          2.081375 |                  27.05037 |            27.05037 |               1.821933 |       30.43910 |  -3.3887355 |           -3.054538 |       -0.3341973 |   0.7932254 |
| control.condition | \(3\)    | gene.of.interest.2 |     34.63487 |                    25.55031 |                          2.081375 |                  27.02040 |            27.02040 |               1.821933 |       29.97545 |  -2.9550472 |           -3.054538 |        0.0994910 |   1.0713954 |
| test.condition    | \(1\)    | gene.of.interest.2 |     31.58958 |                    25.54889 |                          2.081375 |                  27.01889 |            27.01889 |               1.821933 |       27.33983 |  -0.3209444 |           -3.054538 |        2.7335938 |   6.6511038 |
| test.condition    | \(2\)    | gene.of.interest.2 |     31.29003 |                    25.89713 |                          2.081375 |                  27.38716 |            27.38716 |               1.821933 |       27.08058 |   0.3065821 |           -3.054538 |        3.3611203 |  10.2753832 |
| test.condition    | \(3\)    | gene.of.interest.2 |     32.79633 |                    25.80833 |                          2.081375 |                  27.29326 |            27.29326 |               1.821933 |       28.38424 |  -1.0909790 |           -3.054538 |        1.9635592 |   3.9002299 |

``` r
library(datavis)
expression.plot <- qPCR.analysis$expression |>
  bar_point_plot(x="Target",
                 y="fold.change",
                 color.group="Sample",
                 mean.type="geometric")

expression.plot
```

<img src="man/figures/README-unnamed-chunk-10-1.png" width="100%" />
