#pragma once
#include "../../../DALEC_CODE/DALEC_ALL/ACM.c"
#include "../../../DALEC_CODE/DALEC_ALL/offset.c"
#include "../../../DALEC_CODE/DALEC_ALL/DALEC_MODULE.c"

/*Code used by Bloom et al., 2016
See also Bloom & Williams 2015,  Fox et al., 2009; Williams et al., 1997*/


int DALEC_410(DATA DATA, double const *pars)
{

double gpppars[11],pi;
/*C-pools, fluxes, meteorology indices*/
int p,f,m,nxp, i;
int n=0,nn=0;
pi=3.1415927;


/*constant gpppars terms*/
gpppars[3]=1;
gpppars[6]=DATA.LAT;
gpppars[8]=-2.0;
gpppars[9]=1.0;
gpppars[10]=pi;

double deltat=DATA.deltat;

 double constants[10]={pars[10],0.0156935,4.22273,208.868,0.0453194,0.37836,7.19298, 0.011136,2.1001,0.789798};

/*Pointer transfer - all data stored in fluxes and pools will be passed to DATA*/
double *FLUXES=DATA.M_FLUXES;
double *POOLS=DATA.M_POOLS;
double *LAI=DATA.M_LAI;
double *NEE=DATA.M_NEE;



  /*assigning values to pools*/
  /*L,F,R,W,Lit,SOM*/
  POOLS[0]=pars[17];
  POOLS[1]=pars[18];
  POOLS[2]=pars[19];
  POOLS[3]=pars[20];
  POOLS[4]=pars[21];
  POOLS[5]=pars[22];



/* NOTES FOR POOLS AND FLUXES
MET[:,0]: projday
MET[:,1]: mintemp
MET[:,2]: maxtemp
MET[:,3]: rad
MET[:,4]: co2
MET[:,5]: yearday



  POOLS[0,0]=pars(8);Lab
  POOLS[0,1]=pars(5);Fol
  POOLS[0,2]=pars(6);Roo
  POOLS[0,3]=pars(3);Woo
  POOLS[0,4]=pars(2);Litter
  POOLS[0,5]=pars(2);Som


        %fluxes - other*********
        0.GPP
        1.temprate
        2.respiration_auto
        3.leaf_production
        4.labile_production
        5.root_production
        6.wood_production
        7.labile_release
        8.leaffall_factor
        9.leaflitter_production
        10.woodlitter_production  
        11.rootlitter_production         
     	12.respiration_het_litter
  	13.respiration_het_som
  	14.litter2som
  	15.labrelease_factor
	16. Fires (total)
	17-22. Fires (C pools to atmosphere)
	23-27. Fires (C pool transfers)
*/



/*constants for exponents of leaffall and labrelease factors*/
/*width*/
double wf=pars[15]*sqrt(2)/2;
double wl=pars[13]*sqrt(2)/2;


/*factor*/
double ff=(log(pars[4])-log(pars[4]-1))/2;
double fl=(log(1.001)-log(0.001))/2;




/*additional offset*/
double osf=offset(pars[4],wf);
double osl=offset(1.001,wl);


/*scaling to biyearly sine curve*/
double sf=365.25/pi;

/*Combustion factors*/
double CF[6]={0.1,0.9,0.1,0.1,0.5,0.01};
/*resilience factor*/
double rfac=0.5;

/*number of MET drivers*/
int nomet=((DALEC *)DATA.MODEL)->nomet;

/*number of DALEC pools*/
int nopools=((DALEC *)DATA.MODEL)->nopools;

/*number of DALEC fluxes to store*/
int nofluxes=((DALEC *)DATA.MODEL)->nofluxes;

int nr=DATA.nodays;


/*repeating loop for each timestep*/
for (n=0; n < nr; n++){
/*ppol index*/
p=nopools*n;
/*next pool index*/
nxp=nopools*(n+1);
/*met index*/
m=nomet*n;
/*flux array index*/
f=nofluxes*n;



/*LAI*/
LAI[n]=POOLS[p+1]/pars[16]; 
/*GPP*/
gpppars[0]=LAI[n];
gpppars[1]=DATA.MET[m+2];
gpppars[2]=DATA.MET[m+1];
gpppars[4]=DATA.MET[m+4];
gpppars[5]=DATA.MET[m+5];
gpppars[7]=DATA.MET[m+3];




FLUXES[f+0]=ACM(gpppars,constants);
/*temprate - now comparable to Q10 - factor at 0C is 1*/
FLUXES[f+1]=exp(pars[9]*0.5*(DATA.MET[m+2]+DATA.MET[m+1]));
/*respiration auto*/
FLUXES[f+2]=pars[1]*FLUXES[f+0];
/*leaf production*/
FLUXES[f+3]=(FLUXES[f+0]-FLUXES[f+2])*pars[2];
/*labile production*/
FLUXES[f+4] = (FLUXES[f+0]-FLUXES[f+2]-FLUXES[f+3])*pars[13-1];              
/*root production*/        
FLUXES[f+5] = (FLUXES[f+0]-FLUXES[f+2]-FLUXES[f+3]-FLUXES[f+4])*pars[4-1];            
/*wood production*/       
FLUXES[f+6] = FLUXES[f+0]-FLUXES[f+2]-FLUXES[f+3]-FLUXES[f+5]-FLUXES[f+4]; 
/*leaf fall factor*/
FLUXES[f+8] = (2/sqrt(pi))*(ff/wf)*exp(-pow(sin((DATA.MET[m+0]-pars[14]+osf)/sf)*sf/wf,2));
/*Labrelease factor*/
FLUXES[f+15]=(2/sqrt(pi))*(fl/wl)*exp(-pow(sin((DATA.MET[m+0]-pars[11]+osl)/sf)*sf/wl,2));
/*labile release - re-arrange order in next versions*/
FLUXES[f+7] = POOLS[p+0]*(1-pow(1-FLUXES[f+15],deltat))/deltat;
/*leaf litter production*/       
FLUXES[f+9] = POOLS[p+1]*(1-pow(1-FLUXES[f+8],deltat))/deltat;
/*wood litter production*/       
FLUXES[f+10] = POOLS[p+3]*(1-pow(1-pars[6-1],deltat))/deltat;
/*root litter production*/
FLUXES[f+11] = POOLS[p+2]*(1-pow(1-pars[7-1],deltat))/deltat;
/*respiration heterotrophic litter*/
FLUXES[f+12] = POOLS[p+4]*(1-pow(1-FLUXES[f+1]*pars[8-1],deltat))/deltat;
/*respiration heterotrophic SOM*/
FLUXES[f+13] = POOLS[p+5]*(1-pow(1-FLUXES[f+1]*pars[9-1],deltat))/deltat;
/*litter to SOM*/
FLUXES[f+14] = POOLS[p+4]*(1-pow(1-pars[1-1]*FLUXES[f+1],deltat))/deltat;

/*total pool transfers (no fires yet)*/

        POOLS[nxp+0] = POOLS[p+0] + (FLUXES[f+4]-FLUXES[f+7])*deltat;
        POOLS[nxp+1] = POOLS[p+1] + (FLUXES[f+3] - FLUXES[f+9] + FLUXES[f+7])*deltat;
        POOLS[nxp+2] = POOLS[p+2] + (FLUXES[f+5] - FLUXES[f+11])*deltat;
        POOLS[nxp+3] = POOLS[p+3] +  (FLUXES[f+6] - FLUXES[f+10])*deltat;
        POOLS[nxp+4] = POOLS[p+4] + (FLUXES[f+9] + FLUXES[f+11] - FLUXES[f+12] - FLUXES[f+14])*deltat;        
        POOLS[nxp+5]= POOLS[p+5]+ (FLUXES[f+14] - FLUXES[f+13]+FLUXES[f+10])*deltat;                                

	/*total pool transfers - WITH FIRES*/
	/*first fluxes*/

	/*CFF = Combusted C fire flux
	NCFF = Non-combusted C fire flux*/

	/*Calculating all fire transfers (1. combustion, and 2. litter transfer)*/
	/*note: all fluxes are in gC m-2 day-1*/
	for (nn=0;nn<6;nn++){FLUXES[f+17+nn] = POOLS[nxp+nn]*DATA.MET[m+6]*CF[nn]/deltat;}
	for (nn=0;nn<5;nn++){FLUXES[f+23+nn] = POOLS[nxp+nn]*DATA.MET[m+6]*(1-CF[nn])*(1-rfac)/deltat;}

	/*Adding all fire pool transfers here*/
	/*live C pools*/	
	for (nn=0;nn<4;nn++){POOLS[nxp+nn]=POOLS[nxp+nn]-(FLUXES[f+17+nn]+FLUXES[f+23+nn])*deltat;}
	/*dead C pools*/
	/*litter*/
	POOLS[nxp+4]=POOLS[nxp+4]+(FLUXES[f+23]+FLUXES[f+23+1]+FLUXES[f+23+2]-FLUXES[f+17+4]-FLUXES[f+23+4])*deltat;
	/*som*/
	POOLS[nxp+5]=POOLS[nxp+5]+(FLUXES[f+23+3]+FLUXES[f+23+4]-FLUXES[f+17+5])*deltat;

	/*fires - total flux in gC m-2 day-1*/
	/*this term is now (essentially) obsolete*/
	/*replace in next version of DALEC_FIRES*/
	FLUXES[f+16]=0;for (nn=0;nn<6;nn++){FLUXES[f+16]+=FLUXES[f+17+nn];}

	/*Net ecosystem exchange + Fires*/
	NEE[n]=-FLUXES[f+0]+FLUXES[f+2]+FLUXES[f+12]+FLUXES[f+13]+FLUXES[f+16];


}

return 0;
}







