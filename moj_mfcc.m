function [ X ] = moj_mfcc(speech,fs, C, Tw, Ts)
%funkcija prima vektor zapisa govora (neobraðenog) i dijeli zapis na
%frameove te za svaki frame vraæa vektor od C koeficijenata (MFCC
%koeficijenti)

%Prima:
% speech - vektor zapisa govora (izlaz iz fje wavread)
% fs - frequency sample (izlaz iz fje wavread)
% C = 13  - broj MFCC koeficijnata koje zelimo
% Tw = 25 - Duljina jednog frame u ms
% Ts = 10 - Za koliko ms pocinje iduci frame

%Vraca:
% X - matrica gdje redak predstavlja jedan frame, a stupci MFCC koef.

switch nargin
    case 2
        C = 13;
        Tw = 25;
        Ts = 10;
    case 3
        Tw = 25;
        Ts = 10;
    case 4
        Ts = 10;
    case 5
    otherwise
        error('moj_mfcc - netoèan broj ulaznih argumenata');
end

alpha = 0.97;      % preemphasis coefficient 0.97
R = [ 300 3700 ];  % frequency range to consider 300 3700
M = 20;            % number of filterbank channels  20
L = 22;            % cepstral sine lifter parameter 22
       
% hamming window (see Eq. (5.2) on p.73 of [1])
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));

% Feature extraction (feature vectors as columns)
[ MFCCs, ~,~] = ...
            mfcc( speech, fs, Tw, Ts, alpha, hamming, R, M, C, L );

 X = MFCCs';
end

