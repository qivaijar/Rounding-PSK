function yfc=embed(fileori,waterim,arc,alfa,n_samp,ini_samp,jump,BitPerSample,attack,pulsenum,mary,treshold)
warning('off','all');
%% info
%coltype = 1-Grayscale,2-BW,3-RGB
%attack = 0-no attack
%mary = 2-BPSK. 256-256PSK  

asdqwe=pwd;
%% Parameter check
x = log2(n_samp);
if round(x) ~= x
    msg = 'n_samp has to be a number of the series of 2^n';
    error(msg);
end
if ini_samp == 1 || ini_samp>(n_samp)/2
    msg = ['The value of ini_samp should be between 2 - ', num2str(n_samp/2)];
    error(msg);
end
if jump <= 0
    msg = 'The value of jump should be > 0';
    error(msg);
end
if BitPerSample~=8 && BitPerSample~=16 && BitPerSample~=24 && BitPerSample~=32 && BitPerSample~=64
    msg = 'The value fr BPS : 8,16,24,32,64'
    error(msg);
end

%% generate graycode
M= mary;
Symbol = (0:M-1);
GCodes = bin2gray(Symbol,'psk',M);
%% generate symbol phase and convert into radian
% arc = 300;                                          %OV
arch = arc/2;
PhaseSpace = arc/M;
% alpha=100;                                         %OV  ;minimal 100. dibawah 100 ke-clip
for sim=1:M    %sim = titik atau plot di diagram konstelasi
    PlotDeg(sim)=-arch+(sim-0.5)*PhaseSpace;
    PlotRad(sim)=PlotDeg(sim)*pi/180;
    EPhase(sim)=PlotRad(sim)/alfa;
end
padd=EPhase;
%% image preprocessing
[a b c d e dim]=improc(waterim,mary,pulsenum);
p=a;l=b;wres=c;wresi=d;watSize=e;
coltype=dim;
%% sound preprcessing (framing)
[ye fs]=audioread(fileori);
Y=buffer(ye,n_samp);
yf=fft(Y,n_samp,1);
%% maximum channel per frame
[x y]=size(yf);
mxs=mws1(yf,ini_samp,n_samp,y,jump,treshold);
if mxs<watSize
    msg='Tidak cukup slot watermark tersedia. Coba ubah gambar atau parameter kapasitas.';
    ini_samp
    n_samp
    jump
    mxs
    watSize
    error(msg);
end
%% embedding
sp=ini_samp;     %untuk tahu batasan embedd
ai=1;            %untuk col yf
j=1;             %index simbol
im=1;            %index watermark

rn=extractDigit(alfa)-2;

% if alfa<100      %nentuin besar pembulatan
%     rn=0;          %eksper
% elseif alfa<1000
%     rn=1;
% elseif alfa<10000
%     rn=2;
% elseif alfa<100000
%     rn=3;
% elseif alfa<1000000
%     rn=4;
% end

for ai=1:y-1                                            %index kolom
% for ai=round(y/3):y-1
    while sp<=n_samp/2                                      %kalau index baris masih dalam batasan n_samp, lanjutkan proses embedding
        
        %            if abs(yf(sp,ai))~=0 && angle(yf(sp,ai))~=0
        if abs(yf(sp,ai))>treshold && angle(yf(sp,ai))~=0
            while wres(im)~=GCodes(j)                        %nyari graycodes untuk simbol
                j=j+1;
            end
            es=yf(sp,ai);
            emPhase=round(angle(es),rn)+padd(j);
            if (emPhase>pi)
                emPhase=round(angle(es)-1,rn)+padd(j);
            elseif (emPhase<-pi)
                emPhase=round(angle(es)+1,rn)+padd(j);
            end
                
            yf(sp,ai)=abs(es).*exp(1i*(emPhase));
            im=im+1;
            if im>watSize
                break
            end
        end
        sp=sp+jump;
        j=1;
    end
    sp=ini_samp;
    if im>watSize
        break
    end
end
%% frame mirroring
for fm=1:y
    yf((n_samp/2)+2:n_samp,fm)=flipud(conj(yf(2:n_samp/2,fm)));
end
%% recombine samples
[ax bx]=size(yf);
yembed=ifft(yf);
yfc=reshape(yembed,[ax*bx],1);
yfc=yfc(1:length(ye));
%% write audio file
audiowrite('Folder watermark\sny_w.wav',yfc,fs,'BitsPerSample',BitPerSample);
%% ATTACK
if attack~=0
    alltestbed(attack,[asdqwe '\Folder watermark\'],[asdqwe '\Folder attack\'],BitPerSample);
    cd(asdqwe);
end
%% save watermark key
delete key.mat
save('key.mat','alfa','n_samp','ini_samp','jump','arc','watSize','p','l','wresi','pulsenum','coltype','mary','treshold','dim','waterim');