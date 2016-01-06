% load demo data
load resprate_demo_data.mat

% set up filter and filter raw measurements
cutoff1 = 0.5;
sF = 100;
order = 4;
fType = 'low';
[b,a] = butter (order, cutoff1 / (sF/2), fType);

Resp_Series_1_Filt = filtfilt(b,a,Resp_Series_1_raw);
Resp_Series_2_Filt = filtfilt(b,a,Resp_Series_2_raw);

% evaluate the respiration rate these signals

step = 10; % downsample to sample frequence to sF/step, here 10 Hz

% demo sample 1
[Spec,bpm,freq] = resprate(Time(1:step:end),Resp_Series_1_Filt(1:step:end),sF/step);
figure
subplot(3,1,1)
plot(Time,Resp_Series_1_raw,'r')
hold on
plot(Time,Resp_Series_1_Filt)
axis tight
title('Respiration belt data, example 1, raw and filtered')
xlabel('Time(s)')
ylabel('Sensor values')

subplot(3,1,2)
imagesc(Time(1:step:end)',bpm,Spec)
title('Cross-correlation Spectrum')
xlabel('Time(s)')
ylabel('Beats per Minute')


subplot(3,1,3)
plot(Time(1:step:end),freq)
title(['Continuous Respiration rate estimate, with average of ' num2str(mean(freq))])
axis tight
xlabel('Time(s)')
ylabel('Beats per Minute')


% demo sample 2
[Spec,bpm,freq] = resprate(Time(1:step:end),Resp_Series_2_Filt(1:step:end),sF/step);
figure
subplot(3,1,1)
plot(Time,Resp_Series_2_raw,'r')
hold on
plot(Time,Resp_Series_2_Filt)
axis tight
title('Respiration belt data, example 2, raw and filtered')
xlabel('Time(s)')
ylabel('Sensor values')


subplot(3,1,2)
imagesc(Time(1:step:end)',bpm,Spec)
title('Cross-correlation Spectrum')
xlabel('Time(s)')
ylabel('Beats per Minute')

subplot(3,1,3)
plot(Time(1:step:end),freq)
title(['Continuous Respiration rate estimate, with average of ' num2str(mean(freq))])
axis tight
xlabel('Time(s)')
ylabel('Beats per Minute')

