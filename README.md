# Fleiss
Compute the Fleiss'es kappa<br/>
Fleiss'es kappa is a generalisation of Scott's pi statistic, a
statistical measure of inter-rater reliability. It is also related to
Cohen's kappa statistic. Whereas Scott's pi and Cohen's kappa work for
only two raters, Fleiss'es kappa works for any number of raters giving
categorical ratings (see nominal data), to a fixed number of items. It
can be interpreted as expressing the extent to which the observed amount
of agreement among raters exceeds what would be expected if all raters
made their ratings completely randomly. Agreement can be thought of as
follows, if a fixed number of people assign numerical ratings to a number
of items then the kappa will give a measure for how consistent the
ratings are. The scoring range is between 0 and 1. 

Syntax: 	fleiss(X,alpha)
     
    Inputs:
          X - square data matrix
          ALPHA - significance level (default = 0.05)
    Outputs:
          - kappa value for the j-th category (kj)
          - kj standard error
          - z of kj
          - p-value
          - Fleiss'es kappa
          - kappa standard error
          - kappa confidence interval
          - k benchmarks by Landis and Koch 
          - z test

     Example: 
An example of the use of Fleiss'es kappa may be the following: Consider
fourteen psychiatrists are asked to look at ten patients. Each
psychiatrist gives one of possibly five diagnoses to each patient. The
Fleiss' kappa can be computed from this matrix to show
the degree of agreement between the psychiatrists above the level of
agreement expected by chance.<br/>
x =
    0     0     0     0    14<br/>
    0     2     6     4     2<br/>
    0     0     3     5     6<br/>
    0     3     9     2     0<br/>
    2     2     8     1     1<br/>
    7     7     0     0     0<br/>
    3     2     6     3     0<br/>
    2     5     3     2     2<br/>
    6     5     2     1     0<br/>
    0     2     2     3     7<br/>

So there are 10 rows (1 for each patient) and 5 columns (1 for each
diagnosis). Each cell represents the number of raters who
assigned the i-th subject to the j-th category<br/>
x=[0 0 0 0 14; 0 2 6 4 2; 0 0 3 5 6; 0 3 9 2 0; 2 2 8 1 1 ; 7 7 0 0 0;...
3 2 6 3 0; 2 5 3 2 2; 6 5 2 1 0; 0 2 2 3 7];

 Calling on Matlab the function: fleiss(x);

          Answer is:

kj:       0.2013    0.0797    0.1716    0.0304    0.5077

s.e.:     0.0331

z:        6.0719    2.4034    5.1764    0.9165   15.3141

p:        0.0000    0.0162    0.0000    0.3594         0

------------------------------------------------------------
Fleiss'es (overall) kappa = 0.2099<br/>
kappa error = 0.0170<br/>
kappa C.I. (95%) = 0.1767 	 0.2432<br/>
Fair agreement<br/>
z = 12.3743 	 p = 0.0000<br/>
Reject null hypotesis: observed agreement is not accidental<br/>

          Created by Giuseppe Cardillo
          giuseppe.cardillo-edta@poste.it

To cite this file, this would be an appropriate format:
Cardillo G. (2007) Fleiss'es kappa: compute the Fleiss'es kappa for multiple raters.   
http://www.mathworks.com/matlabcentral/fileexchange/15426
