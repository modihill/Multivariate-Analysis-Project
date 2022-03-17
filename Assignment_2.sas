/* Assignment 2 - Multivariate Analysis */
/* Name : Modi Hill Jigishumar */
/* Student Number : S3827516 */

/* ********** */
/* ********** */
/* Question 1 */
/* ********** */
/* ********** */
data THC;
infile '/home/u49669986/Math 1309/Assignment_2/THC-1.csv' 
dlm = ',';
input varieties chem1-chem13;
run;


/* 1.1 Means of 13 different chemical compounds */
proc means data=THC;
var chem1-chem13;
run;


/* 1.2 Correlation Matrix and a Scatterplot */
proc sgscatter data=THC;
  title "Scatterplot Matrix for Chemicals";
  matrix chem1-chem13;
run;
title;


/* 1.3.A-B-C-D-E 1.4.I Principal Component Analysis from covariance matrix */
ods graphics on;
proc princomp data=THC cov plots=scree plots=score plots=profile n=3;
var chem1-chem13; 
run;


/* 1.4.A-B-C-D-E-F-G-H-J Principal Component Analysis from correlation matrix */
ods graphics on;
proc princomp data=THC plots=scree plots=profile plots=pattern plots=score n=10;
var chem1-chem13; 
run;


/* 1.4.K */
ods graphics on;
proc princomp data=THC std plots=score n=3;
var chem1-chem13; 
run;


/* 1.4.L 95% Confidence Interval */
proc iml;
use THC;
read all var {"chem1" "chem2" "chem3" "chem4" "chem5" "chem6" "chem7" "chem8" "chem9" "chem10" "chem11" "chem12" "chem13"} into x;
corr = corr(x);
eig = eigval(corr);
eig_1 = eig[1];
eig_2 = eig[2];
eig_3 = eig[3];
eig_4 = eig[4];
eig_5 = eig[5];
CI_1_lower=eig[1]/(1+1.96*sqrt(2/178));
CI_1_upper=eig[1]/(1-1.96*sqrt(2/178));
CI_2_lower=eig[2]/(1+1.96*sqrt(2/178));
CI_2_upper=eig[2]/(1-1.96*sqrt(2/178));
CI_3_lower=eig[3]/(1+1.96*sqrt(2/178));
CI_3_upper=eig[3]/(1-1.96*sqrt(2/178));
CI_4_lower=eig[4]/(1+1.96*sqrt(2/178));
CI_4_upper=eig[4]/(1-1.96*sqrt(2/178));
CI_5_lower=eig[5]/(1+1.96*sqrt(2/178));
CI_5_upper=eig[5]/(1-1.96*sqrt(2/178));
print eig_1 CI_1_lower CI_1_upper;
print eig_2 CI_2_lower CI_2_upper;
print eig_3 CI_3_lower CI_3_upper;
print eig_4 CI_4_lower CI_4_upper;
print eig_5 CI_5_lower CI_5_upper;
run;

/* ------------------------------------------------------------------------------------------------------------------- */


/* ********** */
/* ********** */
/* Question 2 */
/* ********** */
/* ********** */


/* 2.1 */
data SocioEconomics;
input Population School Employment Services HouseValue;
datalines;
5700 12.8 2500 270 25000
1000 10.9 600 10 10000
3400 8.8 1000 10 9000
3800 13.6 1700 140 25000
4000 12.8 1600 140 25000
8200 8.3 2600 60 12000
1200 11.4 400 10 16000
9100 11.5 3300 60 14000
9900 12.5 3400 180 18000
9600 13.7 3600 390 25000
9600 9.6 3300 80 12000
9400 11.4 4000 100 13000
;


/* 2.2 */
proc means data=SocioEconomics;
run;


/* 2.3-4*/
proc factor data=SocioEconomics simple corr rotate=varimax;
run;


/* 2.5 */
proc princomp data=SocioEconomics;
run;


/* 2.6 */
proc factor data=SocioEconomics n=5 score;
run;


/* ------------------------------------------------------------------------------------------------------------------- */

/* ********** */
/* ********** */
/* Question 3 */
/* ********** */
/* ********** */

data combine;
infile '/home/u49669986/Math 1309/Assignment_2/banknote.csv' 
dlm = ',';
input length left right bottom top diag type$;
run;


/* 3.A-B-C */
proc stepdisc data=combine wcov wcorr pcorr pcov;
class type;
run;




/* ------------------------------------------------------------------------------------------------------------------- */

/* ********** */
/* Question 4 */
/* ********** */
/* ********** */


/* 4.1 */
proc sql noprint;
update combine
set type = "real" where type = "1";

update combine
set type = "fake" where type = "2";

quit;

data combine_real;
   set combine;
   if (type = "real") then output;
run;

data combine_fake;
   set combine;
   if (type = "fake") then output;
run;


/* 4.2 */
proc means data=combine_real;
  title "Summary for Real Notes";
var length left right top bottom diag;
run;
title;

/* 4.3 */
proc means data=combine_fake;
  title "Summary for fake Notes";
var length left right top bottom diag;
run;
title;

/* 4.4 */
proc sgscatter data=combine_real;
  title "Scatterplot Matrix for Real Notes";
  matrix length left right top bottom diag;
run;
title;


/* 4.5 */
proc sgscatter data=combine_fake;
  title "Scatterplot Matrix for fake Notes";
  matrix length left right top bottom diag;
run;
title;


/* 4.6 */
data test;
input length left right bottom top diag;
cards;
214.9 130.1 129.9 9 10.6 140.5
;
run;


proc discrim data=combine pool=test crossvalidate testdata=test
testout=a;
class type;
var length left right bottom top diag;
priors "real"=0.99 "fake"=0.01;
run;

proc print;
run;


filename sas "/home/u49669986/Math 1309/Assignment_2/Assignment_2.sas";


ods listing close;

ODS pdf file="/home/u49669986/Math 1309/Assignment_2/Assignment_2.pdf";

data _null_;

  infile sas ;

  input;

  temp=_infile_;

  file print ods;

  put _ods_;

run;

ODS pdf CLOSE;

ods listing;