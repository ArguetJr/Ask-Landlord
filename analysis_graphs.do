/* 



					POMS Single Family Characteristics
-------------------------------------------------------------------------------
--------------------------------------------------------------------------------
------------------------------------------------------------------------------*/



clear all
capture log close
set more off
global prof "C:\Users\DeadArrow\Documents\UC\Projects\Proficiency\Data\Analysis"
cd "$prof"
log using "$prof\da.txt", text replace


					*Loading Variables...*
use "$prof\analysis_v1.dta", clear





/*------------------------------------------------------------------------------
-----------------------------------Delinquency----------------------------------
------------------------------------------------------------------------------*/

pwcorr ivandl_r ovandl_r dtheft_r dnoise_r dviolence_r ddrugs_r dother_r t_delin
*dcash_flow obvdelin


gen t_delin = ivandl_r + ovandl_r + dtheft_r + dnoise_r + dviolence_r + ddrugs_r + dother_r

hist ivandl_r, discrete norm freq xlabel(1(1)3)
hist ovandl_r, discrete norm freq xlabel(1(1)3)
hist dtheft_r, discrete norm freq xlabel(1(1)3)
hist dnoise_r, discrete norm freq xlabel(1(1)3)
hist dviolence_r, discrete norm freq xlabel(1(1)3)
hist ddrugs_r, discrete norm freq xlabel(1(1)3)
hist dother_r, discrete norm freq xlabel(1(1)3)
hist t_delin, discrete norm xlabel(7(1)21)
hist obvdelin, discrete norm xlabel(0(1)1)




/*------------------------------------------------------------------------------
-----------------------------------Tenant Char----------------------------------
------------------------------------------------------------------------------*/

fre xlease_r tinc_r xstay
pwcorr xlease_r tinc_r xstay

hist xlease_r, discrete norm freq xlabel(0(1)5)
hist tinc_r, discrete norm freq xlabel(1(1)3)
hist xstay, discrete norm freq xlabel(1(1)4)





/*------------------------------------------------------------------------------
-----------------------------------Management Care------------------------------
------------------------------------------------------------------------------*/
fre owncont_r dcnotif_r dccolct_r ///
	 dcevict_r dcnothn_r dcother_r dtalk_r dwrite_r dpsecrty_r dpolice_r devict_r ///
	 dcnothn_r dcother_r dtalk_r dwrite_r dpsecrty_r dpolice_r devict_r dlother_r ///
	 krent_r kmaint_r kupgrd_r kimprov_r kserv_r kother_r maintcar_r maintplan_r ///
	 ownx_r pownx_r revpownx_r ovisit_r xprop 
	 

gen keep_tenants = krent_r + kmaint_r + kupgrd_r + kimprov_r + kserv_r + kother_r
pwcorr krent_r kmaint_r kupgrd_r kimprov_r kserv_r kother_r
hist keep_tenants, discrete freq normal xlabel(1(1)6)


gen guardianship = dlother_r + dcnotif_r + dccolct_r + dcevict_r + dcother_r + dtalk_r + dwrite_r + dpsecrty_r + dpolice_r + devict_r + dcother_r
pwcorr dlother_r dcnotif_r dccolct_r dcevict_r dcother_r dtalk_r dwrite_r dpsecrty_r dpolice_r devict_r dcother_r
hist guardianship, discrete norm freq xlabel(0(1)8)


pwcorr keep_tenants guardianship ownx_r ovisit_r xprop maintcar_r maintplan_r




/*------------------------------------------------------------------------------
-----------------------------------Management Char.-----------------------------
------------------------------------------------------------------------------*/

fre mng_r ownage_r mfown_r ownrc_r ///
	 rent_r incmain_r profcompr profit_r mngx_r p2own_r othrprop_r olength_r ///
	 ohome_r ownnum

