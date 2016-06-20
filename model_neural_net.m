%Ova skripta loada podatke u matriènom obliku koji su napravljeni pomoæu
%skripta "train_val_test.m" ili "train_val_test_elio.m" te traži najbolju
%neuronsku mrežu na temelju train i val skupa, te 
%testira model na test skupu

%Potrebno u radnom folderu imati: "elio_train.mat", "elio_test.mat","elio_val.mat"
% ili "anci_train.mat", "anci_test.mat","anci_val.mat" 
%%%%%%%%%%%%%%%%%%% LOADANJE DATASETA %%%%%%%%%%%%%%%%%%%
clear all

% load('elio_train.mat');
% load('elio_val.mat');
% load('elio_test.mat');
% id = 6;

load('anci_train.mat');
load('anci_val.mat');
load('anci_test.mat');
id = 5;

%%%%%%%%%%%%%%%%%%% TRAZENJE PARAMETARA %%%%%%%%%%%%%%%%%%%

hidden = {3,6,10,15,20,[10 10],[7 7],[7 3],[10 3],[7 7 4],[8 4 2],[10 5 3],[8 5 5], ...
    [10 7], [5 5 5], [7 5 3]};
mfcc1 = [10 15 20 25 30];

max_hidden = 0;
max_cost = Inf;
max_mfcc = 0;

for i = 1:length(hidden)
    for j = 1:length(mfcc1)

        net = fitnet(hidden{i});
        net.divideParam.trainRatio = 0.7;
        net.divideParam.valRatio = 0.3;
        net.divideParam.testRatio = 0;
        net.layers{2}.transferFcn = 'tansig';
        if length(hidden{i}) == 2
            net.layers{3}.transferFcn = 'tansig';
        elseif length(hidden{i}) == 3
            net.layers{4}.transferFcn = 'tansig';
        end

        %train
        [tr_X,tr_y,tr_granice] = make_mfcc(train_list, ...
            train_ff, train_id,mfcc1(j));
        tr_y = logical(tr_y==id);
        [net,tr] = train(net, tr_X',tr_y');

        %validacija
        [val_X, val_y, val_granice] = make_mfcc(val_list,...
                val_ff,val_id,mfcc1(j));

        prip = net(val_X');
        pctprip = pct_frame_scores(prip',val_granice);

        cost = cost_fun(pctprip,val_id == id);  
        if length(hidden{i}) == 1
            fprintf('hidden = %f, mfcc = %f\n',hidden{i},mfcc1(j));
        elseif length(hidden{i}) == 2
            fprintf('hidden = %f %f, mfcc = %f\n',hidden{i},mfcc1(j));
        else
            fprintf('hidden = %f %f %f, mfcc = %f\n',hidden{i},mfcc1(j));
        end

        fprintf('cost = %f\n', cost);

        if(cost < max_cost)
            clear max_C max_sigma max_mfcc max_cost;
            max_hidden = hidden{i};
            max_cost = cost;
            max_mfcc = mfcc1(j);
            max_net = net;
        elseif (cost == max_cost)
            max_hidden = [max_hidden,hidden{i}];
            max_cost = [max_cost, cost];
            max_mfcc = [max_mfcc,mfcc1(j)];
        end
        
    end 
end

if length(max_cost) > 1
    error('Nisu jedinstveni parametri hidden,mfcc');
end


%%%%%%%%%%%%%%%%%%% BIRANJE CUTOFFA %%%%%%%%%%%%%%%%%%%

[tr_X,tr_y,tr_granice] = make_mfcc(train_list, ...
        train_ff, train_id,max_mfcc);
[val_X, val_y, val_granice] = make_mfcc(val_list,...
        val_ff,val_id,max_mfcc);
    
% net = fitnet(max_hidden);
% net.divideParam.trainRatio = 0.7;
% net.divideParam.valRatio = 0.3;
% net.divideParam.testRatio = 0;
% net.layers{2}.transferFcn = 'tansig';
% if length(max_hidden) == 2
%     net.layers{3}.transferFcn = 'tansig';
% elseif length(max_hidden) == 3
%     net.layers{4}.transferFcn = 'tansig';
% end
% 
% tr_y = logical(tr_y==id);
% [net,tr] = train(net, tr_X',tr_y');
net = max_net;
prip = net(val_X');
pctprip = pct_frame_scores(prip',val_granice);

max_pct = 0;
max_F = 0;
osj = zeros(100,1);
spec1 = zeros(100,1);
for pct = 1:100
    rez = zeros(1,length(pctprip));
    rez(pctprip >= pct/100) = 1;
    rez(rez ~= 1) = 0;
    
    [konf,~,~,F] = analiza(rez,val_id==id,0.95);
    osj(pct) = konf(1,1)/(konf(1,1)+konf(2,1));
    spec1(pct) = 1-konf(2,2)/(konf(2,2)+konf(1,2));
    if F > max_F
        clear max_pct;
        max_pct = pct;
        max_F = F;
    elseif F == max_F
        max_pct = [max_pct,pct];
    end
end

max_pct = max_pct/100;
max_pct = mean(max_pct);

%roc krivulja
figure(1);
plot(spec1,osj)
hold on;
indmax = floor(100*max_pct);
plot(spec1(indmax),osj(indmax),'o','MarkerFaceColor','red')
title('ROC krivulja')
xlabel('FPR')
ylabel('TPR')


%%%%%%%%%%%%%%%%%%% TESTIRANJE NA FIN.PARAMETRIMA %%%%%%%%%%%%%%%%%%%
final_hidden = max_hidden;
final_cutoff = max_pct;
final_mfcc = max_mfcc;

[test_X, test_y, test_granice] = make_mfcc(test_list,...
    test_ff,test_id,final_mfcc);

prip = net(test_X');
pctprip = pct_frame_scores(prip',test_granice);
rez = zeros(1,length(pctprip));
rez(pctprip >= final_cutoff) = 1;
rez(rez ~= 1) = 0;

[M,P,R,F] = analiza(rez,test_id==id,0.5)

%elio 10,5,3, 0.215
%anci nn: 15, mfcc: 20, cut: 0.31


%%%%%%%%%%%%%%%%%%% CRTANJE %%%%%%%%%%%%%%%%%%%

%cut off
indeksi = (test_id == id);
boje = zeros(length(pctprip),1);
boje(indeksi) = 1;
figure(2)
for i = 1:length(pctprip)
    if boje(i) == 1
        col = 'red';
        p1= plot(i,pctprip(i),'o','color',col); 
    else
        col = 'black';
        p2 = plot(i,pctprip(i),'o','color',col); 
    end
    hold on;
end
y = final_cutoff*ones(100,1);
x = linspace(0,length(pctprip),100);
plot(x,y,'color','red');
legend([p1 p2],'Pozitivni','Negativni');
xlabel('Indeks')
ylabel('Score')

%Analiza rezultata - spol
muski = [2,3,6,8,12,14,15,16,17,18,19,20,50,55,56,57,58];
zenski = [1,4,5,7,9,10,11,13,51,52,53,54,59];

figure(3);
boje = zeros(length(pctprip),1);
boje(ismember(test_id,muski)) = 1;
for i = 1:length(pctprip)
    if boje(i) == 1
        col = 'blue';
        p1 = plot(i,pctprip(i),'o','color',col); 
    else
        col = 'magenta';
        p2 =  plot(i,pctprip(i),'o','color',col); 
    end
    hold on;
end
legend([p1 p2],'M','Ž');
xlabel('Indeks')
ylabel('Score')


view(net)