%STep 1. Load US-NR1


nccbffilename1100='CARDAMOM/DATA/CARDAMOM_DEMO_DRIVERS_prototype.cbf.nc';

CBF=CARDAMOM_READ_NC_CBF_FILE(nccbffilename1100);

%STep 2. Subset July
CBFsubset=CARDAMOM_SUBSET_NC_CBF_STRUCTURE(CBF, 7);

CBFsubset1100=CBFsubset;

%Step 3. Prescribe only Cfoliar and LAI parameters
MD1100=CARDAMOM_MODEL_LIBRARY(1100);
MD1005=CARDAMOM_MODEL_LIBRARY(1005);


LAI=0.1:0.1:10;
pars1100=repmat(exp(log(MD.parmin)*0.5+log(MD.parmax)*0.5),[numel(LAI),1]);


%ones(numel(LAI),54);

g1=2;
vcmax25=50;
tminmin=-20+273;
tminmax=1+273;
ga=2;
Tupp=315;
Tdown=275;
C3_frac=1;
CI=0.5;
LSA=0.5;



pars1100(:,41)=g1;
pars1100(:,42)=vcmax25;
pars1100(:,43)=tminmin;
pars1100(:,44)=tminmax;
pars1100(:,45)=ga;
pars1100(:,46)=Tupp;
pars1100(:,47)=Tdown;
pars1100(:,48)=C3_frac;
pars1100(:,49)=CI;
pars1100(:,50)=LSA;
pars1100(:,16)=100;%LCMA
pars1100(:,18)=pars1100(:,16).*LAI';


CBR1100=CARDAMOM_RUN_MODEL(CBFsubset1100,pars1100);


CBFsubset1005=CBFsubset;CBFsubset1005.ID.values=1005;

pars1005=ones(numel(LAI),37);
pars1005(:,17)=100;
pars1005(:,11)=20;
pars1005(:,19)=pars1005(:,17).*LAI';

CBR1005=CARDAMOM_RUN_MODEL(CBFsubset1005,pars1005);


figure(1);clf
subplot(2,2,1)
hold on
plot(LAI,CBR1100.GPP,'b.-');
plot(LAI,CBR1005.GPP,'r.-');
legend('New GPP','ACM GPP')
xlabel('LAI [m2/m2]')
ylabel('GPP [gC/m2/d]')
subplot(2,2,2)
hold on
plot(LAI,CBR1100.GPP,'b.-');
legend('New GPP','ACM GPP')
xlabel('LAI [m2/m2]')
ylabel('GPP [gC/m2/d]')

