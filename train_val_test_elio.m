%Skripta iz baze podataka uèitava zvuène zapise te ih slae u liste,
%vektore id-jeva (za train, val i test skup). To radi za osobu B - elio.
%Sprema podatke u "elio_train.mat", "elio_test.mat","elio_val.mat"

%Elio train
%train_id = [8, 2, 3, 52, 51, 13, 57, 59, 19, 1,  6,  55,  10,  9, 15, 14, 53, 56, 16];
train_id = [2, 10, 4, 5, 54, 53, 15, 59, 50, 3,  8,  57,  12,  11,17, 16, 55, 58, 18];

[yy,ff,ids] = ucitaj('otklj',1);
yy = yy(ismember(ids,train_id));
ff = ff(ismember(ids,train_id));
train_id = sort(train_id);

[y,f,~] = ucitaj('otklj',1);
y = y(6);
f = f(6);
id = 6;

yy = [y;yy];
ff = [f;ff];
train_id = [id,train_id];

[y,f,~] = ucitaj('otklj',4);
y = y(2);
f = f(2);
id = 6;

yy = [y;yy];
ff = [f;ff];
train_id = [id,train_id];

[y,f,~] = ucitaj('otklj',18);
y = y(2);
f = f(2);
id = 6;

yy = [y;yy];
ff = [f;ff];
train_id = [id,train_id];

train_list = yy;
train_ff = ff;
train_id = train_id';

save('elio_train.mat','train_list','train_ff','train_id')

clear all

%Elio validacijski
%+3 nepoznate osobe
val_id = [2, 10, 4, 5, 54, 53, 15, 59, 50, 3,  8,  57,  12,  11,17, 16, 55, 58, 18,7,13,56];
%val_id = [8, 2, 3, 52, 51, 13, 57, 59, 19, 1,  6,  55,  10,  9, 15, 14, 53, 56, 16,7,11,54];

[yy,ff,ids] = ucitaj('otklj',2);
yy = yy(ismember(ids,val_id));
ff = ff(ismember(ids,val_id));
val_id = sort(val_id);

[y,f,~] = ucitaj('otklj',2);
y = y(6);
f = f(6);
id = 6;

yy = [y;yy];
ff = [f;ff];
val_id = [id,val_id];

ostali = [5,8,18,22,12,21];

for i = 1:length(ostali)

    [y,f,~] = ucitaj('otklj',ostali(i));
    y = y(2);
    f = f(2);
    id = 6;

    yy = [y;yy];
    ff = [f;ff];
    val_id = [id,val_id];

end


val_list = yy;
val_ff = ff;
val_id = val_id';

save('elio_val.mat','val_list','val_ff','val_id')

%elio test

[yy,ff,test_id] = ucitaj('otklj',3);

ostali = [6,7,9,10,11,13,14,15,16,17,20,23,24,25,26];

for i = 1:length(ostali)

    [y,f,~] = ucitaj('otklj',ostali(i));
    y = y(2);
    f = f(2);
    id = 6;

    yy = [y;yy];
    ff = [f;ff];
    test_id = [id;test_id];

end

test_list = yy;
test_ff = ff;
test_id = test_id;

save('elio_test.mat','test_list','test_ff','test_id')

clear all