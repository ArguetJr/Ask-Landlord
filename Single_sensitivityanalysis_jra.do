/* 



					POMS Single Family Characteristics
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

Instructions: 


	This do-file conducts a sensitivity analysis of the prior cleaned variables.
Take this portion of the do-file very slowly, as if you run the whole file, it will
breeze by all the graphs, charts, analyses, and descriptive statistics that you are
interested in. This portion of the do-file also does conduct some statistical analyses.
The parts that conduct statistical analyses are purely for post-estimation procedures
that look at the sensitivity of some of the coding values. 

	Please refer to the clean file for the variables to be used in this current analyses.
If you do not have those variables, please refer back to do-file where the cleaning
procedures are labeled and kept. 

	Please refer to the next section for all of the variables. Instead of constantly
popping up desc or looking through the files, all the codenames are provided right
there. 

	Finally, some of the commands within this do-file are not automatically put in
Stata. So below this final paragraph, there will be a line of commands that you may 
or may not have. SSC install will not download some of these automatically so please
search for them using the command `search`. 

List of commands:

- mdesc
- misschk 
- factortest
- sortl
- mcp2


--------------------------------------------------------------------------------
-------------------------Variables----------------------------------------------
--------------------------------------------------------------------------------
								id  


						-------------------------------			
						Dependent/Disorder Measures				  
						-------------------------------		
	  ivandl_1 ovandl_1 dtheft_1 dnoise_1 dviolence_1 ddrugs_1 dother_1 disorder1 
	  
      ivandl_2 ovandl_2 dtheft_2 dnoise_2 dviolence_2 ddrugs_2 dother_2 disorder2
	 
	  ivandl_3 ovandl_3 dtheft_3 dnoise_3 dviolence_3 ddrugs_3 dother_3 disorder3
	 


				-------------------------------------
					Independent Variables
				-------------------------------------
					timespent_r 	incmain_r 	
	  
					occlean_r o		crepair_r 
	  
	  
				-------------------------------------
					Control Variables
				-------------------------------------
	  
					olength_r 		xprop  
					type_r		 	olength_r
		
		
		
		
--------------------------------------------------------------------------------
-------------------------Disorder Measure-------------------------------------
--------------------------------------------------------------------------------*/		

*Looking at the histograms and distributions of each variable*
*If you want to skip this section - they are all non-normal*


hist ivandl_1 
hist ovandl_1 
hist dnoise_1  
hist ddrugs_1 
hist dother_1


hist ivandl_2 
hist ovandl_2 
hist dnoise_2  
hist ddrugs_2
hist dother_2

hist ivandl_3 
hist ovandl_3 
hist dnoise_3  
hist ddrugs_3
hist dother_3
hist dother_r3



*Comparing differences in coding between all the codings of disorder

*Inside Vandalism*

signrank ivandl_1=ivandl_2
signrank ivandl_1=ivandl_3
signrank ivandl_2=ivandl_3


*Outside Vandalism*

signrank ovandl_1=ovandl_2
signrank ovandl_1=ovandl_3
signrank ovandl_2=ovandl_3



*Noise*

signrank dnoise_1=dnoise_2
signrank dnoise_1=dnoise_3
signrank dnoise_2=dnoise_3


*Drugs*

signrank ddrugs_1=ddrugs_2
signrank ddrugs_1=ddrugs_3
signrank ddrugs_2=ddrugs_3


*Other Disorders*

signrank dother_1=dother_2
signrank dother_1=dother_3
signrank dother_2=dother_3

ttest dother_3==dother_r3


*Factor-testing and internal consistency for coding version 1 of disorder*

pwcorr ivandl_1 ovandl_1 dnoise_1 ddrugs_1 dother_1
factortest ivandl_1 ovandl_1 dnoise_1 ddrugs_1 dother_1
factor ivandl_1 ovandl_1 dnoise_1 ddrugs_1 dother_1
rotate, oblimin oblique
sortl
alpha ivandl_1 ovandl_1 dnoise_1 ddrugs_1 dother_1	
		
		
*Factor-testing and internal consistency for coding version 2 of disorder*		
pwcorr ivandl_2 ovandl_2 dnoise_2 ddrugs_2 dother_2
factortest ivandl_2 ovandl_2 dnoise_2 ddrugs_2 dother_2
factor ivandl_2 ovandl_2 dnoise_2 ddrugs_2 dother_2
rotate, oblimin oblique
sortl
alpha ivandl_2 ovandl_2 dnoise_2 ddrugs_2 dother_2
				
		
	
*Factor-testing and internal consistency for coding version 3 of disorder*		
pwcorr ivandl_3 ovandl_3 dnoise_3 ddrugs_3 dother_3
factortest ivandl_3 ovandl_3 dnoise_3 ddrugs_3 dother_3
factor ivandl_3 ovandl_3 dnoise_3 ddrugs_3 dother_3
rotate, oblimin oblique
sortl
alpha ivandl_3 ovandl_3 dnoise_3 ddrugs_3 dother_3	
		
	
	
*Factor-testing and internal consistency for coding version 3 of disorder with other-disorder_r3*			
pwcorr ivandl_3 ovandl_3 dnoise_3 ddrugs_3 dother_r3
factortest ivandl_3 ovandl_3 dnoise_3 ddrugs_3 dother_r3
factor ivandl_3 ovandl_3 dnoise_3 ddrugs_3 dother_r3
rotate, oblimin oblique
sortl
alpha ivandl_3 ovandl_3 dnoise_3 ddrugs_3 dother_r3		



*Creating disorder4 -> disorder3 with other-disorder_r3

egen disorder4 = rowtotal(ivandl_1 ovandl_1 dnoise_1 ddrugs_1 dother_r3), miss

ttest disorder3==disorder4


		
		
*The following analyses will primarily focus on disorder3 and disorder4*		
		
/*--------------------------------------------------------------------------------
-------------Investigating Missing Variables in Disorder--------------------------
--------------------------------------------------------------------------------*/				
		
		
mdesc

egen nmis=rmiss2(ivandl_3 ovandl_3 dnoise_3 ddrugs_3 dother_3)	
tab nmis


misschk ivandl_3 ovandl_3 dnoise_3 ddrugs_3 dother_3 disorder3 disorder4, gen(miss)


fre disorder3 disorder4





/*--------------------------------------------------------------------------------
---------Investigating Missing Variables in Independent Variables-----------------
--------------------------------------------------------------------------------*/				
		
		
egen imis=rmiss2(timespent_r olength_r occlean_r ocrepair_r)	
tab imis


misschk timespent_r incmain_r occlean_r ocrepair_r, gen(miss)


fre occlean_r occrepair_r	
		
		
		
		
		
/*--------------------------------------------------------------------------------
---------------------------Descriptive Statistics---------------------------------
--------------------------------------------------------------------------------*/				


*Dependent Variables*
sum ivandl_3 ovandl_3 dnoise_3 ddrugs_3 dother_3
sum disorder3 disorder4

sum disorder3, d
sum disorder4, d



*Independent Variables*
sum timespent_r incmain_r occlean_r ocrepair_r	


*Control Variables*
sum xprop olength_r type_r

		
*Scatter plots*
gr matrix disorder3 timespent_r incmain_r occlean_r ocrepair_r	
gr matrix disorder3 xprop olength_r type_r	

gr matrix disorder4 timespent_r incmain_r occlean_r ocrepair_r
gr matrix disorder4 xprop olength_r type_r
		
		
		
		
		
/*--------------------------------------------------------------------------------
---------------------------Outliers Statistics-----------------------------------
--------------------------------------------------------------------------------*/				
		
extremes disorder3 timespent_r incmain_r occlean_r ocrepair_r xprop olength_r type_r	


*Can drop all of the id's that are present, however, they have no influence on the Poisson Regression models





/*--------------------------------------------------------------------------------
---------------------------Post-Estimations Statistic----------------------------
--------------------------------------------------------------------------------*/	



*Looking at Predictive Probabilities*

quietly poisson disorder3 i.timespent_r i.incmain_r occlean_r ocrepair_r, nolog
mgen, pr(0/9) meanpred stub(psn)
label var psnobeq "Observed Proportion"
label var psnpreq "Poisson Prediction"
label var psnval "Count of Disorder"
list psnval psnobeq psnpreq in 1/10

graph twoway connected psnobeq psnpreq psnval, ///
	ytitle("Probability") ylabel(0(.1).4) xlabel(0/9) msym(O Th)


	
	
	
*Obtaining Predictions*
quietly poisson disorder3 timespent_r incmain_r occlean_r ocrepair_r, nolog	
predict injhat
predict idx, xb
generate exp_idx = exp(idx)
summarize disorder injhat exp_idx idx
	
	
	
*Plotting Residuals for Linearity*
quietly poisson disorder3 timespent_r incmain_r occlean_r ocrepair_r, nolog	
predict ir
predict n
predict stdp
qqplot ir n
qqplot ixb stdp




*Testing Goodness-Of-Fit*

quietly poisson disorder3 i.timespent_r i.incmain_r occlean_r ocrepair_r, nolog
estat gof
nbreg disorder3 i.timespent_r i.incmain_r occlean_r ocrepair_r


quietly poisson disorder4 i.timespent_r i.incmain_r occlean_r ocrepair_r, nolog
estat gof
nbreg disorder4 i.timespent_r i.incmain_r occlean_r ocrepair_r




	
*Ensuring no other model is best*

quietly poisson disorder3 timespent_r incmain_r occlean_r ocrepair_r, nolog
prcounts pois, max(8) plot
nbreg disorder3 timespent_r incmain_r occlean_r ocrepair_r, nolog
prcounts nbreg, max(8) plot
zip disorder3 timespent_r incmain_r occlean_r ocrepair_r, nolog, inf(timespent_r incmain_r occlean_r ocrepair_r) nolog
prcounts zip, max(8) plot
zinb timespent_r incmain_r occlean_r ocrepair_r, nolo, inf(timespent_r incmain_r occlean_r ocrepair_r) nolog
prcounts zinb, max(8) plot


list poisval poisobeq poispreq poisoble poisprle in 1/10

generate devpois = poisobeq - poispreq

generate devnbreg = poisobeq - nbregpreq

generate devzip = poisobeq - zippreq

generate devzinb = poisobeq - zinbpreq

label var devpois "poisson"
label var devnbreg "nbreg"
label var devzip "zip"
label var devzinb "zinb"
label var poisval "Count"



graph devpois devnbreg devzip devzinb poisval, ///
	c(llll) s(OSTp) xlab(0 1 to 8) ylab(-.1,-.05,0,.05,.1)  ///
	yline(-.1,-.05,0,.05,.1) l2title("Deviation from Observed") gap(4)


	
	
	
	
	
	
	
	
	
	

/*				Notes/Comments Below After Signature
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------							
			               _________               
                            ______  /_____ _____  __
                            ___ _  /_  __ `/_  / / /
                            / /_/ / / /_/ /_  /_/ / 
                            \____/  \__,_/ _\__, /  
                                           /____/   

										   
							email: arguetjr@mail.uc.edu	
							
							University of Cincinnati			   
							Graduate Student
							BA, MSC

								
	
	
	
	
										