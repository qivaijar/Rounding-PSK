function [ber,structsim]=extract(file,key_file)
%% load variable
load(key_file);
%% generate Graycode
M= mary;
Symbol = (0:M-1);
GCodes = bin2gray(Symbol,'psk',M);
% %% decision region
% arch = arc/2;                   
% PhaseSpace = arc/M;
% 
% for in=1:M+1
%     PhaseTh(in)=-arch+(in-1)*PhaseSpace;
%     PhaseThRad(in)=PhaseTh(in)*pi/180;
% end
% Dr=PhaseThRad;

%% sound preprcessing (framing)
[yaw fs]=audioread(file);
Y=buffer(yaw,n_samp);
yfr=fft(Y);
[x y]=size(yfr);

%% extracting
im=1;
wr=[];


rn=extractDigit(alfa)-2;


sp=ini_samp;
ai=1;
eP=[];

maxSamp=((n_samp/2)*bandDiv);
for ai=1:y-1
    
    while sp<=maxSamp
        if im>watSize
            break
        end
        if abs(yfr(sp,ai))>treshold  && angle(yfr(sp,ai))~=0
           exPhase=alfa*(angle(yfr(sp,ai))-round(angle(yfr(sp,ai)),rn));
           eP=[eP exPhase];
           im=im+1;
        end
        sp=sp+jump;
     
        
    end
    sp=ini_samp;
end
compEp=cos(eP)+1i*sin(eP);
wr=pskdemod(compEp,M,pi/2);
[wtd ber]=imrecon(coltype,mary,wr,wres,he,we,tb);

finewater=uint8(wtd);
imwrite(finewater,'eks.bmp');
structsim= ssim(finewater,imread(waterim));