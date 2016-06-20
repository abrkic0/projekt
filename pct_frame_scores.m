function out = pct_frame_scores(score, granice)
%Za vektor rezultata klasificiranja frameova vraca postotak pozitivnih za
%svaki zapis, granice frameova odreðene su pomoæu granice

stup = size(score,2);
red = size(granice,2);

out = zeros(red,stup);

for i = 1:red
    out(i,:) = sum(score(granice(1,i):granice(2,i),:)) ...
        / (granice(2,i)-granice(1,i)+1);
end;

end


