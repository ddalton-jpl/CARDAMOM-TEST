#pragma once
#include "CARDAMOM_MODULE_IDX.c"
#include "../COST_FUNCTION/CARDAMOM_LIKELIHOOD_FUNCTION.c"
//This is a generic struct for a 1D var.
typedef struct ONE_DIM_VAR_STRUCT{
double* values; //NULL if not present
size_t length; //Set to 0 if not present
}ONE_DIM_VAR_STRUCT;


//This is a generic struct that contains an additional uncertainty value, which is a common form for Cardamom variables
typedef struct ONE_DIM_VAR_WITH_UNCERTAINTY_STRUCT{
double* values; //NULL if not present
size_t length; //Set to 0 if not present
double Uncertainty;
}ONE_DIM_VAR_WITH_UNCERTAINTY_STRUCT;

//This is a generic struct for a 2D var
typedef struct TWO_DIM_VAR_STRUCT{
double** values;
size_t dimensions[2]; //NOTE: This is NOT a length per row, but a length per dimension. This means this array will ALLWAYS have 2 elements for a 2D array.
}TWO_DIM_VAR_STRUCT;




//This is a struct that is used by the cardamom var "BURNED_AREA"
typedef struct BURNED_AREA_STRUCT{
double* values; //NULL if not present
size_t length; //Set to 0 if not present
double reference_mean;
}BURNED_AREA_STRUCT;

typedef struct CH4_STRUCT{
double* values; //NULL if not present
size_t length; //Set to 0 if not present
double Uncertainty;
double Annual_Uncertainty;
double Uncertainty_Threshold;
}CH4_STRUCT;


typedef struct CO2_STRUCT{
double* values; //NULL if not present
size_t length; //Set to 0 if not present
double reference_mean;
}CO2_STRUCT;

typedef struct DOY_STRUCT{
double* values; //NULL if not present
size_t length; //Set to 0 if not present
double reference_mean;
}DOY_STRUCT;

typedef struct ET_STRUCT{
double* values; //NULL if not present
size_t length; //Set to 0 if not present
double Uncertainty;
double Annual_Uncertainty;
double Uncertainty_Threshold;
}ET_STRUCT;

typedef struct EWT_STRUCT{
double* values; //NULL if not present
size_t length; //Set to 0 if not present
double Uncertainty;
double Annual_Uncertainty;
}EWT_STRUCT;

//This is a custom struct for GPP, since GPP has more attributes than just the common  'Uncertainty'
typedef struct GPP_STRUCT{
double* values; //NULL if not present
size_t length; //Set to 0 if not present
double Uncertainty;
double Annual_Uncertainty;
double gppabs;
double Uncertainty_Threshold;
}GPP_STRUCT;

typedef struct NBE_STRUCT{
double* values; //NULL if not present
size_t length; //Set to 0 if not present
double Uncertainty;
double Annual_Uncertainty;
}NBE_STRUCT;

typedef struct SSRD_STRUCT{
double* values; //NULL if not present
size_t length; //Set to 0 if not present
double reference_mean;
}SSRD_STRUCT;

typedef struct T2M_MAX_STRUCT{
double* values; //NULL if not present
size_t length; //Set to 0 if not present
double reference_mean;
}T2M_MAX_STRUCT;

typedef struct T2M_MIN_STRUCT{
double* values; //NULL if not present
size_t length; //Set to 0 if not present
double reference_mean;
}T2M_MIN_STRUCT;

typedef struct TIME_INDEX_STRUCT{
double* values; //NULL if not present
size_t length; //Set to 0 if not present
double reference_mean;
}TIME_INDEX_STRUCT;

typedef struct TOTAL_PREC_STRUCT{
double* values; //NULL if not present
size_t length; //Set to 0 if not present
double reference_mean;
}TOTAL_PREC_STRUCT;

typedef struct VPD_STRUCT{
double* values; //NULL if not present
size_t length; //Set to 0 if not present
double reference_mean;
}VPD_STRUCT;

/*
typedef struct OBS_STRUCT{
size_t length;
double * values;
double * unc;
int opt_log_transform;//log-transform data 
int opt_normalization;//(0 = none, 1 = remove mean, 2 = divide by mean)
int opt_filter;//(0 = no filter, 1 = mean only, 2==annual mean & monthly anomaly, 3 = seasonal cycle & inter-annual anomalies). 
int opt_structural_error;
double min_threshold_value;
double single_monthly_unc;
double single_annual_unc;
double single_mean_unc;
double structural_unc;
//expand as needed
int valid_obs_length;//number of non-empty obs
int * valid_obs_indices;//indices of non-empty obs
}OBS_STRUCT;
*/







typedef struct NETCDF_DATA{
ONE_DIM_VAR_WITH_UNCERTAINTY_STRUCT ABGB;
BURNED_AREA_STRUCT BURNED_AREA;
CH4_STRUCT CH4;
CO2_STRUCT CO2;
DOY_STRUCT DOY;
double EDC;
double EDCDIAG;
//ET_STRUCT ET;
OBS_STRUCT ET;
EWT_STRUCT EWT;
GPP_STRUCT GPP;
double ID;
ONE_DIM_VAR_STRUCT LAI;
double LAT;
ONE_DIM_VAR_WITH_UNCERTAINTY_STRUCT Mean_Biomass;
ONE_DIM_VAR_WITH_UNCERTAINTY_STRUCT Mean_Fire;
ONE_DIM_VAR_WITH_UNCERTAINTY_STRUCT Mean_GPP;
ONE_DIM_VAR_WITH_UNCERTAINTY_STRUCT Mean_LAI;
NBE_STRUCT NBE;
ONE_DIM_VAR_STRUCT PARPRIORS;
ONE_DIM_VAR_STRUCT PARPRIORUNC;
ONE_DIM_VAR_STRUCT OTHERPRIORS;
ONE_DIM_VAR_STRUCT OTHERPRIORSUNC;
ONE_DIM_VAR_WITH_UNCERTAINTY_STRUCT SOM;
SSRD_STRUCT SSRD;
T2M_MAX_STRUCT T2M_MAX;
T2M_MIN_STRUCT T2M_MIN;
TIME_INDEX_STRUCT TIME_INDEX;
TOTAL_PREC_STRUCT TOTAL_PREC;
VPD_STRUCT VPD;
}NETCDF_DATA;
