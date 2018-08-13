function [Proc_im ER]=imrecon(c_type,mary,es,OriSym,H,W,tb)


switch c_type
    case 1 %graysclae
        if mary==2
            wri=uint8(es);
            if length(wri)<length(OriSym)
                wri=[wri randi([0 mary-1],1,length(OriSym)-length(wri))];
            end
            [a ER]=symerr(OriSym,wri);  
            wet=uint8(reshape(wri,[H*W,8]));
            Proc_im=bi2de(wet).';
            Proc_im=reshape(Proc_im,[H,W]);
            
        elseif mary==4
            wri=uint8(es);
            if length(wri)<length(OriSym)
                wri=[wri randi([0 mary-1], 1,length(OriSym)-length(wri))];
            end
            wet=uint8(wri).';           
            writee=reshape(de2bi(wri),[1 8*H*W]);
            OriSym=reshape(de2bi(OriSym),[1 8*H*W]);
            [a ER]=symerr(OriSym,uint8(writee));        
            
            Proc_im=de2bi(wet);
            Proc_im=reshape(Proc_im,[H*W,8]);
            Proc_im=reshape(bi2de(Proc_im),[H,W]);
       
        elseif mary==8
            wri=uint8(es);
            if length(wri)<length(OriSym)
                wri=[wri randi([0 mary-1], 1,length(OriSym)-length(wri))];
            end
            wet=uint8(wri).';           
            writee=reshape(de2bi(wri),[1 3*length(wri)]);
            writee=writee(1:tb);
            OriSym=reshape(de2bi(OriSym),[1 8*H*W]);
            [a ER]=symerr(OriSym,uint8(writee));        
            
            Proc_im=de2bi(wet);
            Proc_im=reshape(Proc_im,[H*W,8]);
            Proc_im=reshape(bi2de(Proc_im),[H,W]);
            
        elseif mary==256
            wri=uint8(es);
            if length(wri)<length(OriSym)
                wri=[wri randi([0 mary-1], 1,length(OriSym)-length(wri))];
            end
            Proc_im=uint8(reshape(wri,[H,W]));
            writee=reshape(de2bi(wri),[1 8*H*W]);
            OriSym=reshape(de2bi(OriSym),[1 8*H*W]);
            [a ER]=symerr(OriSym,uint8(writee));
        end
%         
%     case 3
%         if mary==2
%             wri=intdump(uint8(es));
%             if length(wri)<length(OriSym)
%                 wri=[wri randi([0 mary-1],1,length(OriSym)-length(wri))];
%             end
%             [a ER]=symerr(OriSym,wri);
%             %%reshape watermark
%             wet=uint8(reshape(wri,[3*H*W,8]));
%             wri=bi2de(wet).'; 
%             w1=wri(1:H*W*3/3);
%             w2=wri(H*W*3/3+1:2*H*W*3/3);
%             w3=wri(2*H*W*3/3+1:3*H*W*3/3);
%             water1=reshape(w1,[H W]);
%             water2=reshape(w2,[H W]);
%             water3=reshape(w3,[H W]);
%             water(:,:,1)=water1;
%             water(:,:,2)=water2;
%             water(:,:,3)=water3;
%             Proc_im=water;
%             
%         elseif mary==256
%             wri=uint8(intdump(uint8(es));
%             if length(wri)<H*W
%                 wri=[wri randi([0 mary-1], 1,3*H*W-length(wri))];
%             end
%             w1=wri(1:H*W*3/3);
%             w2=wri(H*W*3/3+1:2*H*W*3/3);
%             w3=wri(2*H*W*3/3+1:3*H*W*3/3);
%             water1=reshape(w1,[H W]);
%             water2=reshape(w2,[H W]);
%             water3=reshape(w3,[H W]);
%             water(:,:,1)=water1;
%             water(:,:,2)=water2;
%             water(:,:,3)=water3;
%             Proc_im=water;
%             wri=reshape(de2bi(wri),[1 8*H*W*3]);
%             [a ER]=symerr(OriSym,uint8(wri));
%         end
end