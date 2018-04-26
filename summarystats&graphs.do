*2017 summary stats & graphs 

*I)SET UP
set more off
capture log close
clear
global input "C:\HarvardData\Modified Datasets"
global path "C:\HarvardData\Outputs" 
log using "$path\log files\summarystats_2017.txt", replace


use "$path\working data\2017allteachers.dta", clear

*II) SUMMARY STATS


**1) OVERALL SUMMARY STATS 
* graph new teachers, by year 
tab newteacher_2017
hist newteacher_2017 if newteacher==1, by(admin_num) freq


*mean wait time for new teachers, by year 
sum wait if newteacher_2017==1

***1)TEACHER QUALIFICATIONS BEFORE JOINING***
*GPA by gender
bysort female: sum gpa, d 

graph bar gpa, over(gender) ytitle("Mean GPA (out of 100)") blabel(total)
graph export "$path\graphs&stats\gpa_gender.png",  replace

*age, years of experience, wait period before recruitment
sum age yearsofexp wait, d

*by school type (private, pub)
bysort authority: sum age yearsofexp wait, d

* teaching subjects by demand (as proxied by wait period)
graph hbar wait, over(main_spec) blabel(total) ytitle("Average wait time in years")
graph export "$path\graphs&stats\wait_subject.png", replace

* wait by region
graph bar wait, over(admin_num) ytitle("Average wait time in years")
graph export "$path\graphs\wait_region.png", replace



*DISTRBUTION OF TEACHERS, BY DEGREE and gender
bysort female: tab degree_num

hist degree_num, by(gender) percent xlabel(7 5 1 6, valuelabel) addl legend(off)
graph export "$path\graphs&stats\degree_gender.png", replace

****2) ON THE JOB CHARACTERISTICS*****
*dist by nationality
bysort female: tab nat
bysort nat: sum yearsofexp age 

*employee status for 2017
tab employeestatus_simplified
hist employeestatus_simplified, freq addl xlabel(0 1 2 3, valuelabel)

*age distribution for early retirees
tab age if employeestatus_simplified==2
hist age if employeestatus_simplified==2, discrete freq addl title("early retirees") xlab(21/100)

*distribution of teachers, by educationlevel taught, and gender:
bysort female: tab educationlevel 

bysort authority: sum age, d

*DISTRIBUTION OF TEACHERS, BY TEACHING SUBJECT
tab main_spec

*ON THE JOB 

*NEW TEACHERS (joined in 1438)
tab newteacher
bysort gender: tab newteacher

sum wait if newteacher==1

*SUMMARY

*recruitment of new teachers, by year 


*DISTRBUTION OF SUPERVISOR EVALUATION, BY GENDER 
bysort female: tab generaleval_num

hist generaleval_num, by(authority) xlabel(1 2 3 4, valuelabel) percent addl
graph export "$path\graphs&stats\eval_authority.png", replace

*current perfromance (, on the job evaluation, out of 100) 
bysort female: sum currentpeformance_2017, d


*REQUESTED BY ADITI 
*wait period over years, 


log close 

/*





* probit of teacher performance 
* f(excllence)=personal char(age,female, years of exp, gpa) school char
probit above_average age female yearsofexp gpa currentperformance classallocation, nocons vce(cluster schoolnumberinnoorsystem)
outreg 



*improved 
probit improved 


*reg currentpeformance
reg currentpeformance age female yearsofexp gpa classallocation if previousperformancefrom==100, nocons vce(cluster schoolnumberinnoorsystem)

*look at R^2


*can previous perf predict future perf ?


log close 

