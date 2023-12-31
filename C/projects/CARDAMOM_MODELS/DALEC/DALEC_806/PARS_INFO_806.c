#pragma once
/*PARAMETER_INFO (typedef struct) must have at least 3 fields
 *  * npars,
 *   * parmax
 *    * parmin*/
/*MCMC sampling of GPP allocation priors approximated as 0.01-0.5 NPP for*/
/*photosynthetic pools and 0.01-1 of remaining NPP for root and wood pool*/
/*TOR = turnover rate*/

int PARS_INFO_806(DATA *CARDADATA)
{

/*Decomposition rate*/
CARDADATA->parmin[0]=0.00001;
CARDADATA->parmax[0]=0.01;

/*Fraction of GPP respired (fauto)*/
CARDADATA->parmin[1]=0.2;
CARDADATA->parmax[1]=0.8;

/*Fraction of (1-fauto) to foliage*/
CARDADATA->parmin[2]=0.01;
CARDADATA->parmax[2]=0.5;

/*Fraction of (1-fauto-ffol) to roots*/
CARDADATA->parmin[3]=0.01;
CARDADATA->parmax[3]=1;

/*Leaf Lifespan*/
CARDADATA->parmin[4]=1.001;
CARDADATA->parmax[4]=8;

/*TOR (turnover rate) wood* - 1% loss per year value*/
CARDADATA->parmin[5]=0.000025;
CARDADATA->parmax[5]=0.001;

/*TOR roots*/
CARDADATA->parmin[6]=0.0001;
CARDADATA->parmax[6]=0.01;

/*TOR litter*/
CARDADATA->parmin[7]=0.0001;
CARDADATA->parmax[7]=0.01;

/*TOR SOM*/
CARDADATA->parmin[8]=0.0000001;
CARDADATA->parmax[8]=0.001;

/*Temperature dependence factor* = Q10 = 1.2-1.6*/
CARDADATA->parmin[9]=0.018;
CARDADATA->parmax[9]=0.08;

/*Canopy Efficiency*/
CARDADATA->parmin[10]=5;
CARDADATA->parmax[10]=50;

/*Bday*/
CARDADATA->parmin[11]=365.25;
CARDADATA->parmax[11]=365.25*4;

/*Fraction to Clab*/
CARDADATA->parmin[12]=0.01;
CARDADATA->parmax[12]=0.5;

/*Clab Release period*/
CARDADATA->parmin[13]=365.25/12;
CARDADATA->parmax[13]=100;

/*Fday*/
CARDADATA->parmin[14]=365.25;
CARDADATA->parmax[14]=365.25*4;

/*Leaf fall period*/
CARDADATA->parmin[15]=365.25/12;
CARDADATA->parmax[15]=150;

/*LMCA*/
/*Kattge et al. 2011*/
/*Kattge et al., provide a range of 10 400 g m-2, i.e. 5 200 gC m-2*/
CARDADATA->parmin[16]=5;
CARDADATA->parmax[16]=200;

/*INITIAL VALUES DECLARED HERE*/

/*C labile*/
CARDADATA->parmin[17]=1.0;
CARDADATA->parmax[17]=2000.0;

/*C foliar*/
CARDADATA->parmin[18]=1.0;
CARDADATA->parmax[18]=2000.0;

/*C roots*/
CARDADATA->parmin[19]=1.0;
CARDADATA->parmax[19]=2000.0;

/*C_wood*/
CARDADATA->parmin[20]=1.0;
CARDADATA->parmax[20]=100000.0;

/*C litter*/
CARDADATA->parmin[21]=1.0;
CARDADATA->parmax[21]=2000.0;

/*C_som*/
CARDADATA->parmin[22]=1.0;
CARDADATA->parmax[22]=200000.0;

/*IWUE (inherent water-use efficiency): GPP*VPD/ET: gC/kgH2o *hPa*/
CARDADATA->parmin[23]=10;
CARDADATA->parmax[23]=50;

/*Runoff focal point (~maximum soil storage capacity x 4)*/
CARDADATA->parmin[24]=1;
CARDADATA->parmax[24]=100000;

/*"Wilting point"*/
CARDADATA->parmin[25]=1;
CARDADATA->parmax[25]=10000;

/*"Bucket at t0"*/
CARDADATA->parmin[26]=1;
CARDADATA->parmax[26]=10000;

/*Foliar biomass CF*/
CARDADATA->parmin[27]=0.01;
CARDADATA->parmax[27]=1;

/*"Ligneous" biomass CF".*/
CARDADATA->parmin[28]=0.01;
CARDADATA->parmax[28]=1;

/*DOM CF".*/
CARDADATA->parmin[29]=0.01;
CARDADATA->parmax[29]=1;

/*Fire-induced mortality".*/
CARDADATA->parmin[30]=0.01;
CARDADATA->parmax[30]=1;

/*Lab pool lifespan*/
CARDADATA->parmin[31]=1.001;
CARDADATA->parmax[31]=8;

/*Moisture factor*/
CARDADATA->parmin[32]=0.01;
CARDADATA->parmax[32]=1;

/*Note: definitions not 100% clear yet (work in progress)*/
/*Band 1 = lowest freq*/
/*Band 1 sensitivity to Foliage (from 100%, remainder is to be partitioned)*/
CARDADATA->parmin[33]=0.01;
CARDADATA->parmax[33]=1;
/*Band 2 sensitivity to Foliage (from 100%, remainder is to be partitioned)*/
CARDADATA->parmin[34]=0.01;
CARDADATA->parmax[34]=1;
/*b1fb1wb2fb2w*/


return 0;

}


