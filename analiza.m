function [konf,P,R,F] = analiza(pred,stvarni,alfa)
%Za binarne vektore predikcija (pred) i stvarnih klasa (stvarni) vraæa
%konfuzijsku matricu (konf), precision (P), recall(R), te F_alfa mjeru (F)

    if nargin < 3
        alfa = 0.5;
    end
    
    stvarni = stvarni(:);
    pred = pred(:);
    stvarni = logical(stvarni);
    pred = logical(pred);
    
    indeksi_poz = (stvarni==1);
    TP = sum(pred(indeksi_poz));
    FN = sum(indeksi_poz)-TP;
    indeksi_neg = (stvarni==0);
    FP = sum(pred(indeksi_neg));
    TN = sum(indeksi_neg)-FP;
    konf = [TP FP; FN TN];
    
    if sum(konf(1,:))==0
        P = 0;
    else
        P = konf(1,1)/sum(konf(1,:));
    end
    if sum(konf(:,1))==0
        R = 0;
    else
        R = konf(1,1)/sum(konf(:,1));   
    end
    
    if P == 0 && R == 0
        F = 0;
    else
        F = (1+alfa^2)*P*R/( alfa^2*P+R);
    end

end