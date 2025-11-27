[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=dnafinder/Fleiss&file=fleiss.m)

# Fleiss – Fleiss' kappa for multiple raters in MATLAB (fleiss.m)

## 📌 Overview

This repository provides a MATLAB implementation of **Fleiss' kappa**, a measure of inter-rater agreement for **any number of raters** assigning categorical ratings to a fixed set of items.

Fleiss' kappa generalizes Scott's pi and is closely related to Cohen's kappa, but unlike Cohen's coefficient (which is defined for two raters), Fleiss' kappa can handle **multiple raters**. It quantifies how much the observed agreement exceeds what would be expected by chance, given the overall distribution of ratings across categories.

The core function is:

- fleiss.m

It computes Fleiss' overall kappa, its standard error, confidence interval, and category-wise kappa values, together with inferential statistics.

---

## ✨ Features

- Supports **multiple raters** (any number ≥ 2)
- Works with **nominal categorical data**
- Accepts a general **N-by-K contingency matrix**, where:
  - N = number of subjects/items
  - K = number of categories
- Returns:
  - Fleiss' overall kappa
  - Confidence interval for kappa
  - Standard error of kappa
  - Category-wise kappa values (kj)
  - z and p-values for each category
- Provides **Landis & Koch** qualitative classification of agreement
- Optional **textual report** in the Command Window
- Robust input validation (nonnegative integer counts, constant raters per subject)
- Updated metadata with GitHub integration

---

## 📥 Function syntax

Basic usage:

- fleiss(X)
- fleiss(X, ALPHA)
- fleiss(X, ALPHA, DISPLAY)
- [K, CI] = fleiss(...)
- [K, CI, STATS] = fleiss(...)

Where:

- X  
  N-by-K numeric matrix of nonnegative integer counts.  
  Each row i corresponds to a subject/item, each column j to a category.  
  Entry X(i,j) = number of raters who assigned subject i to category j.

  All rows must sum to the same number m, the number of raters per subject.

- ALPHA  
  Significance level for the confidence interval of kappa (default 0.05).

- DISPLAY  
  Logical flag controlling textual output (default true):
  - true  → prints a complete report in the Command Window
  - false → silent mode, only numerical outputs

Outputs:

- K  
  Fleiss' overall kappa.

- CI  
  1-by-2 vector with lower and upper bounds of the confidence interval for K.

- STATS  
  Structure with auxiliary results:
  - kj              – kappa value for each category (1-by-K)
  - sekj            – standard error of kj (scalar)
  - zkj             – z statistics for kj (1-by-K)
  - pkj             – p-values for kj (1-by-K)
  - pj              – overall proportion of ratings in each category
  - kappa           – Fleiss' kappa (same as K)
  - se              – standard error of kappa
  - ci              – confidence interval for kappa (same as CI)
  - alpha           – significance level
  - z               – z statistic for overall kappa
  - p               – p-value for overall kappa
  - nSubjects       – number of subjects/items (N)
  - nCategories     – number of categories (K)
  - nRaters         – number of raters per subject (m)
  - landisKochClass – qualitative agreement class

---

## 📊 Example

Consider the classic example from Fleiss' kappa literature: fourteen psychiatrists diagnose ten patients, choosing among five possible diagnoses.

X is:

x = [ 0  0  0  0 14;
      0  2  6  4  2;
      0  0  3  5  6;
      0  3  9  2  0;
      2  2  8  1  1;
      7  7  0  0  0;
      3  2  6  3  0;
      2  5  3  2  2;
      6  5  2  1  0;
      0  2  2  3  7 ];

There are:

- 10 subjects (rows)
- 5 categories (columns)
- 14 raters (row sum for each subject)

Compute Fleiss' kappa with default settings:

fleiss(x);

This prints:

- Category-wise kappa values (kj)
- Standard error for kj
- z and p-values for each category
- Overall Fleiss' kappa with standard error
- Confidence interval
- Landis & Koch qualitative classification
- z statistic and p-value for the hypothesis test that agreement is purely accidental

To use the results programmatically, without printing:

[k, ci, stats] = fleiss(x, 0.05, false);

You can then inspect, for example:

- stats.kj              – category-specific kappas
- stats.kappa           – overall kappa
- stats.landisKochClass – qualitative agreement summary

---

## 🧮 Interpretation

Fleiss' kappa compares:

- Observed agreement: how often raters actually agree
- Expected agreement: how often they would agree **by chance**, given the marginal distribution of ratings

A kappa of:

- 0 → no agreement beyond chance
- 1 → perfect agreement
- Negative values → agreement less than what would be expected by chance

The function also provides a **z-test** for:

- H0: kappa = 0 (agreement is purely accidental)
- H1: kappa ≠ 0 (agreement is not accidental)

---

## 🧾 Landis & Koch benchmarks

The function classifies the overall kappa according to Landis and Koch (1977):

- k < 0           → Poor agreement
- 0.00–0.20       → Slight agreement
- 0.21–0.40       → Fair agreement
- 0.41–0.60       → Moderate agreement
- 0.61–0.80       → Substantial agreement
- 0.81–1.00       → Perfect agreement

This classification is returned in `STATS.landisKochClass` and printed when `DISPLAY` is true.

---

## 📚 References

- Fleiss JL. (1971). Measuring nominal scale agreement among many raters. Psychological Bulletin, 76(5), 378–382.
- Fleiss JL. (1981). Statistical Methods for Rates and Proportions. 2nd ed. Wiley.
- Landis JR, Koch GG. (1977). The measurement of observer agreement for categorical data. Biometrics, 33(1), 159–174.
- Cardillo G. (2007). Fleiss' kappa: compute Fleiss' kappa for multiple raters. Available from:  
  https://github.com/dnafinder/Fleiss

---

## 📁 Repository structure

Main file:

- fleiss.m – core function implementing Fleiss' kappa and category-wise statistics.

Additional files (if present) may include:

- Example scripts
- Test scripts
- Documentation or auxiliary utilities

---

## 🚀 Getting started

1. Clone or download the repository:

   - GitHub: https://github.com/dnafinder/Fleiss

2. Add the folder containing `fleiss.m` to your MATLAB path, for example:

   - Via MATLAB GUI: Home → Set Path → Add Folder
   - Or programmatically: `addpath('path_to_folder')`

3. Call `fleiss` from the Command Window or from your own scripts:

   - `fleiss(X);`
   - `[k, ci, stats] = fleiss(X, 0.01, false);`

---

## ⚖️ License and citation

Please see the license file in this repository (if provided) for detailed licensing terms.

If you use this code in research, teaching, or software, an appropriate citation is:

Cardillo G. (2007). Fleiss' kappa: compute Fleiss' kappa for multiple raters. Available from:  
https://github.com/dnafinder/Fleiss
