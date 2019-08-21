/* 



					POMS Single Family Characteristics
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

Instructions: 


	This do-file simply loads and cleans all the variables for Property Owners
and Managers Survey from the years 1995-1996. Each section provides brief
details about the step being run. After this file, there is separate file for
analysis and then a separate one for a sensitivity analysis. 				






--------------------------------------------------------------------------------
							*Loading Variables...*
--------------------------------------------------------------------------------


	Copy this link and download it from my OneDrive. Stata has trouble with 
	downloading directly from Onedrive. Unfortunately, I cannot automate loading 
	the data for you. 

https://mailuc-my.sharepoint.com/:u:/g/personal/arguetjr_mail_uc_edu/ETn3VbpawCtLo11liuEItwcB1v36aAOtomjQWolsogMqRw?e=ZCL1sk



--------------------------------------------------------------------------------
						*Standard Startup Procedure*
--------------------------------------------------------------------------------*/




clear all
capture log close
set more off
tolower 






/*------------------------------------------------------------------------------
-------------------------------Variables----------------------------------------
--------------------------------------------------------------------------------

---------------------			
Disorder Measures				  
----------------------																		
vndlinsd								
vndlouts
theft
noise
violence
drugs
dsrpothr


------------------					--------------------
Management Char.						Controls
------------------					-------------------
omnttimu								numprop								
maintcur								olength
mainpcti								type
timespent							
occlean
ocrepair

--------------------------------------------------------------------------------
-------------------------------16 Variables-------------------------------------
------------------------------------------------------------------------------*/


keep vndlinsd vndlouts theft noise violence drugs dsrpothr 			/// 	/*Dependent Variables*/
	 omnttimu maintcur mainpcti timespent occlean ocrepair			/// 	/*Independent Variables*/
	 numprop olength type id										   		/*Control Variables*/





/*------------------------------------------------------------------------------
-----------------------------Disorder----------------------------------------
------------------------------------------------------------------------------*/

			 
*Encoding*

encode vndlinsd, gen(ivandl)
encode vndlouts, gen(ovandl)  
encode theft, gen(dtheft)
encode noise, gen(dnoise)
encode violence, gen(dviolence)
encode drugs, gen(ddrugs)
encode dsrpothr, gen(dother)





*Recoding - Type 1*  

loc rec1 `"( 1 = 3 "Frequently") (2 5 = 1 "Never-Rarely") (3 = .a "Not Reported") (4 = 2 "Occasionly")"'
loc x `"ivandl ovandl dtheft dnoise dviolence ddrugs dother"' 
foreach i in `x' {
	recode `i' `rec1',gen(`i'_1)
	}


egen disorder1 = rowtotal(ivandl_1 ovandl_1 dnoise_1 ddrugs_1 dother_1), miss
	
	
	

*Recoding - Type 2*  

loc rec2 `"( 1 4 = 3 "Occasionally-Frequently") (2  = 1 "Never") (3 = .a "Not Reported") (5 = 2 "Rarely")"'
loc x `"ivandl ovandl dtheft dnoise dviolence ddrugs dother"' 
foreach i in `x' {
	recode `i' `rec2',gen(`i'_2)
	}


egen disorder2 = rowtotal(ivandl_2 ovandl_2 dnoise_2 ddrugs_2 dother_2), miss
	
	


*Recoding - Type 3*  

loc rec3 `"( 1 = 3 "Frequently") (2 = 1 "Never") (3 = .a "Not Reported") (4/5 = 2 "Rare-Occasionally")"'
loc x `"ivandl ovandl dtheft dnoise dviolence ddrugs dother"' 
foreach i in `x' {
	recode `i' `rec3',gen(`i'_3)
	}
*	

egen disorder3 = rowtotal(ivandl_3 ovandl_3 dnoise_3 ddrugs_3 dother_3), miss




*Recoding dother_r3*

recode dother (1 = 3 "Frequently") (2 3 = "Never-Miss") (4/5 = 2 Rarely-Occasionally"), gen (dother_r3)






/*------------------------------------------------------------------------------
-----------------------------Independent Variables------------------------------
------------------------------------------------------------------------------*/


*Encoding*

encode omnttimu, gen(timespent)
encode mainpcti, gen(incmain)




*Recoding Independent Variables*

loc miss `"( 99998 = .a "Missing")"'
loc z `"occlean ocrepair"' 
foreach i in `z' {
	recode `i' `miss',gen(`i'_r)
	}
*		




recode timespent ( 4 6 = 1 "Less than 1 hr/week") ( 1 = 2 "1-8 hr/week") 				///
				 ( 3 = 3 "9-24 hr/week") (2 = 4 "25-40 hr/week") (5 = 5 "40+ hr/week") ///
				 ( 7 = .a "Not Reported"), gen(timespent_r)

				 
recode incmain ( 9 = 0 "None") ( 8 = 1 "Less than 5%") ( 1 = 3 "10-19%") 	          ///
				( 2 = 4 "20-29%") ( 3 = 5 "30-29%") ( 4 = 6 "40-49%")				 ///
				( 5 = 2 "5-9%") ( 6 = 7 "50-74%") ( 7 = 8 "+75%") 					///
				( 10 = .a "Not Reported"), gen(incmain_r)
			



/*------------------------------------------------------------------------------
---------------------------------Control Variables------------------------------
------------------------------------------------------------------------------*/


*Encoding*
encode type, gen(type_r)
encode ohowlong, gen(olength)



*Recoding*

recode numprop (99998/99999 = .b "Missing"), gen(xprop)


recode olength ( 5 = 1 "<1 yr") ( 1 = 2 "1-3 yrs") ( 3 = 2 "3-5 yrs")             ///
			   ( 4 = 3 "5-10 yrs") ( 2 = 4 "+10 yrs") ( 6 = .b "Not Applicable") ///
			   ( 7 = .a "Not Reported"), gen(olength_r)






/*--------------------------------------------------------------------------------
-------------*Keeping Variables of Interest---------------------------------------
--------------------------------------------------------------------------------*/


keep ivandl_1 ovandl_1 dtheft_1 dnoise_1 dviolence_1 ddrugs_1 dother_1 		 ///
     ivandl_2 ovandl_2 dtheft_2 dnoise_2 dviolence_2 ddrugs_2 dother_2 		 ///
	 ivandl_3 ovandl_3 dtheft_3 dnoise_3 dviolence_3 ddrugs_3 dother_3 		 ///
	 disorder1 disorder2 disorder3 dother_r3 timespent_r incmain_r occlean_r ///
	 ocrepair_r olength_r xprop id type_r olength_r




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

							
							
							
If there are any issues loading the variables from the website please send me
and email such that we can resolve this issue. Other than that, please proceed
to the sensitivity analysis file for assumption checks and verifying the data.
							Have Fun! 							
							


