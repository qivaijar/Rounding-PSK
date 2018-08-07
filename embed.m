function embed(fileori,waterim,alfa,n_samp,ini_samp,jump,BitPerSample,attack,mary,treshold)
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
%% image preprocessing
[he we sym watSize dim]=improc(waterim,mary);
wres=sym;
coltype=dim;

%% generate symbol phase and convert into radian

padd=angle(pskmod(GCodes,M,pi/2));
padd=padd./alfa;
%% sound preprcessing (framing)
[ye fs]=audioread(fileori);
Y=buffer(ye,n_samp);
yf=fft(Y,n_samp,1);
%% maximum channel per frame
[x y]=size(yf);


bandDiv=1;   %frequency band division factor for watermarking slot limitation (greater than 0, maximum 1)

mxs=mws1(yf,ini_samp,n_samp,y,jump,treshold,bandDiv);
if mxs<watSize
    msg='Not enough watermarking slot to embed the watermark.';
    ini_samp
    n_samp
    jump
    mxs
    watSize
    error(msg);
end
%% embedding
sp=ini_samp;     %to find the limitation of watermarking slot
ai=1;            %for column calculation
j=1;             %symbol index
im=1;            %watermark index


    %division factor for the band limitation

rn=extractDigit(alfa)-2;

for ai=1:y-1                                            %index kolom

    while sp<=round(n_samp/(2*bandDiv))
        
        if abs(yf(sp,ai))>treshold && angle(yf(sp,ai))~=0
            while wres(im)~=GCodes(j) %finding the Grycodes for the symbol
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
save('key.mat','alfa','n_samp','ini_samp','jump','watSize','he','we','wres','coltype','mary','treshold','dim','waterim','bandDiv');