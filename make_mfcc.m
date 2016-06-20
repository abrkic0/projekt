function [out, ids, granice] = make_mfcc(y,fs,id,C, Tw, Ts)
%Fja iz liste zvu�nih zapisa ra�una mfcc koeficijente i vra�a dataset te
%idjeve

%Prima:
% y - lista vektora zvu�nih zapisa
% Fs - frequency sampled (vektor za svaki zapis u listi)
% id - vektor pripadnosti za svaki zvu�ni zapis
% C = 13  - broj MFCC koeficijnata koje zelimo
% Tw = 25 - Duljina jednog frame u ms
% Ts = 10 - Za koliko ms pocinje iduci frame

% Vra�a
% out - dataset, redak odgovara jednom frameu necijeg zapisa, a stupci su
%       mfcc koeficijenti
% ids - vektor kojem id-u pripada koji frame zapisa
% granice - matrica koja govori na u kojem retku po�inju frameovi kojeg
%           zapisa u prvom retk, a u drugom gdje zavr�avaju

switch nargin
    case 3
        C = 13;
        Tw = 25;
        Ts = 10;
    case 4
        Tw = 25;
        Ts = 10;
    case 5
        Ts = 10;
    case 6
    otherwise
        error('make_mfcc - neto�an broj ulaznih argumenata');
end
koliko = zeros(1,length(y));

ids = [];
out = [];
for i = 1:length(y)
    X = moj_mfcc(y{i},fs(i),C,Tw,Ts);
    m = size(X,1);
    koliko(i) = m;
    ids_tmp = id(i)*ones(m,1);
    
    out = [out;X];
    ids = [ids;ids_tmp];
end
granice = zeros(2,length(y));
cums = cumsum(koliko);
granice(1,:) = [1,cums(1:end-1)+1];
granice(2,:) = cums;
end

