function [Spec,bpm,freq] = resprate(time,s,sf)

% function [Spec,bpm,freq] = resprate(time,s,sf)
% this function evaluates the respiration rate from the filtered (low pass, 
% 2 Hz) respiration band signal using crosscorrelation on differenced**
% signal (100 samples long... consider different criteria,
% also recommend using 10 Hz sample rate).
%
% time is sample times as a column, 
% s is signal as a single column
% sf is sample frequency
%
% Spec reports the correlation values for all windows and all rates
% bpm is the list of rates (for ploting with spectrum)
% freq is the instantaneous frequency evaluated for the signal
%	interpolated from peaks in Spec and filtered

% Reviewed Finn Upham 2014/07/06

% deduce respiration rate from half rectified difference and xcorrelations
L = length(s);
D = 100;
% comparison cycles from 5 BpM to 30 BpM, of same starting phase

bpm = [1 5:0.25:30];
bps = bpm/60;
t = (0:D-1)/sf;
V = zeros(D,length(bps));

for i = 1:length(bps)
    V(:,i) = sin(t*2*pi*bps(i));
end

sig = diff(s);

Spec = zeros(length(bps),(L-D));
Freq = zeros(1,(L-D));
cr = Freq;

S = size(Spec);
% and pick up the frames which would be of the "right" starting phase. ish
tic
for i = 1:S(2)
   sec = sig(i:i+D-1);
   %if abs(sec(1))<0.075
       r = corr(sec,V);%,'type','Spearman');
       Spec(:,i) = r';
       %max(abs(r))
       w = abs(r);
       w(r<0.5) = 0.5;
       if max(w)>0.5;
           I = localMax(w);
           cr(i) = w(I(1));
           Freq(i) = bpm(I(1));
       %if max(abs(r))>0.6
       %     [cr(i),j] = max(abs(r));
       %     Freq(i) = bpm(j);
       end
   %end
end
toc

h = (D)/2;

Freq = [zeros(1,h) Freq zeros(1,h)]';
cr = [zeros(1,h) cr zeros(1,h)]';
fs = Freq(localMax(cr));
t = [time(1);time(localMax(cr));time(end)];
size(t);
fs = [fs(1); fs; fs(end)];
size(fs);




fi = interp1(t,fs,time);

cutoff = 0.1;
order = 4;
[b,a] = butter(order, cutoff / (sf/2), 'low');

freq = filtfilt(b,a,fi);

