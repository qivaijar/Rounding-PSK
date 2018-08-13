function [he, we, sym, watSize, dim,tb]=improc(in_im,m)

procim=imread(in_im);
[he we dim]=size(procim);
type=dim;

bitpersamp=8;        %Grayscale

tb=he*we*bitpersamp;


switch type
    
    case 1   %Grayscale
        if m==2
            resIm=reshape(procim,[1,he*we]);
            binform=de2bi(resIm);
            sym=reshape(double(binform),[1 he*we*8]);  %% symbol to be embedded
            watSize=size(sym);    
        elseif m==4
            resIm=reshape(procim,[1,he*we]);
            binform=de2bi(resIm);           
            binform=reshape(binform,[he*we*4,2]);
            sym=double(bi2de(binform).');
            watSize=size(sym);
        elseif m==8
            resIm=reshape(procim,[1,he*we]);
            binform=de2bi(resIm);           
            binform=reshape(binform,[1,size(binform,1)*size(binform,2)]);            
            binform=buffer(binform,3).';
            sym=double(bi2de(binform).');
            watSize=size(sym);
        elseif m==256
            resIm=reshape(procim,[1,he*we]);
            sym=double(resIm);            
            watSize=size(sym);
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


