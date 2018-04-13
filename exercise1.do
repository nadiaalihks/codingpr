/** IPA CI Exercise 1 do file
**Author: Nadia Ali
* Input: Main Dataset, New Variables, New Observations
* Outputs: - merged.dta
           - main dataset_cleaned.dta 
**Date: 4/30/2018            **/

* basics: 
cap log close 
clear
set mem 100m 
set more off 
set seed 1234 

global path "C:\Users\naa976\Desktop\Stata\Nadia Ali Answers_IPA CI"
global input "C:\Users\naa976\Desktop\Stata\IPA CI Prompt folder for Hiring Candidates\Partie 2\Exercice 1"

cd "$path"
log using "$path/exercise1.txt", replace


*1)importing
import delimited "$input/New Variables.csv"
save newvariables.dta, replace 
clear
use "$input/Main Dataset.dta"
* merge in new variables for existing obs
merge 1:1 uniqueid using "newvariables.dta"
drop _merge
save merged, replace
* add new observations 
append using "$input/New Observations.dta"
save merged, replace

*2) high frequency checks
*1) median and average for  
*are there missing values for surveytime2?
sum surveytime if survey_complete,d
*mean = 7202 s ie 2 hours 
*median=7165
codebook surveyor
bysort surveyor: egen indiv_average = mean(surveytime) if survey_complete
tab indiv_average
* no major differences between surveyors

*is hhid unqiue?
sort hhid, stable
codebook hhid
* no 
* list them out
duplicates l 
* 0 duplicates in terms of all vars  
duplicates l hhid 
duplicates tag hhid, gen(dup)
list if dup

** unclear what to do about duplicate hhid**

*3) cleaning 
*a) replace PII 
 
sort surveyor, stable
outsheet uniqueid suveyor "$path/PII_clean.csv", comma replace
encode surveyor, gen(surveyor1)
_strip_labels surveyor1
rename surveyor1 surveyor

/*
foreach i of var surveyor {
di `i'
}
replace j=j+1
replace surveyor_num=j if surveyor =='`i'' 
}

foreach i of var surveyor {
replace j=j+1
replace surveyor_num=j if surveyor ==`i'
}

*/

****incorrect syntax***

*b)  Assign missing extension values (-666=., -999= .d, -997 = .r, -777= -555=.n)
local vars burglaryyn vandalismyn trespassingyn
foreach v of varlist `vars' {
	recode `v' (-666=.) (-999= .d) (-997 = .r) (-777=.b) (-555=.n)
	}

save "$path/main dataset_cleaned.dta", replace
* at end run with full stata window 

log close 
