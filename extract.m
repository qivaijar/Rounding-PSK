function [ber,structsim]=extract(file,key_file)
%% load variable
load(key_file);
%% generate Graycode
M= mary;
Symbol = (0:M-1);
GCodes = bin2gray(Symbol,'psk',M);
%% decision region
arch = arc/2;                     %OV
PhaseSpace = arc/M;

for in=1:M+1
    PhaseTh(in)=-arch+(in-1)*PhaseSpace;
    PhaseThRad(in)=PhaseTh(in)*pi/180;
end
Dr=PhaseThRad;

%% sound preprcessing (framing)
[yaw fs]=audioread(file);
% y=yfc;

% mean((y-yfc).^2)
Y=buffer(yaw,n_samp);
yfr=fft(Y);
[x y]=size(yfr);

% yfr=yf;
% [x y]=size(yfr);
%% extracting
im=1;
wr=[];


rn=extractDigit(alfa)-2;

% if alfa<100      %nentuin besar pembulatan
%     rn=0;        %eksper
% elseif alfa<1000
%     rn=1;
% elseif alfa<10000
%     rn=2;
% elseif alfa<100000
%     rn=3;
% elseif alfa<1000000
%     rn=4;
% end



j=1;
sp=ini_samp;
ai=1;

for ai=1:y-1
    
    while sp<=n_samp/2                                      %kalau index kolom masih dalam batasan n_samp, lanjutkan proses extracting
        if im>watSize
            break
        end
        if abs(yfr(sp,ai))>treshold  && angle(yfr(sp,ai))~=0
            
            eP=alfa*(angle(yfr(sp,ai))-round(angle(yfr(sp,ai)),rn));
            
            while ~(eP>=Dr(j) && eP<Dr(j+1))
                j=j+1;
                if j>M
                    j=randi([1 M],1);                %random 0 atau 1 untuk nilai M-ary =2
                    break
                end
            end
            
            wr(im)=GCodes(j);
            im=im+1;
        end
        sp=sp+jump;
        j=1;
        
    end
    sp=ini_samp;
end

[wtd ber]=imrecon(coltype,mary,wr,pulsenum,wresi,p,l);

finewater=uint8(wtd);
imwrite(finewater,'eks.bmp');
structsim= ssim(finewater,imread(waterim));