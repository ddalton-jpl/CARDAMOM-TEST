function CARDAMOM_v3_MAKE_EXAMPLE_NC_FILE_SEP21

%Step 1. start netcdf file
%Step 0. Load time data

%Eventually CARDAMOM/DATA/CARDAMOM_DEMO_DRIVERS.nc: working example.
NC.fname='CARDAMOM/DATA/CARDAMOM_DEMO_DRIVERS_prototype.cbf.nc';delete(NC.fname);
NC.nodays=length(time_data);
NC.fill_value=-9999;



%Step 2. Summary variables
%Model
nccreate(NC.fname,'ID'); ncwrite(NC.fname,'ID',1100);
nccreate(NC.fname,'EDC'); ncwrite(NC.fname,'EDC',1);
nccreate(NC.fname,'LAT'); ncwrite(NC.fname,'LAT',40.25);


%DATA
%Step 3. Writing all drivers
Dnames={'BURNED_AREA','CO2','DOY','TOTAL_PREC','SNOWFALL','SSRD','T2M_MIN','T2M_MAX','time','VPD'};
for n=1:numel(Dnames)
    vname=Dnames{n};
    disp(sprintf('Writing %s...',vname))
create_and_write_dri_timeseries_variable(NC,Dnames{n},eval(sprintf('%s_data',vname)));
end

%Step 4. Writing time-varying obs
Dnames={'ABGB','CH4','ET','EWT','GPP','LAI','NBE','SOM'};
for n=1:numel(Dnames)
    vname=Dnames{n};
    disp(sprintf('Writing %s...',vname))
    create_and_write_obs_timeseries_variable(NC,Dnames{n},eval(sprintf('%s_data',vname)));
end



%Step 5. 
    create_and_write_obs_single_variable(NC,'Mean_Biomass',-9999);
    create_and_write_obs_single_variable(NC,'Mean_Fire',-9999);
    create_and_write_obs_single_variable(NC,'Mean_GPP',-9999);
    create_and_write_obs_single_variable(NC,'Mean_LAI',-9999);

    
    %Put parameter constraint examples
    
    create_and_write_obs_single_variable(NC,'PEQ_Cefficiency',-9999);
    create_and_write_obs_single_variable(NC,'PEQ_CUE',-9999);
    create_and_write_obs_single_variable(NC,'PEQ_iniSOM',-9999);

%Fusion
nccreate(NC.fname,'MCMCID'); 
ncwrite(NC.fname,'MCMCID',3);
ncwriteatt(NC.fname,'MCMCID','nITERATIONS',5e5);
ncwriteatt(NC.fname,'MCMCID','nSAMPLES',10);
ncwriteatt(NC.fname,'MCMCID','nPRINT',1000);
ncwriteatt(NC.fname,'MCMCID','seed_number',0);










end

function create_and_write_dri_timeseries_variable(NC,vname,vvalues)


METVNAME={'time','T2M_MIN','T2M_MAX','SSRD','CO2','DOY','BURNED_AREA','VPD','TOTAL_PREC','SNOWFALL'};
METINFO={'Time since Jan 01/01/2000 00:00','Mean daily min. temperature','Mean daily max. temperature','Global radiation','Atmospheric CO2','Day of year','Burned area','VPD','Total precipitation','Snowfall'};
METUNITS={'Days','deg C','deg C','MJ/m2/d','ppm','Days','m2/m2','hPA','mm/day','mm/day'};



nccreate(NC.fname,vname,'Dimensions',{'time',NC.nodays},'FillValue',NC.fill_value);
ncwrite(NC.fname,vname,vvalues);
ncwriteatt(NC.fname,vname,'reference_mean',mean(vvalues));
p=strcmp(METVNAME,vname);
ncwriteatt(NC.fname,METVNAME{p},'info',METINFO{p});
ncwriteatt(NC.fname,METVNAME{p},'units',METUNITS{p});



end


function create_and_write_obs_timeseries_variable(NC,vname,vvalues)

% int opt_unc_type;//(0 = absolute sigma, 1 = uncertainty factor, 2 = sigma as fraction of value)
% int opt_normalization;//(0 = none, 1 = remove mean, 2 = divide by mean)
% int opt_filter;//(0 = no filter, 1 = mean only, 2==annual mean & monthly anomaly, 3 = seasonal cycle & inter-annual anomalies). 
% double min_threshold;//Minimum value threshold: model and/or data will be rounded up to this value (default = -inf)
% double single_monthly_unc;//Fields to be used only with Filter=2. 
% double single_annual_unc;//Fields to be used only with Filter=2
% double single_mean_unc;//Fields to be used only with Filter = 1;
% double single_unc;//
% double structural_unc;//this gets added to uncertainty in quadrature.


nccreate(NC.fname,vname,'Dimensions',{'time',NC.nodays},'FillValue',NC.fill_value);
ncwrite(NC.fname,vname,vvalues);
ncwriteatt(NC.fname,vname,'opt_unc_type',-9999);
ncwriteatt(NC.fname,vname,'opt_normalization',-9999);
ncwriteatt(NC.fname,vname,'opt_filter',-9999);
ncwriteatt(NC.fname,vname,'min_threshold',-9999);
ncwriteatt(NC.fname,vname,'single_monthly_unc',-9999);
ncwriteatt(NC.fname,vname,'single_annual_unc',-9999);
ncwriteatt(NC.fname,vname,'single_mean_unc',-9999);
ncwriteatt(NC.fname,vname,'single_unc',-9999);
ncwriteatt(NC.fname,vname,'structural_unc',-9999);

%Final step. Writing time-varying uncertainty field, populating with -9999 or NaNs
nccreate(NC.fname,[vname,'unc'],'Dimensions',{'time',NC.nodays},'FillValue',NC.fill_value);
ncwrite(NC.fname,[vname,'unc'],vvalues*0-9999);



end


function create_and_write_obs_single_variable(NC,vname,vvalue)

% double value;
% double unc;
% int opt_unc_type;//(0 = absolute sigma, 1 = uncertainty factor, 2 = sigma as fraction of value)
% double min_threshold;
% }SINGLE_OBS_STRUCT;




nccreate(NC.fname,vname,'FillValue',NC.fill_value);
ncwriteatt(NC.fname,vname,'unc',-9999);
ncwriteatt(NC.fname,vname,'opt_unc_type',-9999);
ncwriteatt(NC.fname,vname,'min_threshold',-9999);




end



%%%%%%All obs values%%%%%
%Dnames={'ABGB','CH4','ET','EWT','GPP','LAI','NBE','SOM'};


function ABGB=ABGB_data


ABGB=[  
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
    3281.7
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN];
   
end

function CH4=CH4_data


CH4=NaN;

end

function ET= ET_data


ET=[      NaN
    1.1328
    1.3227
    1.1000
    2.1101
    2.7943
    3.0445
    2.6282
    2.2054
    1.5128
    0.7588
    0.9308
    1.0713
    1.0670
    1.1013
    1.1443
    1.8647
    2.6013
    2.2576
    1.9426
    1.6190
    0.9571
    0.9462
       NaN
    1.1394
    1.0363
    1.3765
    1.0929
    1.6757
    2.2408
    2.7436
    2.1167
    1.9015
    1.0359
    1.4540
       NaN
       NaN
    0.9358
    1.2556
    1.4661
    2.0612
    2.5047
    2.6304
    2.4348
    1.9193
    1.0954
    0.7192
    0.7356
    0.6409
       NaN
    1.0680
    1.1776
    1.7789
    2.7333
    2.6187
    2.3322
    1.4416
    1.1179
    1.2555
       NaN
    1.2514
    1.1844
    1.1039
    1.2107
    2.0320
    2.7188
    2.7885
    2.0783
    1.5086
    1.3622
    0.9021
       NaN
    0.9889
    1.5946
    1.0713
    1.3186
    1.8367
    2.5451
    2.5841
    2.6459
    1.9520
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN];

end

function EWT=EWT_data
EWT=NaN;

end


function GPP=GPP_data;

GPP=[
       NaN
    0.0414
    0.0400
    1.0256
    4.2157
    5.8502
    6.1868
    5.4684
    4.5899
    2.1410
    0.4327
    0.0201
    0.0060
    0.0606
    0.0849
    1.1877
    3.7590
    5.5613
    4.9797
    4.7709
    3.4413
    1.4232
    0.0058
       NaN
    0.0302
    0.0266
    0.0902
    0.7146
    3.2662
    5.5017
    4.9180
    4.9087
    3.5426
    2.3300
    0.1055
       NaN
       NaN
    0.0122
    0.2914
    1.0578
    4.7934
    5.1257
    5.4689
    5.3814
    3.9670
    1.7153
    0.0119
    0.0145
    0.0521
       NaN
    0.0056
    0.5771
    3.6704
    4.8350
    5.4794
    5.3409
    3.7348
    2.0982
    0.3386
       NaN
    0.0108
    0.0224
    0.1634
    1.2645
    3.9774
    6.3111
    5.5351
    5.3969
    3.5158
    1.3925
    0.1285
       NaN
    0.0107
    0.1177
    0.3896
    0.9856
    4.2739
    5.0103
    5.8851
    5.8107
    4.4618
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN];


end


function LAI=LAI_data

LAI=[
         NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
    0.2000
    0.1000
    0.2000
    0.3000
    0.7000
    1.2000
    2.0000
    1.7000
    1.2000
    0.4000
    0.3000
    0.1000
    0.1000
    0.1000
    0.3000
    0.7000
    0.6000
    1.0500
    2.1000
    2.2000
    1.1500
    0.5000
    0.3000
    0.3000
       NaN
    0.1500
    0.3000
    0.9500
    0.9000
    0.7000
    2.2500
    2.1500
    0.6000
    0.4000
    0.3000
    0.1500
    0.2000
    0.2000
    0.3000
    0.4500
    1.0000
    0.9000
    2.2000
    2.3000
    1.1500
    0.4000
    0.3000
    0.2000
       NaN
       NaN
    0.2500
    0.5500
       NaN
    1.4000
    2.2000
    2.3500
    0.9500
    0.5000
    0.3000
       NaN
       NaN
       NaN
    0.2500
    0.4000
    0.7500
    1.2000
    1.9500
    2.5000
    1.3000
    0.4000
    0.3000
    0.2000
    0.1000
    0.2000
    0.2500
    0.4500
    0.8000
    2.6000
    2.9000
    2.9000
    1.0000
    0.5000
    0.3000
    0.2000
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN];


end

function NBE=NBE_data


NBE=[
        NaN
    0.2733
    0.4148
    0.0997
   -2.3046
   -2.1825
   -1.1567
   -1.0597
   -1.6731
   -0.6934
    0.3264
    0.3223
    0.2950
    0.1118
    0.4860
    0.1336
   -1.8041
   -1.9466
   -0.3275
   -1.0609
   -1.2725
   -0.2180
    0.6222
       NaN
    0.4357
    0.2958
    0.4592
    0.3339
   -1.8567
   -2.4852
   -0.4475
   -0.9428
   -0.9135
   -0.2669
    0.4217
       NaN
       NaN
    0.2666
    0.5098
    0.2494
   -2.8242
   -1.8059
   -0.6164
   -0.7965
   -1.1573
   -0.1726
    0.7693
    0.5492
    0.5060
       NaN
    0.5372
    0.4394
   -1.6470
   -1.8040
   -0.6362
   -1.2374
   -1.3434
   -0.6167
    0.5012
       NaN
    0.4794
    0.4010
    0.5436
    0.1220
   -1.8484
   -2.3678
   -0.2862
   -1.5538
   -1.3239
    0.0379
    0.7672
       NaN
    0.5448
    0.4270
    0.5652
    0.2559
   -2.8147
   -1.8153
   -1.0673
   -0.7648
   -1.2895
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN
       NaN

];

end

function SOM=SOM_data;
SOM=NaN;
end


%***********drivers**************
function BURNED_AREA=BURNED_AREA_data

BURNED_AREA=[ 0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0];
end

function CO2=CO2_data


CO2=[370.5900
  371.5100
  372.4300
  373.3700
  373.8500
  373.2100
  371.5100
  369.6100
  368.1800
  368.4500
  369.7600
  371.2400
  372.5300
  373.2000
  374.1200
  375.0200
  375.7600
  375.5200
  374.0100
  371.8500
  370.7500
  370.5500
  372.2500
  373.7900
  374.8800
  375.6400
  376.4500
  377.7300
  378.6000
  378.2800
  376.7000
  374.3800
  373.1700
  373.1400
  374.6600
  375.9900
  377.0000
  377.8700
  378.8800
  380.3500
  380.6200
  379.6900
  377.4700
  376.0100
  374.2500
  374.4600
  376.1600
  377.5100
  378.4600
  379.7300
  380.7700
  382.2900
  382.4500
  382.2100
  380.7400
  378.7400
  376.7000
  377.0000
  378.3500
  380.1100
  381.3800
  382.1900
  382.6700
  384.6100
  385.0300
  384.0500
  382.4600
  380.4100
  378.8500
  379.1300
  380.1500
  381.8200
  382.8900
  383.9000
  384.5800
  386.5000
  386.5600
  386.1000
  384.5000
  381.9900
  380.9600
  381.1200
  382.4500
  383.9500
  385.5200
  385.8200
  386.0300
  387.2100
  388.5400
  387.7600
  386.3600
  384.0900
  383.1800
  382.9900
  384.1900
  385.5600
  386.9400
  387.4800
  388.8200
  389.5500
  390.1400
  389.4800
  388.0300
  386.1100
  384.7400
  384.4300
  386.0200
  387.4200
  388.7100
  390.2000
  391.1700
  392.4600
  393.0000
  392.1500
  390.2000
  388.3500
  386.8500
  387.2400
  388.6700
  389.7900
  391.3300
  391.8600
  392.6000
  393.2500
  394.1900
  393.7300
  392.5100
  390.1300
  389.0800
  389.0000
  390.2800
  391.8600
  393.1200
  393.8600
  394.4000
  396.1800
  396.7400
  395.7100
  394.3600
  392.3900
  391.1100
  391.0500
  392.9800
  394.3400
  395.5500
  396.8000
  397.4300
  398.4100
  399.7800
  398.6100
  397.3200
  395.2000
  393.4500
  393.7000
  395.1600
  396.8400
  397.8500
  398.0100
  399.7700
  401.3800
  401.7800
  401.2500
  399.1000
  397.0300
  395.3800
  396.0300
  397.2800
  398.9100
  399.9800
  400.2800
  401.5400
  403.2800
  403.9600
  402.8000
  401.3100
  398.9300
  397.6300
  398.2900
  400.1600
  401.8500
  402.5600
  404.1200
  404.8700
  407.4500
  407.7200
  406.8300
  404.4100
  402.2700
  401.0500
  401.5900
  403.5500
  404.4500];

end

function DOY=DOY_data


DOY=[15.2188
   45.6562
   76.0938
  106.5312
  136.9688
  167.4062
  197.8438
  228.2812
  258.7188
  289.1562
  319.5938
  350.0312
   15.2188
   45.6562
   76.0938
  106.5312
  136.9688
  167.4062
  197.8438
  228.2812
  258.7188
  289.1562
  319.5938
  350.0312
   15.2188
   45.6562
   76.0938
  106.5312
  136.9688
  167.4062
  197.8438
  228.2812
  258.7188
  289.1562
  319.5938
  350.0312
   15.2188
   45.6562
   76.0938
  106.5312
  136.9688
  167.4062
  197.8438
  228.2812
  258.7188
  289.1562
  319.5938
  350.0312
   15.2188
   45.6562
   76.0938
  106.5312
  136.9688
  167.4062
  197.8438
  228.2812
  258.7188
  289.1562
  319.5938
  350.0312
   15.2188
   45.6562
   76.0938
  106.5312
  136.9688
  167.4062
  197.8438
  228.2812
  258.7188
  289.1562
  319.5938
  350.0312
   15.2188
   45.6562
   76.0938
  106.5312
  136.9688
  167.4062
  197.8438
  228.2812
  258.7188
  289.1562
  319.5938
  350.0312
   15.2188
   45.6562
   76.0938
  106.5312
  136.9688
  167.4062
  197.8438
  228.2812
  258.7188
  289.1562
  319.5938
  350.0312
   15.2188
   45.6562
   76.0938
  106.5312
  136.9688
  167.4062
  197.8438
  228.2812
  258.7188
  289.1562
  319.5938
  350.0312
   15.2188
   45.6562
   76.0938
  106.5312
  136.9688
  167.4062
  197.8438
  228.2812
  258.7188
  289.1562
  319.5938
  350.0312
   15.2188
   45.6562
   76.0938
  106.5312
  136.9688
  167.4062
  197.8438
  228.2812
  258.7188
  289.1562
  319.5938
  350.0312
   15.2188
   45.6562
   76.0938
  106.5312
  136.9688
  167.4062
  197.8438
  228.2812
  258.7188
  289.1562
  319.5938
  350.0312
   15.2188
   45.6562
   76.0938
  106.5312
  136.9688
  167.4062
  197.8438
  228.2812
  258.7188
  289.1562
  319.5938
  350.0312
   15.2188
   45.6562
   76.0938
  106.5312
  136.9688
  167.4062
  197.8438
  228.2812
  258.7188
  289.1562
  319.5938
  350.0312
   15.2188
   45.6562
   76.0938
  106.5312
  136.9688
  167.4062
  197.8438
  228.2812
  258.7188
  289.1562
  319.5938
  350.0312
   15.2188
   45.6562
   76.0938
  106.5312
  136.9688
  167.4062
  197.8438
  228.2812
  258.7188
  289.1562
  319.5938
  350.0312];
  
end

function PREC=TOTAL_PREC_data

PREC=[0.5595
    0.7610
    1.8563
    2.2152
    3.4460
    0.9654
    1.1447
    2.1460
    1.7146
    0.7266
    1.2793
    0.4490
    0.8644
    0.8457
    1.2126
    1.0006
    2.1730
    1.0316
    0.7839
    1.3702
    1.5348
    1.5844
    1.2122
    0.2923
    0.4224
    1.5853
    2.9110
    2.4381
    1.8531
    1.6016
    0.6477
    1.0693
    1.1291
    0.2676
    1.2178
    0.6205
    0.7858
    1.2640
    0.7281
    2.9843
    1.0298
    1.4446
    1.9393
    1.4892
    2.3672
    1.7253
    1.4868
    0.4169
    1.2071
    0.7279
    1.6648
    2.9604
    1.5613
    2.3733
    0.8808
    0.8032
    0.6617
    2.0174
    0.9718
    0.9156
    0.6819
    0.5580
    1.7803
    1.3947
    1.3386
    0.5354
    1.3484
    1.5582
    1.3227
    2.1517
    0.8345
    1.2051
    1.3210
    1.0197
    1.4808
    2.1838
    2.1144
    0.7539
    0.4077
    0.7478
    1.2852
    1.0944
    0.5137
    1.7786
    0.7457
    1.2230
    1.5260
    1.4178
    2.4251
    0.8941
    0.4831
    1.7802
    0.9734
    1.0650
    0.9065
    1.3066
    0.8384
    0.5247
    1.2540
    3.4191
    1.8734
    2.2816
    1.1143
    0.7819
    1.5460
    2.6956
    0.7282
    1.0055
    0.4618
    1.2643
    1.4719
    2.9113
    2.3849
    1.4514
    0.8961
    0.9770
    0.3686
    1.2780
    1.0368
    1.1806
    0.8534
    1.1603
    1.6926
    2.9350
    2.5467
    1.1597
    1.3062
    1.0356
    1.5072
    1.7816
    0.8507
    0.9630
    0.5168
    1.6496
    0.3001
    1.2885
    1.1919
    0.3942
    1.7885
    0.6121
    1.3906
    1.1208
    0.2769
    1.0062
    0.4856
    1.4926
    1.3746
    3.2820
    2.6082
    0.3342
    0.7437
    0.6885
    3.1925
    1.8590
    0.9335
    1.0833
    1.5007
    1.6898
    1.7138
    1.5806
    3.4037
    0.7807
    1.3835
    2.0399
    1.4837
    0.8484
    1.6133
    1.1393
    0.4179
    1.8401
    0.9319
    3.2783
    5.8194
    1.7725
    1.2786
    0.9200
    0.7391
    1.3216
    1.6394
    1.2685
    0.8357
    0.8783
    2.1241
    3.1297
    3.0369
    0.6369
    0.7539
    0.8209
    0.6931
    0.6556
    0.8369
    1.5744];


end

function SNOWFALL=SNOWFALL_data


SNOWFALL=[0.4580
    0.8243
    1.2133
    1.4846
    1.1834
    0.2275
         0
         0
    0.5247
    0.5865
    0.9011
    0.6210
    1.0386
    0.7861
    1.1429
    0.5952
    0.6029
    0.0179
         0
         0
    0.0408
    1.0010
    0.9902
    0.3675
    0.6463
    1.6590
    2.8797
    1.7185
    0.6060
    0.0544
         0
         0
    0.1280
    0.2338
    1.3576
    0.6555
    0.7841
    1.2123
    0.6104
    2.1161
    0.5046
    0.0244
         0
    0.0306
    0.7474
    0.7427
    1.4679
    0.6662
    1.2120
    0.6531
    1.4115
    1.8224
    0.3457
    0.4181
         0
         0
    0.0086
    1.0557
    1.3328
    1.1878
    0.9705
    0.8248
    1.3123
    0.9212
    0.2177
         0
         0
    0.0039
    0.5253
    1.6528
    0.9245
    1.2745
    1.0698
    1.3980
    1.1179
    1.3012
    0.7733
    0.0693
         0
         0
    0.0718
    0.9791
    0.4935
    1.6101
    1.1028
    1.3746
    1.4055
    1.5429
    1.3360
    0.1977
         0
    0.0063
    0.0581
    0.4046
    0.8470
    1.2844
    1.3737
    0.7797
    1.3128
    2.7307
    0.3505
    0.0230
         0
         0
    0.5645
    1.8648
    0.5063
    1.1037
    0.5845
    1.2781
    1.4611
    2.4730
    1.2754
    0.0764
         0
         0
    0.0017
    1.0006
    1.0467
    1.3292
    1.0608
    1.5654
    1.5634
    2.2572
    2.0022
    0.0537
         0
         0
    0.0153
    1.1643
    1.1825
    0.8686
    0.8202
    1.4400
    0.2361
    0.7491
    0.5098
         0
         0
         0
    0.1162
    0.7828
    0.1928
    1.1943
    0.5443
    0.9838
    1.1498
    2.2443
    1.0645
    0.0003
         0
         0
    0.1920
    1.2376
    0.9622
    1.0885
    1.8692
    2.3209
    1.3441
    1.2910
    0.9127
    0.0182
         0
    0.0000
    0.1693
    0.3160
    1.2097
    1.2096
    0.4188
    1.8044
    0.8110
    1.7717
    1.6091
         0
         0
    0.0019
    0.0002
    0.5547
    1.5685
    1.2965
    0.8847
    1.0019
    2.0840
    1.8110
    0.9111
         0
         0
    0.0009
    0.0599
    0.3518
    0.6005
    1.9501];
end

function SSRD=SSRD_data

SSRD=[
    9.7291
   13.7900
   17.8854
   24.1557
   24.7304
   29.1063
   26.2385
   22.0076
   19.4848
   14.9543
   10.5379
    9.2999
   10.2685
   14.6520
   20.4469
   24.8624
   26.7994
   29.1552
   27.2937
   24.2539
   18.5080
   14.7276
   10.9235
    8.8479
    9.9081
   13.4257
   18.1454
   24.0194
   26.7014
   27.7039
   28.0452
   23.0839
   20.1749
   15.3607
   10.5036
    8.7731
    9.9440
   13.3958
   20.5333
   21.2732
   28.1842
   27.0466
   25.1458
   23.1312
   18.3912
   14.0063
    9.4960
    8.8035
    9.9062
   13.7093
   18.8500
   23.6931
   26.9384
   27.7188
   27.8585
   23.0917
   20.3810
   13.9230
   10.5372
    8.5981
   10.3432
   14.9720
   19.4064
   24.4921
   27.9805
   29.5790
   24.6204
   22.3207
   20.0491
   13.1230
   10.5714
    8.3913
    9.8280
   13.8662
   18.8630
   22.7593
   25.9461
   28.8282
   26.6948
   23.0416
   19.6861
   15.3846
   10.9866
    7.7960
   10.4771
   14.0170
   19.8026
   25.3257
   26.5973
   29.6935
   27.5426
   22.8385
   20.5390
   15.5887
   10.2924
    8.5000
    9.8363
   14.7040
   19.9434
   22.6599
   25.7711
   26.5710
   26.8984
   25.0340
   19.0625
   13.1465
   11.2569
    8.2619
    9.8268
   13.0912
   19.2295
   23.8157
   26.9666
   27.7427
   26.4370
   23.5693
   21.9311
   14.2109
   10.7141
    7.7808
    9.8767
   14.0583
   19.3000
   23.0339
   25.2714
   29.5821
   26.0007
   24.0618
   19.0684
   14.7882
   11.2191
    8.7442
   10.2863
   13.7944
   21.0301
   24.3064
   27.7491
   29.8794
   24.4655
   23.6566
   19.6857
   15.5850
   11.2793
    7.9162
   10.4480
   13.5667
   19.1385
   22.9072
   25.8875
   29.9433
   26.3127
   22.4698
   16.6804
   14.7472
   10.7106
    8.7761
    9.6748
   13.5609
   19.1811
   24.0510
   25.3105
   29.8608
   25.5203
   22.0802
   19.4915
   15.0329
    9.9099
    7.5806
    9.6375
   13.5859
   20.0320
   23.0445
   20.6353
   27.3175
   25.4232
   23.5845
   20.1945
   13.9278
   10.8551
    8.5850
    9.8826
   14.4170
   19.2195
   21.9815
   25.5417
   28.8088
   27.2358
   23.1287
   20.2863
   15.1573
   10.5738
    8.2280];

end

function T2M_MIN=T2M_MIN_data

T2M_MIN=[ -12.1733
  -10.1836
   -6.4173
   -3.6914
    0.6105
    5.2758
    8.8392
    7.4210
    3.4559
   -1.4442
   -5.5228
  -11.0910
  -11.6609
  -12.3218
   -9.9632
   -3.2844
   -0.5581
    5.7679
    8.2817
    6.4879
    4.1850
   -3.4618
   -8.4436
  -11.0161
   -7.8382
  -10.8178
   -6.2610
   -4.1188
    0.5678
    3.5378
    9.1235
    8.0019
    2.0802
    0.1800
   -6.2451
   -9.8497
  -10.4596
  -11.6907
   -4.6123
   -1.6057
    0.8133
    3.4409
    6.7218
    5.8950
    3.5306
   -0.3137
   -5.1865
   -8.9795
   -7.5796
   -9.6756
   -7.0218
   -3.0135
    0.7036
    3.9997
    8.6454
    6.7981
    4.1347
   -0.3788
   -4.4994
  -10.4989
   -7.7549
  -11.7762
   -8.2444
   -2.3597
    0.6080
    5.6047
    9.5171
    8.3495
    1.3287
   -1.1487
   -5.2949
   -9.0515
  -12.4258
   -8.8728
   -4.6842
   -2.4715
    0.3204
    4.9773
    8.7973
    8.7257
    4.3277
   -1.1678
   -4.8733
  -10.8462
  -12.9513
   -9.4169
   -7.3276
   -4.9840
   -0.7630
    3.0180
    8.3408
    7.7114
    2.6242
   -1.3033
   -4.1024
  -10.0401
   -7.5729
   -8.6004
   -6.2795
   -4.1022
    1.4235
    4.2367
    6.9444
    6.2729
    3.7437
   -3.2208
   -5.0598
  -12.9943
  -11.1745
  -11.3076
   -7.6715
   -3.3979
   -0.7065
    5.1605
    8.8386
    7.7577
    3.8244
   -0.2474
   -6.6947
   -7.7312
  -10.5678
  -12.7885
   -5.2084
   -2.9970
   -0.9667
    3.3576
    8.3914
    8.1937
    3.9859
   -1.5466
   -6.4125
  -11.6224
   -8.1948
  -11.1734
   -4.7926
   -1.6590
    0.6739
    7.0800
    9.3661
    7.9048
    4.7383
   -1.0419
   -3.6467
   -9.8965
  -12.1473
  -12.4529
   -7.7836
   -5.5900
    0.8015
    5.8080
    9.0768
    8.3559
    6.6542
   -2.3820
   -6.0213
  -11.3363
   -9.1962
   -8.6401
   -5.4831
   -3.2538
    0.2112
    3.6362
    8.2628
    7.0422
    4.7852
    0.5112
   -6.1316
   -9.2077
   -7.8577
   -7.7200
   -4.4883
   -3.8294
    1.6644
    8.1887
    8.2986
    8.7621
    5.8336
    2.2502
   -5.8750
  -10.4719
  -10.0780
   -7.6985
   -6.5276
   -3.1379
    0.0642
    6.8243
    9.4227
    7.5231
    4.8453
    1.8218
   -3.2395
   -9.9894];

end

function T2M_MAX=T2M_MAX_data


T2M_MAX=[
   -3.6750
   -1.9985
    2.3857
    8.5256
   12.3849
   19.1713
   22.0663
   20.2371
   16.9669
    9.4122
    4.2306
   -2.3888
   -3.8050
   -1.6673
    0.5523
    9.4722
   12.2119
   20.3939
   23.5972
   20.2463
   15.6025
    6.3756
    1.8100
   -1.8039
    1.0221
   -2.7957
    2.6436
    8.4645
   12.9422
   15.7292
   24.5418
   21.7066
   15.2979
   11.9684
    1.0223
   -1.1682
   -2.0100
   -2.3142
    6.8961
    6.9550
   12.7395
   16.0001
   20.2799
   17.9299
   14.8566
    8.6849
    2.1557
   -0.4209
    0.7079
    0.7600
    2.5131
    7.5791
   12.4819
   16.6948
   23.3666
   19.7107
   17.3076
    9.6742
    4.0026
   -2.3930
   -0.1653
   -1.3720
    2.3169
    9.8612
   13.5062
   20.2935
   22.0563
   19.9343
   12.6884
    7.3860
    3.5155
   -1.4585
   -4.9649
   -1.0368
    5.8324
    6.8321
   12.2962
   18.7393
   22.4171
   21.9562
   16.6516
    9.9074
    4.5770
   -4.6262
   -4.6697
   -0.9089
    1.9740
    6.2142
   10.4084
   16.9496
   23.0898
   19.9584
   15.4132
    9.9429
    4.3428
   -2.8412
   -1.2443
    1.1146
    4.1214
    5.9949
   12.4899
   15.6837
   20.0782
   20.1647
   15.7193
    4.3180
    5.2208
   -5.6883
   -1.5255
   -2.9035
    3.5034
    6.5011
   10.0578
   18.1913
   21.7461
   20.4112
   18.9227
    9.9613
    1.7404
    0.3235
   -3.2202
   -3.6168
    3.7724
    5.7091
    9.0930
   17.8712
   21.6702
   22.6605
   15.9893
    9.2379
    2.8658
   -2.6883
    0.1468
   -2.2691
    7.9564
   10.2070
   13.7010
   22.2439
   23.2640
   22.0098
   17.1408
    8.4533
    5.7056
   -2.5111
   -2.5754
   -2.9297
    2.3538
    4.5675
   11.8812
   20.5711
   21.9853
   21.8701
   16.5835
    6.9473
    3.3280
   -3.7967
   -2.9298
   -2.0768
    4.3155
    6.7023
   11.6663
   17.7764
   21.3655
   18.8992
   17.2117
   11.3142
    1.8340
   -1.2201
   -0.4142
    0.6335
    6.5042
    7.6616
    9.3062
   20.0151
   20.6318
   21.9007
   18.9060
   12.1956
    2.6110
   -2.8081
   -2.6957
    1.4077
    3.4159
    6.6873
   11.0620
   21.0384
   23.1287
   20.3070
   17.7117
   12.4953
    5.9648
   -2.9565];

end

function rawtime=time_data

rawtime=     1.0e+03 *[
    0.0152
    0.0457
    0.0761
    0.1065
    0.1370
    0.1674
    0.1978
    0.2283
    0.2587
    0.2892
    0.3196
    0.3500
    0.3805
    0.4109
    0.4413
    0.4718
    0.5022
    0.5327
    0.5631
    0.5935
    0.6240
    0.6544
    0.6848
    0.7153
    0.7457
    0.7762
    0.8066
    0.8370
    0.8675
    0.8979
    0.9283
    0.9588
    0.9892
    1.0197
    1.0501
    1.0805
    1.1110
    1.1414
    1.1718
    1.2023
    1.2327
    1.2632
    1.2936
    1.3240
    1.3545
    1.3849
    1.4153
    1.4458
    1.4762
    1.5067
    1.5371
    1.5675
    1.5980
    1.6284
    1.6588
    1.6893
    1.7197
    1.7502
    1.7806
    1.8110
    1.8415
    1.8719
    1.9023
    1.9328
    1.9632
    1.9937
    2.0241
    2.0545
    2.0850
    2.1154
    2.1458
    2.1763
    2.2067
    2.2372
    2.2676
    2.2980
    2.3285
    2.3589
    2.3893
    2.4198
    2.4502
    2.4807
    2.5111
    2.5415
    2.5720
    2.6024
    2.6328
    2.6633
    2.6937
    2.7242
    2.7546
    2.7850
    2.8155
    2.8459
    2.8763
    2.9068
    2.9372
    2.9677
    2.9981
    3.0285
    3.0590
    3.0894
    3.1198
    3.1503
    3.1807
    3.2112
    3.2416
    3.2720
    3.3025
    3.3329
    3.3633
    3.3938
    3.4242
    3.4547
    3.4851
    3.5155
    3.5460
    3.5764
    3.6068
    3.6373
    3.6677
    3.6982
    3.7286
    3.7590
    3.7895
    3.8199
    3.8503
    3.8808
    3.9112
    3.9417
    3.9721
    4.0025
    4.0330
    4.0634
    4.0938
    4.1243
    4.1547
    4.1852
    4.2156
    4.2460
    4.2765
    4.3069
    4.3373
    4.3678
    4.3982
    4.4287
    4.4591
    4.4895
    4.5200
    4.5504
    4.5808
    4.6113
    4.6417
    4.6722
    4.7026
    4.7330
    4.7635
    4.7939
    4.8243
    4.8548
    4.8852
    4.9157
    4.9461
    4.9765
    5.0070
    5.0374
    5.0678
    5.0983
    5.1287
    5.1592
    5.1896
    5.2200
    5.2505
    5.2809
    5.3113
    5.3418
    5.3722
    5.4027
    5.4331
    5.4635
    5.4940
    5.5244
    5.5548
    5.5853
    5.6157
    5.6462
    5.6766
    5.7070
    5.7375
    5.7679
    5.7983
    5.8288];


end

function VPD=VPD_data

VPD=[
    1.8757
    2.3862
    3.4697
    7.0442
    8.3897
   15.6347
   17.7010
   14.6575
   12.3236
    7.4289
    4.0617
    2.2261
    2.0000
    3.1955
    3.5800
    7.8472
    9.1997
   17.4483
   21.3978
   16.9475
   10.9109
    5.6150
    3.5944
    2.2852
    2.9202
    2.2092
    3.7532
    7.1016
    9.1597
   10.7459
   23.6770
   17.6762
   11.6961
    9.4660
    3.2832
    2.6932
    2.6597
    2.3794
    6.6418
    5.6480
    9.7339
   11.5245
   15.2324
   12.9023
   10.4964
    5.9784
    3.3775
    2.8501
    3.1338
    3.7745
    4.5437
    6.6484
    8.9747
   11.9093
   21.3092
   15.5992
   13.9485
    6.7381
    4.8426
    2.5933
    3.5204
    3.5244
    4.4426
    8.5369
   10.5728
   17.6257
   17.6093
   14.3732
    8.9448
    5.3227
    4.6308
    2.4684
    1.6163
    2.8170
    5.8914
    5.7761
    8.2936
   15.4434
   18.9299
   17.6555
   12.5384
    7.1680
    5.2754
    1.5427
    1.8928
    3.1349
    4.2152
    6.7078
    7.8762
   13.7653
   20.9667
   15.0886
   11.2523
    7.9490
    4.6920
    2.2117
    2.9491
    4.0330
    5.6673
    5.5485
    8.7232
   10.3915
   15.7727
   17.0343
   11.1382
    3.7753
    5.5647
    1.6785
    2.4971
    2.4135
    4.9851
    5.8417
    7.6650
   13.9196
   17.6529
   15.4393
   16.8433
    6.9775
    3.8243
    2.8097
    2.1846
    2.3948
    5.0283
    5.3570
    6.9745
   14.6103
   16.4612
   19.2051
   11.5533
    7.0912
    4.3587
    2.2143
    3.5585
    2.5226
    7.9065
    8.5381
   11.1181
   21.7436
   18.9672
   19.8385
   13.9811
    7.0468
    6.0260
    2.5261
    2.6868
    2.5401
    4.5444
    5.0490
    8.4771
   18.5859
   17.7429
   17.5456
   10.6880
    5.3600
    4.1516
    2.0587
    2.2899
    2.2970
    5.3279
    6.0621
    8.3107
   13.9318
   16.1811
   12.9965
   12.1823
    8.2512
    3.5518
    2.4819
    2.4386
    3.2467
    5.8534
    6.4590
    4.4609
   13.8464
   15.3798
   18.0573
   15.0409
    8.4820
    4.0583
    2.1122
    2.0325
    3.8294
    4.4100
    5.3633
    7.3872
   16.8122
   20.7488
   16.1940
   14.1775
    9.6421
    5.3420
    2.1557];


end
