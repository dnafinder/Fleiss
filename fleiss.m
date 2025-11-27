function [k, ci, stats] = fleiss(x,varargin)
%FLEISS Compute Fleiss' kappa for multiple raters and categorical ratings.
%
% Fleiss' kappa is a generalisation of Scott's pi statistic, a statistical
% measure of inter-rater reliability. It is also related to Cohen's kappa
% statistic. Whereas Scott's pi and Cohen's kappa work for only two raters,
% Fleiss' kappa works for any number of raters giving categorical ratings
% to a fixed number of items.
%
% It can be interpreted as expressing the extent to which the observed
% agreement among raters exceeds what would be expected if all raters made
% their ratings completely at random, given the overall distribution of
% ratings across categories.
%
% Syntax:
%   fleiss(X)
%   fleiss(X,ALPHA)
%   fleiss(X,ALPHA,DISPLAY)
%   [K,CI] = fleiss(...)
%   [K,CI,STATS] = fleiss(...)
%
% Inputs:
%   X        - data matrix of size N-by-K:
%              * N = number of subjects/items
%              * K = number of categories
%              Each row i contains the counts of raters that assigned
%              subject i to each category j (j = 1..K).
%              All entries must be nonnegative integers.
%
%   ALPHA    - significance level for the confidence interval of kappa
%              (default 0.05).
%
%   DISPLAY  - logical flag (true/false) to control textual output
%              (default true):
%              * true  -> prints a report in the Command Window
%              * false -> no printing, only returns outputs
%
% Outputs:
%   K        - Fleiss' overall kappa.
%
%   CI       - 1-by-2 vector with confidence interval for K.
%
%   STATS    - structure with additional results:
%              .kj              kappa value for each category j (1-by-K)
%              .sekj            standard error of kj (scalar, same for all j)
%              .zkj             z statistics for kj (1-by-K)
%              .pkj             p-values for kj (1-by-K)
%              .pj              overall proportion of ratings in category j
%              .kappa           Fleiss' overall kappa (same as K)
%              .se              standard error of Fleiss' kappa
%              .ci              confidence interval for kappa (same as CI)
%              .alpha           significance level
%              .z               z statistic for overall kappa
%              .p               p-value for overall kappa
%              .nSubjects       number of subjects/items (N)
%              .nCategories     number of categories (K)
%              .nRaters         number of raters per subject (m)
%              .landisKochClass qualitative classification of agreement
%
% Example:
%
%   % Fourteen psychiatrists (raters) diagnose ten patients (subjects),
%   % choosing among five possible diagnoses (categories).
%   x = [ 0  0  0  0 14;
%         0  2  6  4  2;
%         0  0  3  5  6;
%         0  3  9  2  0;
%         2  2  8  1  1;
%         7  7  0  0  0;
%         3  2  6  3  0;
%         2  5  3  2  2;
%         6  5  2  1  0;
%         0  2  2  3  7 ];
%
%   % Fleiss' kappa with default alpha=0.05 and printed report:
%   fleiss(x);
%
%   % Same example, returning outputs without printing:
%   [k, ci, stats] = fleiss(x, 0.05, false);
%
% Author:   Giuseppe Cardillo
% Email:    giuseppe.cardillo.75@gmail.com
% GitHub:   https://github.com/dnafinder/Fleiss
%
% To cite this file, this would be an appropriate format:
%   Cardillo G. (2007) Fleiss' kappa: compute Fleiss' kappa for multiple
%   raters. Available from:
%   https://github.com/dnafinder/Fleiss
%
% -------------------------------------------------------------------------

% Input parsing and validation
p = inputParser;
p.FunctionName = 'fleiss';

addRequired(p,'x', @(X) validateattributes(X,{'numeric'},...
    {'nonempty','integer','real','finite','nonnan','nonnegative'}));

addOptional(p,'alpha',0.05, @(a) validateattributes(a,{'numeric'},...
    {'scalar','real','finite','nonnan','>',0,'<',1}));

addOptional(p,'displayopt',true, @(d) islogical(d) && isscalar(d));

parse(p,x,varargin{:});
x          = p.Results.x;
alpha      = p.Results.alpha;
displayopt = p.Results.displayopt;
clear p

% Basic size info
[nSubjects, nCategories] = size(x);

% Check that the number of raters is the same for each subject
rowSum = sum(x,2);                    % N-by-1
nRaters = rowSum(1);
if any(rowSum ~= nRaters)
    error('fleiss:InconsistentRaters',...
        'The number of raters per subject (row sums) must be constant.');
end

if nRaters <= 0
    error('fleiss:NoRaters','The number of raters must be positive.');
end

% Total number of ratings
a = nSubjects * nRaters;
if a <= 0
    error('fleiss:NoData','The input matrix X contains no positive counts.');
end

% Overall proportion of ratings in category j
pj = sum(x,1) ./ a;                   % 1-by-K

% Category-specific variance component
b = pj .* (1 - pj);                   % 1-by-K

% Scalar constant
c = a * (nRaters - 1);

% Mask of categories with nonzero variance (b > 0)
valid = b > 0;

if ~any(valid)
    error('fleiss:NoValidCategories',...
        'All categories have pj = 0 or pj = 1; Fleiss'' kappa cannot be computed.');
end

if any(~valid)
    warning('fleiss:ZeroCategoryVariance',...
        'Some categories have pj = 0 or pj = 1; corresponding kj are set to NaN and ignored in the overall kappa.');
end

% Kappa for each category j
num_kj = sum(x .* (nRaters - x), 1);  % 1-by-K
kj = NaN(1, nCategories);
kj(valid) = 1 - num_kj(valid) ./ (c .* b(valid));

% Standard error of kj (same for all categories)
sekj = realsqrt(2 / c);

% z-statistics and p-values for kj
zkj  = kj ./ sekj;
pkj  = (1 - 0.5 * erfc(-abs(zkj) / realsqrt(2))) * 2;

% Overall Fleiss' kappa (weighted average of kj)
b_valid  = b(valid);
kj_valid = kj(valid);
d        = sum(b_valid);              % sum of b over valid categories

% Standard error of overall kappa
num_se = 2 * (d^2 - sum(b_valid .* (1 - 2 .* pj(valid))));
den_se = realsqrt(c) * d;

if den_se <= 0 || num_se < 0
    warning('fleiss:InvalidSE',...
        'Numerical issues in standard error computation; setting SE to NaN.');
    sek = NaN;
else
    sek = realsqrt(num_se) / den_se;
end

% Overall kappa
k = sum(b_valid .* kj_valid) / d;

% Confidence interval for kappa (normal approximation)
zcrit = abs(-realsqrt(2) * erfcinv(alpha)); % two-sided
ci    = k + [-1 1] * (zcrit * sek);

% z statistic and p-value for overall kappa
z = k / sek;
p = (1 - 0.5 * erfc(-abs(z) / realsqrt(2))) * 2;

% Landis & Koch classification
if isnan(k)
    landis = 'Not defined';
elseif k < 0
    landis = 'Poor agreement';
elseif k <= 0.20
    landis = 'Slight agreement';
elseif k <= 0.40
    landis = 'Fair agreement';
elseif k <= 0.60
    landis = 'Moderate agreement';
elseif k <= 0.80
    landis = 'Substantial agreement';
else
    landis = 'Perfect agreement';
end

% Build stats struct
stats = struct();
stats.kj              = kj;
stats.sekj            = sekj;
stats.zkj             = zkj;
stats.pkj             = pkj;
stats.pj              = pj;
stats.kappa           = k;
stats.se              = sek;
stats.ci              = ci;
stats.alpha           = alpha;
stats.z               = z;
stats.p               = p;
stats.nSubjects       = nSubjects;
stats.nCategories     = nCategories;
stats.nRaters         = nRaters;
stats.landisKochClass = landis;

% Textual output (if requested)
if displayopt
    tr = repmat('-',1,60);
    disp('FLEISS'' KAPPA FOR MULTIPLE RATERS');
    disp(tr);

    % Category-wise results
    fprintf('Category-wise kappa (kj):\n');
    fprintf('  ');
    fprintf('%0.4f  ', kj);
    fprintf('\n\n');

    fprintf('Standard error of kj (sekj): %0.4f\n\n', sekj);

    fprintf('z for kj:\n');
    fprintf('  ');
    fprintf('%0.4f  ', zkj);
    fprintf('\n\n');

    fprintf('p-values for kj:\n');
    fprintf('  ');
    fprintf('%0.4f  ', pkj);
    fprintf('\n\n');

    % Overall kappa
    disp(tr);
    fprintf('Fleiss'' (overall) kappa = %0.4f\n', k);
    fprintf('kappa error = %0.4f\n', sek);
    fprintf('kappa C.I. (alpha = %0.4f) = %0.4f \t %0.4f\n', alpha, ci(1), ci(2));
    disp(landis);
    fprintf('z = %0.4f \t p = %0.4f\n', z, p);
    if isnan(p)
        disp('Null hypothesis test not available: kappa cannot be computed reliably.');
    elseif p < alpha
        disp('Reject null hypothesis: observed agreement is not accidental');
    else
        disp('Accept null hypothesis: observed agreement is accidental');
    end
end

end
