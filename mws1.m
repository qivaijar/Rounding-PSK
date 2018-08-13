function mas = mws(host_audio,start_point,n_point,column_number,skip,treshold,bd);
mas=0;
ss=start_point;

msamp=round((n_point/2)*bd);
for col=1:column_number-1
    while ss<=msamp                               %max avalaible sample
        if abs(host_audio(ss,col))>treshold && angle(host_audio(ss,col))~=0
            mas=mas+1;
        end
        ss=ss+skip;
    end
    ss=start_point;
end