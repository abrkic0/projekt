% Pretpostavlja da su podaci u folderu Dataset/rijec
% Ucitava sve fileove oblika *rijecbroj.wav

function [yy,ff,id] = ucitaj(rijec,broj)

    oblik = strcat('*',rijec,int2str(broj),'.wav');
    k = length(oblik)-1;
    datoteka = strcat('..\','Dataset','\',rijec);
    ukupno_ime = strcat(datoteka,'\',oblik);

    fnames = dir(ukupno_ime);
    n = length(fnames);
    yy = cell(n,1);
    ff = zeros(n,1);
    id = zeros(n,1);
    
    for i = 1:n
        ime = fnames(i).name;
        puno_ime = strcat('..\','Dataset','\',rijec,'\',ime);
        [y,f] = wavread( puno_ime);
        yy{i} = y;
        ff(i) = f;
        
        id_tren = ime(1:length(ime)-k);
        id(i) = str2double(id_tren);
    end
    
end

% testiraj 
% sound(yy{6},ff(1));