#pragma once
#include "./LAI_KNORR_funcs.c"

typedef struct {
    struct{
        double temp;
        double deltat;
        double latitude;
        double DOY;
        double lambda;
        double lambda_max;
        double T_phi;
        double T_r;
        double plgr;
        double k_L;
        double pasm; 
        double ET;
        double tau_W;
        double t_c;
        double t_r;
        double T_memory; //udpated each iteration (automatically), can also be externally prescribed, no functional difference.
        double lambda_max_memory; //updated each iteration (automatically), can also be externally prescribed, no functional difference.
    }IN;
    struct {
        double lambda_next;
        double T;
        double laim;
        double dlambdadt;
        double  f_T;
        double f_d;
    }OUT;
    
    
    
}KNORR_ALLOCATION_STRUCT;


/* Leaf Phenology Model of Knorr et al. (2010, doi: 10.1029/2009JG001119)*/
//double* KNORR_ALLOCATION(double const *met_list, double const *var_list)
int KNORR_ALLOCATION(KNORR_ALLOCATION_STRUCT * K)
{
/*Notes: DALEC code passes the following *consts and *pars pointers:
 double constants[10]={pars[10],0.0156935,4.22273,208.868,0.0453194,0.37836,7.19298, 0.011136,2.1001,0.789798};

constants terms:
consts[0] = T_Phi = 12.5        # parameter: temperature at leaf onset (degrees C)
consts[1] = T_r   = 2.0         # parameter: spatial range (1 sigma) of T_Phi (degrees C)
consts[2] = t_c   = 10.0        # parameter: day length at leaf shedding (hours)
consts[3] = t_r   = 0.5         # parameter: spatial range (1 sigma) of t_c (hours)
consts[4] = xi  = 0.5           # parameter: initial linear leaf growth (1/days)
consts[5] = k_L   = 0.1         # parameter: inverse of leaf longevity from start of senscence (1/days)
consts[6] = lambda_max = 6.0.   # parameter: maximum potential leaf area index (m2/m2)
*/

  /*initialize intermediate variables*/
  double daylengthpars[3];
  double daylength;
  double n, deltat;
  double meantemp;
  double t_c, t_r, f_d, td_deviation;
  double T_init, T_phi, T_r;
  double T, T_memory, T_deviation, f_T, tau_m;
  double plgr, k_L;
  double f, r;
  double pasm, ET;
  double lambda, lambda_W, lambda_tilde_max, lambda_max;
  double dlambdadt, lambda_lim, laim, lambda_max_memory;
  double tau_W, tau_s;
  double lambda_next;

  meantemp=K->IN.temp;
  
  
  n=1.0; /*(double)var_list[0];*/
  deltat=(double)K->IN.deltat;
  lambda=(double)K->IN.lambda;
  T_init=(double)0.0;
  if (K->IN.T_phi  < 100.0) {
    // assume temperature parameter is in degrees C
    T_phi=K->IN.T_phi ;
  }
  else {
    // assume temperature parameter is in degrees kelvin
    T_phi=K->IN.T_phi -273.15;
  }
   T_r=K->IN.T_r;
  T_memory=K->IN.T_memory;
   tau_m=30.0; // Averaging period for temperature growth trigger T (units of days; must be in same units as deltat), usually kept constant but could potentially be a tuneable parameter
   plgr=K->IN.plgr;//
   k_L=K->IN.k_L;
   pasm=K->IN.pasm;
   ET=K->IN.ET;
   lambda_max=K->IN.lambda_max;
   tau_W=K->IN.tau_W;
   lambda_max_memory=K->IN.lambda_max_memory;  //TIME-DEPENDENT I.E. SAVE IN MEMORY
   tau_s=30.0; // Averaging period for water/structural memory (units of days; must be in same units as deltat), usually kept constant but could potentially be a tuneable parameter
   t_c=K->IN.t_c; 
   t_r=K->IN.t_r; 

  
    daylengthpars[0]=K->IN.latitude;  /* latitude */
  daylengthpars[1]=K->IN.DOY;  /* day of year */
  daylengthpars[2]=DGCM_PI;  /* pi */

  /* Initialization: only run this on the first time step! */
  if (n==0) {
    lambda_max_memory=lambda_max;
    laim=lambda_max_memory;
  }
  // if (n==0){printf("> in LAI_KNORR: T_memory = %2.1f\n",T_memory);}
  // if (n==0){T_memory=T_phi+3*T_r;}   /* set the temperature memory to be high so that we start in growth phase */
  // Exponentially declining memory of temperature
  T      = exp(- deltat / tau_m)*T_memory + meantemp * (1 - exp(- deltat / tau_m));
  T_deviation=(T-T_phi)/T_r;
  /* fraction of plants above temperature threshold: using cumulative normal distribution function (derived from the intrinsic c-function erfc) */
  f_T    = 0.5*erfc(-T_deviation*sqrt(0.5));

  /* compute daylight hours (hours of sunlight per day) */

  daylength = ComputeDaylightHours(daylengthpars);
  td_deviation = (daylength-t_c)/t_r;
  /* fraction of plants above daylength threshold: using cumulative normal distribution function (derived from the intrinsic c-function erfc) */
  f_d    = 0.5*erfc(-td_deviation*sqrt(0.5));  

  /* fraction of plants above temperature and daylength thresholds */
  f      = f_T * f_d;
  /* compute current growth rate */
  r      = plgr * f + (1 - f)*k_L;

  /* compute water-limited maximum LAI */
  lambda_W    = (pasm * lambda) / (tau_W * MaxExponentialSmooth(ET, 1e-3, 2e-2));
  /* compute smoothed maximum LAI */
  lambda_tilde_max = MinQuadraticSmooth(lambda_max, lambda_W, 0.99);
  /* update LAI water/structural memory using an exponentially declining memory of water/structural limitation over the time period tau_s */
  laim = exp(- deltat / tau_s)*lambda_max_memory + lambda_tilde_max * (1.0 - exp(- deltat / tau_s));
  
  lambda_lim = MaxExponentialSmooth(plgr * laim * f / r, 1e-9, 5e-3);

  // lambda_next is the updated target LAI (units of m2/m2)
  lambda_next = lambda_lim - (lambda_lim - lambda)*exp(-r*deltat);

  // dlambdadt is the change in LAI over the period deltat (units of m2/m2)
  dlambdadt = (lambda_next - lambda);
  

  
  //Store outputs in struct
 K->OUT.lambda_next = lambda_next;
 K->OUT.T= T;
 K->OUT.laim = laim;
 K->OUT.dlambdadt = dlambdadt;//dLAI/dt units = change of LAI per timestep
 K->OUT.f_T=f_T;
 K->OUT.f_d= f_d;
 


 
 
  return 0;
}

