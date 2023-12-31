function MA=CARDAMOM_MODEL_LIBRARY(ID,MA,reread)
%MA=CARDAMOM_MODEL_LIBRARY(ID)
%
%INPUTS: CARDAMOM model ID (integer) OR structure with ID field. 
%This function reads C code and extracts model attributes
%[Cpath]/projects/CARDAMOM_GENERAL/CARDAMOM_MODEL_LIBRARY.c
%OUTPUTS: "MA" structure with CARDAMOM model attributes:
%Specifically, the structure contains
% MA.nopools: number of model pools
%MA.nopars: number of model parameters
%MA.nofluxes: number of stored model fluxes
%
%Example: 
%   MA=CARDAMOM_MODEL_LIBRARY(2);
%
%Last modified by A.A. Bloom 2020 June 17
Cpath=getenv('CARDAMOM_C_PATH');

%C script
if nargin<2;MA=[];end
if nargin<3;reread=0;end

%if isstruct(ID);MA=ID;ID=MA.ID;end
if isstruct(ID);ID=ID.values;end
dumpfile=sprintf('DUMPFILES/CARDAMOM_MODEL_LIBRARY_ID=%i.mat',ID);
%TO DO: access new model types here (805 etc.) eventually making access to
%CARDAMOM_MODEL_LIBRARY.c obsolete


% 
% if reread==1
% %*****Step 0. Re-run CARDAMOM_ASSEMBLE_MODELS.exe
% unix(sprintf('./%s/projects/CARDAMOM_GENERAL/CARDAMOM_ASSEMBLE_MODELS.exe %s',Cpath,Cpath));
% end

%*****Step 1. find path for model info*****
filename=sprintf('%s/projects/CARDAMOM_MODELS/DALEC/DALEC_%i/DALEC_%i.c',Cpath,ID,ID);
stack_filename=sprintf('%s/projects/CARDAMOM_MODELS/DALEC/DALEC_%i/dalec_%i_pars.txt',Cpath,ID,ID);

%filename=sprintf('%s/projects/CARDAMOM_GENERAL/CARDAMOM_MODEL_LIBRARY.c',Cpath);
filedir=dir(filename);
if isempty(filedir);error('Warning: model version not currently supported by CARDAMOM');end
dumpfiledir=dir(dumpfile);

if isempty(dir(dumpfile)) | reread==1 | dumpfiledir.datenum<filedir.datenum
    disp('Re-reading file...');



    %**************
D=readalllines(filename);
%searching for model attribute" line zero"
%this line contains exactly '/*IDxMA*/' where x is the model ID number
%line0=find(strcmp(D,sprintf('/*ID%dMA*/',ID)));


for n=1:numel(D)
    %reading strings that read as follows
    %DATA->nopools=7;
    if strncmp(D{n},'DALECmodel->no',14)
        %E.g. evaluates  'DALECmodel.nopools=7;'
        st=D{n};st(st=='>')='.';st=st(st~='-');
    eval(st(1:find(st==';',1)));
    end
end








%Overwriting with stack file
if isfile(stack_filename)
D=readalllines(stack_filename);
for n=1:size(D);
    eval(D{n});
end




else
%Find parameter info here *******
parfilename=sprintf('%s/projects/CARDAMOM_MODELS/DALEC/DALEC_%i/DALEC_%i_INDICES.c',Cpath,ID,ID);
 D=readalllines(parfilename);

 
%'/*DALEC PARAMETERS*/'
 k=0;n=1;p=0;
 while k<2;
          linestr=D{n};

     if k==1
         if strcmp(linestr(1:4),'int ')
         %Assumes "int " (4 characters) is removed
         eval(sprintf('P.%s = %i +1;',linestr(5:find(linestr==';',1)-1),  p));
         p=p+1;
         else
             k=2;
         
         end
     end

if strcmp(linestr,'/*DALEC PARAMETERS*/');disp(linestr);k=1;end

     n=n+1;


 end
 

 
%'/*DALEC FLUXES*/'
 k=0;n=1;p=0;
 while k<2;
          linestr=D{n};

     if k==1
         if strcmp(linestr(1:4),'int ')
         %Assumes "int " (4 characters) is removed
         eval(sprintf('F.%s = %i +1;',linestr(5:find(linestr==';',1)-1),  p));
         p=p+1;
         else
             k=2;
         
         end
     end

if strcmp(linestr,'/*DALEC FLUXES*/');disp(linestr);k=1;end

     n=n+1;


 end
 

%'/*DALEC POOLS*/'
 k=0;n=1;p=0;
 while k<2;
          linestr=D{n};

     if k==1
         if strcmp(linestr(1:4),'int ')
         %Assumes "int " (4 characters) is removed
         eval(sprintf('S.%s = %i + 1;',linestr(5:find(linestr==';',1)-1),  p));
         p=p+1;
         else
             k=2;
         
         end
     end

if strcmp(linestr,'/*DALEC POOLS*/');disp(linestr);k=1;end

     n=n+1;


 end
 

 
  
 MA.PARAMETER_IDs=P;
MA.FLUX_IDs=F;
MA.POOL_IDs=S;
 
 
 


%******************If FIOMATRIX is available******

D=readalllines(filename);

strfss='int DALEC_1100_FLUX_SOURCES_SINKS';
strncmp(D,strfss,numel(strfss));
if sum(strncmp(D,strfss,numel(strfss)))>0;

for n=1:numel(D);
    if isempty(strfind(D{n},'FIOMATRIX.'))==0 & isempty(strfind(D{n},'calloc')) & isempty(strfind(D{n},'for'))
        %E.g. evaluates  FIOMATRIX.SINK[F.lab_prod]=S.C_lab;
%         st=D{n};st(st=='>')='.';st=st(st~='-');
     st=D{n};
        b1=find(st=='[');
     b2=find(st==']');
     st(b1)='(';
     st(b2)=')';
        eval(st(1:find(st==';',1)));
    end

    end
    MA.FIOMATRIX=FIOMATRIX;
else
    MA.FIOMATRIX='No compliant FIOMATRIX structure in this model ID';
end







parfilename=sprintf('%s/projects/CARDAMOM_MODELS/DALEC/DALEC_%i/PARS_INFO_%i.c',Cpath,ID,ID);


%repeat the same with model parameter value ranges
%TO DO: need to set these up for other models too


 D=readalllines(parfilename);

 pn=1;
 for n=1:numel(D)
     linestr=D{n};
     if numel(linestr)>6 & strcmp(linestr(1),'p')==1  
     %linestr(linestr=='-')='';
     %linestr(linestr=='>')='.';
     b1=find(linestr=='[');
     b2=find(linestr==']');
     linestr(b1)='(';
     linestr(b2)=')';
     lnum=num2str(eval(linestr(b1+1:b2-1)));%No correction needed here
     linestr=[linestr(1:b1),lnum,linestr(b2:end)];
     %Find first ";"
     strev=linestr(1:find(linestr==';',1));
     %disp(strev)
     eval(strev);
     %Storing parameter name based on line above parmin
     if strcmp(linestr(1:6),'parmin');
         if numel(D{n-1})>2 & strcmp(D{n-1}(1:2), '/*')
         parname{pn}=D{n-1};
         else
             parname{pn}='';
         end
         pn=pn+1;
     end
     
     end
 end
% 
% 
 MA.parmin=parmin;
 MA.parmax=parmax;
 MA.parname=parname;
 
end


%Store fields regardless
for f=fieldnames(DALECmodel)';
            MA.(f{1})=DALECmodel.(f{1});
end


 
 
 
 %Random sample
 MA.parrand=@(N) logrand(MA.parmin,MA.parmax,N);
 MA.par2nor=@(pars) log(pars./repmat(MA.parmin,[size(pars,1),1]))./log(repmat(MA.parmax./MA.parmin,[size(pars,1),1]));
 MA.nor2par=@(npars) repmat(MA.parmin,[size(npars,1),1]).*(repmat(MA.parmax,[size(npars,1),1])./repmat(MA.parmin,[size(npars,1),1])).^npars;




save(dumpfile,'MA');
else
    MAall=MA;
   load(dumpfile,'MA');
end

MA.ID=ID;


%hellop
end





function D=readalllines(fname)

fid=fopen(fname);
A=fgetl(fid);
n=1;
while ischar(A)
    D{n}=A;
    n=n+1;
    A=fgetl(fid);   
end

end

