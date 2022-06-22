
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
Cq.data
#>                 Target Content                Sample       Cq
#>  1: gene.of.interest.1     Std             wild.type 25.31687
#>  2: gene.of.interest.1     Std             wild.type 25.18056
#>  3: gene.of.interest.1     Std             wild.type 25.20548
#>  4: gene.of.interest.1     Std             wild.type 27.47060
#>  5: gene.of.interest.1     Std             wild.type 27.59993
#>  6: gene.of.interest.1     Std             wild.type 27.50947
#>  7: gene.of.interest.1     Std             wild.type 28.81033
#>  8: gene.of.interest.1     Std             wild.type 28.91089
#>  9: gene.of.interest.1     Std             wild.type 28.83967
#> 10: gene.of.interest.1     Std             wild.type 32.07517
#> 11: gene.of.interest.1     Std             wild.type 31.47049
#> 12: gene.of.interest.1     Std             wild.type 31.70834
#> 13: gene.of.interest.1     NTC                       34.98170
#> 14: gene.of.interest.2     Std             wild.type 29.90019
#> 15: gene.of.interest.2     Std             wild.type 30.45874
#> 16: gene.of.interest.2     Std             wild.type 30.32889
#> 17: gene.of.interest.2     Std             wild.type 31.36213
#> 18: gene.of.interest.2     Std             wild.type 31.18277
#> 19: gene.of.interest.2     Std             wild.type 31.21550
#> 20: gene.of.interest.2     Std             wild.type 34.91536
#> 21: gene.of.interest.2     Std             wild.type 33.36605
#> 22: gene.of.interest.2     Std             wild.type 34.25686
#> 23: gene.of.interest.2     Std             wild.type 38.33584
#> 24: gene.of.interest.2     Std             wild.type 37.99009
#> 25: gene.of.interest.2     Std             wild.type 38.26446
#> 26: gene.of.interest.2     NTC                            NaN
#> 27:     reference.gene     Std             wild.type 23.72250
#> 28:     reference.gene     Std             wild.type 23.72578
#> 29:     reference.gene     Std             wild.type 23.71567
#> 30:     reference.gene     Std             wild.type 25.80885
#> 31:     reference.gene     Std             wild.type 25.51385
#> 32:     reference.gene     Std             wild.type 25.61845
#> 33:     reference.gene     Std             wild.type 28.08328
#> 34:     reference.gene     Std             wild.type 28.02725
#> 35:     reference.gene     Std             wild.type 28.04874
#> 36:     reference.gene     Std             wild.type 30.36816
#> 37:     reference.gene     Std             wild.type 30.14619
#> 38:     reference.gene     Std             wild.type 30.19956
#> 39:     reference.gene     NTC                            NaN
#> 40: gene.of.interest.1    Unkn control.condition (1) 28.10107
#> 41: gene.of.interest.1    Unkn control.condition (1) 28.00969
#> 42: gene.of.interest.1    Unkn control.condition (1) 27.97419
#> 43: gene.of.interest.1    Unkn control.condition (2) 28.18124
#> 44: gene.of.interest.1    Unkn control.condition (2) 27.92769
#> 45: gene.of.interest.1    Unkn control.condition (2) 27.58434
#> 46: gene.of.interest.1    Unkn control.condition (3) 28.97493
#> 47: gene.of.interest.1    Unkn control.condition (3) 28.23828
#> 48: gene.of.interest.1    Unkn control.condition (3) 28.33302
#> 49: gene.of.interest.1    Unkn    test.condition (1) 26.84763
#> 50: gene.of.interest.1    Unkn    test.condition (1) 26.19705
#> 51: gene.of.interest.1    Unkn    test.condition (1) 26.75797
#> 52: gene.of.interest.1    Unkn    test.condition (2) 26.59074
#> 53: gene.of.interest.1    Unkn    test.condition (2) 26.43531
#> 54: gene.of.interest.1    Unkn    test.condition (2) 25.85585
#> 55: gene.of.interest.1    Unkn    test.condition (3) 27.03001
#> 56: gene.of.interest.1    Unkn    test.condition (3) 27.24894
#> 57: gene.of.interest.1    Unkn    test.condition (3) 26.70993
#> 58: gene.of.interest.2    Unkn control.condition (1) 34.68549
#> 59: gene.of.interest.2    Unkn control.condition (1) 34.81189
#> 60: gene.of.interest.2    Unkn control.condition (1) 34.96419
#> 61: gene.of.interest.2    Unkn control.condition (2) 35.28110
#> 62: gene.of.interest.2    Unkn control.condition (2) 35.53064
#> 63: gene.of.interest.2    Unkn control.condition (2) 34.70007
#> 64: gene.of.interest.2    Unkn control.condition (3) 34.62332
#> 65: gene.of.interest.2    Unkn control.condition (3) 34.65434
#> 66: gene.of.interest.2    Unkn control.condition (3) 34.62697
#> 67: gene.of.interest.2    Unkn    test.condition (1) 31.41039
#> 68: gene.of.interest.2    Unkn    test.condition (1) 32.10934
#> 69: gene.of.interest.2    Unkn    test.condition (1) 31.24901
#> 70: gene.of.interest.2    Unkn    test.condition (2) 31.15962
#> 71: gene.of.interest.2    Unkn    test.condition (2) 31.39998
#> 72: gene.of.interest.2    Unkn    test.condition (2) 31.31049
#> 73: gene.of.interest.2    Unkn    test.condition (3) 32.92115
#> 74: gene.of.interest.2    Unkn    test.condition (3) 32.63306
#> 75: gene.of.interest.2    Unkn    test.condition (3) 32.83479
#> 76:     reference.gene    Unkn control.condition (1) 25.70499
#> 77:     reference.gene    Unkn control.condition (1) 25.77324
#> 78:     reference.gene    Unkn control.condition (1) 26.01208
#> 79:     reference.gene    Unkn control.condition (2) 25.57582
#> 80:     reference.gene    Unkn control.condition (2) 25.47155
#> 81:     reference.gene    Unkn control.condition (2) 25.68859
#> 82:     reference.gene    Unkn control.condition (3) 25.42625
#> 83:     reference.gene    Unkn control.condition (3) 25.62250
#> 84:     reference.gene    Unkn control.condition (3) 25.60219
#> 85:     reference.gene    Unkn    test.condition (1) 25.53302
#> 86:     reference.gene    Unkn    test.condition (1) 25.68075
#> 87:     reference.gene    Unkn    test.condition (1) 25.43289
#> 88:     reference.gene    Unkn    test.condition (2) 25.67935
#> 89:     reference.gene    Unkn    test.condition (2) 25.92961
#> 90:     reference.gene    Unkn    test.condition (2) 26.08242
#> 91:     reference.gene    Unkn    test.condition (3) 25.50338
#> 92:     reference.gene    Unkn    test.condition (3) 25.83698
#> 93:     reference.gene    Unkn    test.condition (3) 26.08465
#>                 Target Content                Sample       Cq
#>     Starting.Quantity..SQ. Log.Starting.Quantity
#>  1:                   5.00               0.69897
#>  2:                   5.00               0.69897
#>  3:                   5.00               0.69897
#>  4:                   1.00               0.00000
#>  5:                   1.00               0.00000
#>  6:                   1.00               0.00000
#>  7:                   0.20              -0.69897
#>  8:                   0.20              -0.69897
#>  9:                   0.20              -0.69897
#> 10:                   0.04              -1.39794
#> 11:                   0.04              -1.39794
#> 12:                   0.04              -1.39794
#> 13:                    NaN                   NaN
#> 14:                   5.00               0.69897
#> 15:                   5.00               0.69897
#> 16:                   5.00               0.69897
#> 17:                   1.00               0.00000
#> 18:                   1.00               0.00000
#> 19:                   1.00               0.00000
#> 20:                   0.20              -0.69897
#> 21:                   0.20              -0.69897
#> 22:                   0.20              -0.69897
#> 23:                   0.04              -1.39794
#> 24:                   0.04              -1.39794
#> 25:                   0.04              -1.39794
#> 26:                    NaN                   NaN
#> 27:                   5.00               0.69897
#> 28:                   5.00               0.69897
#> 29:                   5.00               0.69897
#> 30:                   1.00               0.00000
#> 31:                   1.00               0.00000
#> 32:                   1.00               0.00000
#> 33:                   0.20              -0.69897
#> 34:                   0.20              -0.69897
#> 35:                   0.20              -0.69897
#> 36:                   0.04              -1.39794
#> 37:                   0.04              -1.39794
#> 38:                   0.04              -1.39794
#> 39:                    NaN                   NaN
#> 40:                    NaN                   NaN
#> 41:                    NaN                   NaN
#> 42:                    NaN                   NaN
#> 43:                    NaN                   NaN
#> 44:                    NaN                   NaN
#> 45:                    NaN                   NaN
#> 46:                    NaN                   NaN
#> 47:                    NaN                   NaN
#> 48:                    NaN                   NaN
#> 49:                    NaN                   NaN
#> 50:                    NaN                   NaN
#> 51:                    NaN                   NaN
#> 52:                    NaN                   NaN
#> 53:                    NaN                   NaN
#> 54:                    NaN                   NaN
#> 55:                    NaN                   NaN
#> 56:                    NaN                   NaN
#> 57:                    NaN                   NaN
#> 58:                    NaN                   NaN
#> 59:                    NaN                   NaN
#> 60:                    NaN                   NaN
#> 61:                    NaN                   NaN
#> 62:                    NaN                   NaN
#> 63:                    NaN                   NaN
#> 64:                    NaN                   NaN
#> 65:                    NaN                   NaN
#> 66:                    NaN                   NaN
#> 67:                    NaN                   NaN
#> 68:                    NaN                   NaN
#> 69:                    NaN                   NaN
#> 70:                    NaN                   NaN
#> 71:                    NaN                   NaN
#> 72:                    NaN                   NaN
#> 73:                    NaN                   NaN
#> 74:                    NaN                   NaN
#> 75:                    NaN                   NaN
#> 76:                    NaN                   NaN
#> 77:                    NaN                   NaN
#> 78:                    NaN                   NaN
#> 79:                    NaN                   NaN
#> 80:                    NaN                   NaN
#> 81:                    NaN                   NaN
#> 82:                    NaN                   NaN
#> 83:                    NaN                   NaN
#> 84:                    NaN                   NaN
#> 85:                    NaN                   NaN
#> 86:                    NaN                   NaN
#> 87:                    NaN                   NaN
#> 88:                    NaN                   NaN
#> 89:                    NaN                   NaN
#> 90:                    NaN                   NaN
#> 91:                    NaN                   NaN
#> 92:                    NaN                   NaN
#> 93:                    NaN                   NaN
#>     Starting.Quantity..SQ. Log.Starting.Quantity
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
qPCR.analysis$std.curve
#> $data
#>                 Target    Sample Log.Starting.Quantity Cq.average   Cq.st.dev
#>  1: gene.of.interest.1 wild.type               0.69897   25.23430 0.072582817
#>  2: gene.of.interest.1 wild.type               0.00000   27.52667 0.066358761
#>  3: gene.of.interest.1 wild.type              -0.69897   28.85363 0.051714302
#>  4: gene.of.interest.1 wild.type              -1.39794   31.75134 0.304622585
#>  5: gene.of.interest.2 wild.type               0.69897   30.22927 0.292299559
#>  6: gene.of.interest.2 wild.type               0.00000   31.25347 0.095517677
#>  7: gene.of.interest.2 wild.type              -0.69897   34.17942 0.777552537
#>  8: gene.of.interest.2 wild.type              -1.39794   38.19680 0.182536521
#>  9:     reference.gene wild.type               0.69897   23.72132 0.005155706
#> 10:     reference.gene wild.type               0.00000   25.64705 0.149566014
#> 11:     reference.gene wild.type              -0.69897   28.05309 0.028263621
#> 12:     reference.gene wild.type              -1.39794   30.23797 0.115865028
#> 
#> $efficiencies
#>                Target     slope efficiency amplification.base
#> 1: gene.of.interest.1 -2.986975  1.1616575           2.161658
#> 2: gene.of.interest.2 -3.838294  0.8219331           1.821933
#> 3:     reference.gene -3.141194  1.0813749           2.081375
#> 
#> $plot
#> `geom_smooth()` using formula 'y ~ x'
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

``` r
qPCR.analysis$unk.rxn
#>                Sample Biol.rep             Target Cq.tech.mean Cq.tech.sd
#>  1: control.condition      (1) gene.of.interest.1     28.02832 0.06545866
#>  2: control.condition      (2) gene.of.interest.1     27.89776 0.29957153
#>  3: control.condition      (3) gene.of.interest.1     28.51541 0.40077006
#>  4:    test.condition      (1) gene.of.interest.1     26.60088 0.35259014
#>  5:    test.condition      (2) gene.of.interest.1     26.29397 0.38729634
#>  6:    test.condition      (3) gene.of.interest.1     26.99629 0.27107886
#>  7: control.condition      (1) gene.of.interest.2     34.82052 0.13955115
#>  8: control.condition      (2) gene.of.interest.2     35.17060 0.42617061
#>  9: control.condition      (3) gene.of.interest.2     34.63487 0.01695555
#> 10:    test.condition      (1) gene.of.interest.2     31.58958 0.45729791
#> 11:    test.condition      (2) gene.of.interest.2     31.29003 0.12148016
#> 12:    test.condition      (3) gene.of.interest.2     32.79633 0.14784186
#> 13: control.condition      (1)     reference.gene     25.83010 0.16124615
#> 14: control.condition      (2)     reference.gene     25.57865 0.10854693
#> 15: control.condition      (3)     reference.gene     25.55031 0.10791676
#> 16:    test.condition      (1)     reference.gene     25.54889 0.12468526
#> 17:    test.condition      (2)     reference.gene     25.89713 0.20348577
#> 18:    test.condition      (3)     reference.gene     25.80833 0.29169136
```

``` r
qPCR.analysis$expression
#>                Sample Biol.rep             Target Cq.tech.mean
#>  1: control.condition      (1) gene.of.interest.1     28.02832
#>  2: control.condition      (2) gene.of.interest.1     27.89776
#>  3: control.condition      (3) gene.of.interest.1     28.51541
#>  4:    test.condition      (1) gene.of.interest.1     26.60088
#>  5:    test.condition      (2) gene.of.interest.1     26.29397
#>  6:    test.condition      (3) gene.of.interest.1     26.99629
#>  7: control.condition      (1) gene.of.interest.2     34.82052
#>  8: control.condition      (2) gene.of.interest.2     35.17060
#>  9: control.condition      (3) gene.of.interest.2     34.63487
#> 10:    test.condition      (1) gene.of.interest.2     31.58958
#> 11:    test.condition      (2) gene.of.interest.2     31.29003
#> 12:    test.condition      (3) gene.of.interest.2     32.79633
#>     reference.gene.Cq.tech.mean reference.gene.amplification.base
#>  1:                    25.83010                          2.081375
#>  2:                    25.57865                          2.081375
#>  3:                    25.55031                          2.081375
#>  4:                    25.54889                          2.081375
#>  5:                    25.89713                          2.081375
#>  6:                    25.80833                          2.081375
#>  7:                    25.83010                          2.081375
#>  8:                    25.57865                          2.081375
#>  9:                    25.55031                          2.081375
#> 10:                    25.54889                          2.081375
#> 11:                    25.89713                          2.081375
#> 12:                    25.80833                          2.081375
#>     reference.gene.Cq.weighed Ref.Cq.weighed.mean GOI.amplification.base
#>  1:                  27.31629            27.31629               2.161658
#>  2:                  27.05037            27.05037               2.161658
#>  3:                  27.02040            27.02040               2.161658
#>  4:                  27.01889            27.01889               2.161658
#>  5:                  27.38716            27.38716               2.161658
#>  6:                  27.29326            27.29326               2.161658
#>  7:                  27.31629            27.31629               1.821933
#>  8:                  27.05037            27.05037               1.821933
#>  9:                  27.02040            27.02040               1.821933
#> 10:                  27.01889            27.01889               1.821933
#> 11:                  27.38716            27.38716               1.821933
#> 12:                  27.29326            27.29326               1.821933
#>     GOI.Cq.weighed DCq.weighed control.DCq.weighed log2.fold.change fold.change
#>  1:       31.17135  -3.8550688           -4.174510       0.31944149   1.2478474
#>  2:       31.02616  -3.9757904           -4.174510       0.19871983   1.1476795
#>  3:       31.71307  -4.6926716           -4.174510      -0.51816133   0.6982612
#>  4:       29.58385  -2.5649640           -4.174510       1.60954622   3.0515584
#>  5:       29.24252  -1.8553562           -4.174510       2.31915404   4.9903951
#>  6:       30.02360  -2.7303406           -4.174510       1.44416971   2.7210618
#>  7:       30.13612  -2.8198319           -3.054538       0.23470632   1.1766672
#>  8:       30.43910  -3.3887355           -3.054538      -0.33419728   0.7932254
#>  9:       29.97545  -2.9550472           -3.054538       0.09949096   1.0713954
#> 10:       27.33983  -0.3209444           -3.054538       2.73359378   6.6511038
#> 11:       27.08058   0.3065821           -3.054538       3.36112029  10.2753832
#> 12:       28.38424  -1.0909790           -3.054538       1.96355918   3.9002299
```

``` r
devtools::install_github("dimitriskokoretsis/datavis")
```

``` r
library(datavis)
expression.plot <- qPCR.analysis$expression |>
  bar_point_plot(x="Target",y="fold.change",color.group="Sample",mean.type="geometric")
expression.plot
```

<img src="man/figures/README-unnamed-chunk-10-1.png" width="100%" />
