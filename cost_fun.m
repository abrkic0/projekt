function out = cost_fun(pred, stv)
%Mjera entropije za binarnu klasifikaciju
%Koristimo je kod odreðivanja najboljih hiperparametara modela

pred = double(pred(:))+0.0000001;
stv = double(stv(:));
out = sum(-stv.*log(pred) - (1-stv).*log(1-pred));


end

