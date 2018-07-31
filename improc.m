function [a b c d e dim]=improc(in_im,m,pulse)

pulsenum=pulse;
procim=imread(in_im);
[a b dim]=size(procim);
type=dim;

switch type
    
    case 1   %Grayscale
        if m==2
            d=reshape(procim,[1,a*b]);
            binwres=de2bi(d);
            d=reshape(binwres,[1,8*a*b]);   %% yang bakal di cek error rate
            c=rectpulse(double(d),pulsenum);  %% yang bakal disisipkan
            e=8*a*b*pulsenum;     %% watsize
        elseif m==256
            d=reshape(procim,[1,a*b]);
            c=rectpulse(double(d),pulsenum);
            binwres=de2bi(d);
            d=reshape(binwres,[1,8*a*b]);
            e=a*b*pulsenum;
        end
        
    case 3   %RGB
        if m==2
            d=reshape(procim,[1,3*a*b]);
            binwres=de2bi(d);
            d=reshape(binwres,[1,8*3*a*b]);   %% yang bakal di cek error rate
            c=rectpulse(double(d),pulsenum);  %% yang bakal disisipkan
            e=8*3*a*b*pulsenum;     %% watsize
        elseif m==256
            d=reshape(procim,[1,3*a*b]);
            c=rectpulse(double(d),pulsenum);
            binwres=de2bi(d);
            d=reshape(binwres,[1,8*3*a*b]);
            e=3*a*b*pulsenum;
        end
        
    otherwise %RGB
end


