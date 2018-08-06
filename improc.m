function [he, we, sym, watSize, dim]=improc(in_im,m)

procim=imread(in_im);
[he we dim]=size(procim);
type=dim;

switch type
    
    case 1   %Grayscale
        if m==2
            resIm=reshape(procim,[1,he*we]);
            binform=de2bi(resIm);
            sym=reshape(double(binform),[1 he*we*8]);  %% yang bakal disisipkan       
            watSize=8*he*we;     %% watsize
%         elseif m==4
%             resIm=reshape(procim,[1,a*b]);
%             binwres=de2bi(d);
%             c=rectpulse(double(d));            
%             d=reshape(binwres,[2,4*a*b]);
%             e=a*b;
        elseif m==256
            resIm=reshape(procim,[1,he*we]);
            sym=double(resIm);            
            watSize=he*we;
        end
        
%     case 3   %RGB
%         if m==2
%             d=reshape(procim,[1,3*a*b]);
%             binwres=de2bi(d);
%             d=reshape(binwres,[1,8*3*a*b]);   %% yang bakal di cek error rate
%             c=rectpulse(double(d));  %% yang bakal disisipkan
%             e=8*3*a*b;     %% watsize
%         elseif m==256
%             d=reshape(procim,[1,3*a*b]);
%             c=rectpulse(double(d));
%             binwres=de2bi(d);
%             d=reshape(binwres,[1,8*3*a*b]);
%             e=3*a*b;
%         end
        
end


