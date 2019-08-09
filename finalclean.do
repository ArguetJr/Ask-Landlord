/* 



					POMS Single Family Characteristics
-------------------------------------------------------------------------------
--------------------------------------------------------------------------------
------------------------------------------------------------------------------*/



clear all
capture log close
set more off
global prof "C:\Users\DeadArrow\Documents\UC\Projects\Proficiency\Data\Cleaning"
cd "$prof"
log using "$prof\dp.txt", text replace



					*Loading Variables...*
use "$prof\single.dta", clear
tolower 





/*------------------------------------------------------------------------------
-------------------------Variable-----------------------------------------------
--------------------------------------------------------------------------------

---------------------				------------------			
Delinquency Measures				  Tenant Charact.
----------------------				-------------------
delnqnt									lenlease
dlqcshfl								tntincom
vndlinsd								lentenur
vndlouts
theft
noise
violence
drugs
dsrpothr


------------------					--------------------
Management Care						 Management Control
------------------					-------------------
ocmaintu								manager
omnttimu								mnglngth
omnttimp								plan2own
ownvisit								ownnum
maintcur								ownage
main3yr									ownsex
dlqnotfy								ownrace
dlqcllc									othrprop
dlqevict								numprop
dlqnthng								ownlive
dlqother								ohowlong
drptalk									rent
drpwrite								profit
drpscrty								proftcmp
drppolic								mainpcti							
drpevict
drpother
outmaint
outrent
outservc
outfees
kprent
kpmaint
kpupgrad
kpimpprp
kpservc
kptother



--------------------------------------------------------------------------------
-------------------------------52 Variables-------------------------------------
------------------------------------------------------------------------------*/



keep delnqnt dlqcshfl vndlinsd vndlouts theft noise violence drugs dsrpothr 			///
	 lenlease tntincom lentenur ocmaintu omnttimu omnttimp ownvisit maintcur main3yr 	///
	 dlqnotfy dlqcllc dlqevict dlqnthng dlqother drptalk drpwrite drpscrty drppolic 	///
	 drpevict drpother outmaint outrent outservc outfees kprent kpmaint kpupgra 		///
	 kpimpprp kpservc kptother manager mnglngth plan2own ownnum ownage ownsex 			///
	 orace othrprop numprop ownlive ohowlong rent profit proftcmp mainpcti type id 		///
	 metro region





/*------------------------------------------------------------------------------
-----------------------------Delinquency----------------------------------------
------------------------------------------------------------------------------*/

			 
*Encoding*
encode vndlinsd, gen(ivandl)
encode vndlouts, gen(ovandl)  
encode theft, gen(dtheft)
encode noise, gen(dnoise)
encode violence, gen(dviolence)
encode drugs, gen(ddrugs)
encode dsrpothr, gen(dother)
encode dlqcshfl, gen(dcashflw)
encode delnqnt, gen(dlinqnt)



*Recoding*  
loc rec `"( 1 = 3 "Frequently") (2 = 1 "Never") (3 = .a "Not Reported") (4/5 = 2 "Rare-Occasionly")"'
loc x `"ivandl ovandl dtheft dnoise dviolence ddrugs dother"' 
foreach i in `x' {
	recode `i' `rec',gen(`i'_r)
	}
*			   

recode dother ( 1 = 3 "Frequently") (2/3 = 1 "Never")(4/5 = 2 "Rare-Occasionly"), gen(dother_r2)

gen disorder = ivandl_r + ovandl_r + dnoise_r + ddrugs_r + dother_r
gen disoder2 = ivandl_r + ovandl_r + dnoise_r + ddrugs_r + dother_r2
drop disorder disoder2

egen disorder = rowtotal(ivandl_r ovandl_r dnoise_r ddrugs_r dother_r)
egen disorder2 = rowtotal(ivandl_r ovandl_r dnoise_r ddrugs_r dother_r2)

			   
recode dcashflw ( 3 = 1 "Never") ( 1 = 2 "Minor") ( 2 = 3 "Moderate") ///
				( 5 = 4 "Serious") ( 4 = .a "Not Reported"), gen (dcash_flow)
			   
recode dlinqnt ( 1 = 0 "No") ( 3 = 1 "Yes") (2 = .a "Not Reported"), gen(obvdelin)






/*------------------------------------------------------------------------------
-----------------------------Tenant Char.---------------------------------------
------------------------------------------------------------------------------*/


*Encoding*
encode lenlease, gen(xlease) 
encode tntincom, gen(tincom)
encode lentenur, gen(xtenur)


*Recoding*
recode xlease ( 6/7 = 0 "No Lease Required") ( 3 = 1 "M-M/ <1 yr") ( 1 = 2 "1 yr") ///
			  ( 2 = 3 "1 yr - <2 yr") ( 3 = 4 "2 yr") ( 4 = 5 "+2 yr") ///
			  ( 8 = .a "Not Reported"), gen(xlease_r)

recode tincom ( 2 = 1 "Lower Class") ( 3 = 2 "Middle Class") ( 5 = 3 "Upper Class") ///
				( 1 = .b "Don't Know") ( 4 = .a "Not Reported"), gen(tinc_r)

recode xtenur ( 5 = 1 "1 yr") ( 6 = 2 "2 yr") ( 1 = 3 "3-5 yr") ( 3 = 4 "+5 yr") ///
			  ( 2 = .b "Don't Know") ( 4 = .a "Not Reported"), gen(xstay)
				
				

				
/*------------------------------------------------------------------------------
-----------------------------Mang. Char-.---------------------------------------
------------------------------------------------------------------------------*/


*Encoding*
encode ocmaintu, gen(owncont)
encode dlqnotfy, gen(dcnotif)
encode dlqcllc, gen(dccolct)
encode dlqevict, gen(dcevict)
encode dlqnthng, gen(dcnothn)
encode dlqother, gen(dcother)
encode drptalk, gen(dtalk)
encode drpwrite, gen(dwrite)
encode drpscrty, gen(dpsecrty)
encode drppolic, gen(dpolice)
encode drpevict, gen(devict)
encode drpother, gen(dlother)
encode kprent, gen(krent)
encode kpmaint, gen(kmaint)
encode kpupgra, gen(kupgrd)
encode kpimpprp, gen(kimprov)
encode kpservc, gen(kserv)
encode kptother, gen(kother)


*Recoding
loc car `"( 1 = 0 "No") ( 2 = .b "Not Applicable") ( 3 = .a "Not Reported") ( 4 = 1 "Yes")"'
loc z `"owncont dcnotif dccolct dcevict dcnothn dcother dtalk dwrite dpsecrty dpolice devict dlother krent kmaint kupgrd kimprov kserv kother"' 
	foreach i in `z' {
			recode `i' `car', ///
			gen(`i'_r)
	}
*

*Encoding Again*
encode omnttimu, gen(ownx)
encode omnttimp, gen(pownx)
encode ownvisit, gen(ovisit)
encode maintcur, gen(maintcar)
encode main3yr, gen(maintplan)


*Recoding Again*
loc main `" ( 4 = .a "Not Reported")"'
loc y `"maintcar maintplan"'
	foreach i in `y' {
		recode `i' `main', gen(`i'_r)
	}
*

recode ownx ( 4 = 1 "<1 hr/week") ( 1 = 2 "1-8 hrs/week") ( 2 = 4 "25=40 hrs/week") ///
			( 6 = .b "Not Applicable") ( 7 = .a "Not Reported"), gen(ownx_r)

recode pownx ( 6 = .b "Not Applicable") ( 7 = .a "Not Reported"), gen(pownx_r) 
revrs pownx_r

recode ovisit ( 6 = 0 "Never") ( 4 = 1 "< 1 month") ( 1 = 2 "Once a Month") ///
			  ( 2 = 4 "Once a Week") ( 7 = .b "Not Applicable") ///
			  ( 8 = .a "Not Reported"), gen(ovisit_r)



			  
/*------------------------------------------------------------------------------
---------------------------------Mng Control------------------------------------
------------------------------------------------------------------------------*/

encode manager, gen(emply_mng)
encode mnglngth, gen(mngx)
encode plan2own, gen(p2own)
encode ownsex, gen(mfown)
encode orace, gen(ownrc)
encode othrprop, gen(numxprop)
encode ownlive, gen(ownhome)
encode ohowlong, gen(olength)
encode profit, gen(ynprofit)
encode proftcmp, gen(profitcmpr)
encode mainpcti, gen(incmain)



recode numprop (99998/99999 = .b "Missing"), gen(xprop)
recode emply_mng ( 1/2 = 0 "No") ( 3 = 1 "Yes"), gen(mng_r)
recode ownage ( 98/99 = .a "Not Reported"), gen(ownage_r)
recode mfown ( 2 = 0 "Male") ( 3 = .b "Missing") ( 4 = .a "Not Reported"), gen(mfown_r)
recode ownrc ( 4 = .b " Not Applicable") ( 5 = .a "Not Reported"), gen(ownrc_r)
recode rent ( 9998 = .a "Not Reported"), gen(rent_r)



recode ownhome ( 1/5 = 0 "Outside United States") ( 8 = 1 "United States") ///
				( 6 = .b "Not Reported") ( 7 = .a "Not Applicable"), gen(ohome_r)
				

recode incmain ( 9 = 0 "None") ( 8 = 1 "Less than 5%") ( 1 = 3 "10-19%") ///
				( 2 = 4 "20-29%") ( 3 = 5 "30-29%") ( 4 = 6 "40-49%") ///
				( 5 = 2 "5-9%") ( 6 = 7 "50-74%") ( 7 = 8 "+75%") ///
				( 10 = .a "Not Reported"), gen(incmain_r)

recode profitcmpr ( 1 = .b "Don't know, Not Sure") ( 2 = 1 "Less Profitable") ///
				( 5 = 2 "Same Profitably") ( 4 = .a "Not Reported"), gen(profcompr)

recode ynprofit ( 1 = .b "Don't Know, Not Sure") ( 2 = 1 "Broke Even") ( 3 = 2 "Loss") ///
			  ( 4 = .a "Not Reported") ( 5 = 3 "Made Profit"), gen(profit_r)


recode mngx ( 4 = 1 "<1 yr") ( 1 = 2 "1-<3 yr") ( 2 = 3 "3-<5 yr") ///
			( 3 = 4 "5+ yr") ( 5 = .b "Not Applicable") ( 6 = .a "Not Reported") ///
			, gen(mngx_r)
			
			
recode p2own ( 5 = 1 "1 yr") ( 6 = 2 "2 yrs") ( 1 = 3 "3-5 yrs") ( 3 = 4 "5+ yrs") ///
			 ( 2 = .b "Don't Know") ( 4 = .a "Not Reported"), gen(p2own_r)


recode numxprop ( 1 = 0 "No") ( 2 = .b "Not Applicable") ( 3 = .a "Not Reported") ///
				( 4 = 1 "Yes"), gen(othrprop_r)


recode olength ( 5 = 1 "<1 yr") ( 1 = 2 "1-3 yrs") ( 3 = 2 "3-5 yrs") ///
			   ( 4 = 3 "5-10 yrs") ( 2 = 4 "+10 yrs") ( 6 = .b "Not Applicable") ///
			   ( 7 = .a "Not Reported"), gen(olength_r)





/*
--------------------------------------------------------------------------------
-------------*Keeping Variables of Choce*---------------------------------------
--------------------------------------------------------------------------------
*/

keep id type metro ownnum ivandl_r ovandl_r dtheft_r dnoise_r dviolence_r ddrugs_r ///
	 dother_r dcash_flow obvdelin xlease_r tinc_r xstay owncont_r dcnotif_r dccolct_r ///
	 dcevict_r dcnothn_r dcother_r dtalk_r dwrite_r dpsecrty_r dpolice_r devict_r ///
	 dcnothn_r dcother_r dtalk_r dwrite_r dpsecrty_r dpolice_r devict_r dlother_r ///
	 krent_r kmaint_r kupgrd_r kimprov_r kserv_r kother_r maintcar_r maintplan_r ///
	 ownx_r pownx_r revpownx_r ovisit_r xprop mng_r ownage_r mfown_r ownrc_r ///
	 rent_r incmain_r profcompr profit_r mngx_r p2own_r othrprop_r olength_r ///
	 ohome_r disorder disorder2




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
