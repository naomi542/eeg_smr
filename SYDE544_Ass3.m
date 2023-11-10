clear all;
close all;
% load data
load rawEEG.mat;

% house keeping variables
% variables relating to sampling rate and experimental epoches (trials)
sampleRate = 250; % sampling rate (Hz)
epochRange = [-3,6]; % epoch range, with respect to the cue (s)
trialTimeIdx = (round(sampleRate*epochRange(1))+1):round(sampleRate*epochRange(2)); % time indics for plotting (samples)
baselineRange = [-0.9 -0.1]; % the range over which the baseline is calculated
baselineIdx = ((round(sampleRate*baselineRange(1))+1):round(baselineRange*epochRange(2)))...
    - round(epochRange(1)*sampleRate); % time indics for baseline period (samples)

% frequency and temporal filtering parameters
freqRange = [8, 26]; % the range of frequencies over which SMR is calculated
% filter parameters
filtOrder = 4; % filter order
Wn = freqRange/(sampleRate/2); % frequency range w.r.t. to Nyquist rate
[filterB,filterA] = butter(filtOrder,Wn); % temporal filter coefficients

%% Getting the starting time all movement trials
% left hand epoch starting time:
leftEpochStartTime=find(rawEEG(63,:)==1);
% right hand epoch starting time:
rightEpochStartTime=find(rawEEG(63,:)==2);

%% processing the raw EEG signals without spatial filtering
% C3 = chan# 26, c4 = chan# 30
rawC3 = rawEEG(26,:);
rawC4 = rawEEG(30,:);

% Begining of Problem 1
% calculating SMR
[ C3LeftSMR, C4LeftSMR, C3RightSMR, C4RightSMR ] = mySMRCalculation( filterB, filterA, rawC3, rawC4, leftEpochStartTime, rightEpochStartTime, trialTimeIdx, baselineIdx);
% plotting the result
figure(1);
subplot(2,2,1);
plot(trialTimeIdx/sampleRate,C3LeftSMR,'b'); % C3 left hand
hold on;
plot(baselineIdx/sampleRate + epochRange(1),C3LeftSMR(baselineIdx),'k','linewidth',2); % overlay the baseline
title('Raw C3,  Left Hand');
xlabel('Time (s)');
ylabel('Relative Power (%)');

subplot(2,2,2);
plot(trialTimeIdx/sampleRate,C4LeftSMR,'b'); % C4 left hand
hold on;
plot(baselineIdx/sampleRate + epochRange(1),C4LeftSMR(baselineIdx),'k','linewidth',2); % overlay the baseline
title('Raw C4,  Left Hand');
xlabel('Time (s)');
ylabel('Relative Power (%)');

subplot(2,2,3);
plot(trialTimeIdx/sampleRate,C3RightSMR,'r'); % C3 right hand
hold on;
plot(baselineIdx/sampleRate + epochRange(1),C3RightSMR(baselineIdx),'k','linewidth',2); % overlay the baseline
title('Raw C3,  Right Hand');
xlabel('Time (s)');
ylabel('Relative Power (%)');

subplot(2,2,4);
plot(trialTimeIdx/sampleRate,C4RightSMR,'r'); % C4 right hand
hold on;
plot(baselineIdx/sampleRate + epochRange(1),C4RightSMR(baselineIdx),'k','linewidth',2); % overlay the baseline
title('Raw C4,  Right Hand');
xlabel('Time (s)');
ylabel('Relative Power (%)');
% End of Problem 1


%% with nearest neighbor Laplacian filter (c = 9)

% Begining of Problem 2
% get the kernal of Laplacian
lLapFilter = [-1 -1 -1 -1 8 -1 -1 -1 -1];
% Laplacian filtering
lLapC3 = (lLapFilter)* rawEEG([16:18, 25:27, 34:36],:);
lLapC4 = (lLapFilter)* rawEEG([20:22, 29:31, 38:40],:);
% calculating results
[ lLapC3LeftSMR, lLapC4LeftSMR, lLapC3RightSMR, lLapC4RightSMR ] = ...
    mySMRCalculation(filterB, filterA, lLapC3, lLapC4, leftEpochStartTime, rightEpochStartTime, trialTimeIdx, baselineIdx);

% ploting the results
figure(2);
subplot(2,2,1);
plot(trialTimeIdx/sampleRate,lLapC3LeftSMR,'b'); % C3 left hand); % plot large Laplacian at C3, left hand
hold on;
plot(baselineIdx/sampleRate + epochRange(1),lLapC3LeftSMR(baselineIdx),'k','linewidth',2); % overlay the baseline
title('Large Lap. at C3, Left Hand');
xlabel('Time (s)');
ylabel('Relative Power (%)');

subplot(2,2,2);
plot(trialTimeIdx/sampleRate,lLapC4LeftSMR,'b'); % plot large Laplacian at C4, left hand
hold on;
plot(baselineIdx/sampleRate + epochRange(1),lLapC4LeftSMR(baselineIdx),'k','linewidth',2); % overlay the baseline
title('Large Lap. at C4, Left Hand');  
xlabel('Time (s)');
ylabel('Relative Power (%)');

subplot(2,2,3);
plot(trialTimeIdx/sampleRate,lLapC3RightSMR,'r'); % plot large Laplacian at C3, right hand
hold on;
plot(baselineIdx/sampleRate + epochRange(1),lLapC3RightSMR(baselineIdx),'k','linewidth',2); % overlay the baseline
title('Large Lap. at C3, Right Hand'); 
xlabel('Time (s)');
ylabel('Relative Power (%)');

subplot(2,2,4);
plot(trialTimeIdx/sampleRate,lLapC4RightSMR,'r'); % plot large Laplacian at C4, right hand
hold on;
plot(baselineIdx/sampleRate + epochRange(1),lLapC4RightSMR(baselineIdx),'k','linewidth',2); % overlay the baseline
title('Large Lap. at C4, Right Hand');
xlabel('Time (s)');
ylabel('Relative Power (%)');
% End of Problem 2

%% with Common Spatial Filter

% Begining of Problem 3
rawEEG2Use = rawEEG([16:18,25:27,34:36,20:22,29:31,38:40],:);

[ leftSMRCSPFirst, leftSMRCSPLast, rightSMRCSPFirst, rightSMRCSPLast ] = ...
    mySMRCalculationCSP( filterB, filterA, rawEEG2Use, leftEpochStartTime, rightEpochStartTime, trialTimeIdx, baselineIdx);

% plotting the result
figure(3);
subplot(2,2,1);
plot(trialTimeIdx/sampleRate,leftSMRCSPFirst,'b'); % plot the first component of CSP, left hand 
hold on;
plot(baselineIdx/sampleRate + epochRange(1),leftSMRCSPFirst(baselineIdx),'k','linewidth',2 ); % overlay the baseline
title('The first comp. CSP, Left Hand');
xlabel('Time (s)');
ylabel('Relative Power (%)');

subplot(2,2,2);
plot(trialTimeIdx/sampleRate,leftSMRCSPLast,'b'); % plot the last component of CSP, left hand
hold on;
plot(baselineIdx/sampleRate + epochRange(1),leftSMRCSPLast(baselineIdx),'k','linewidth',2); % overlay the baseline
title('The last comp. CSP, Left Hand');   
xlabel('Time (s)');
ylabel('Relative Power (%)');

subplot(2,2,3);
plot(trialTimeIdx/sampleRate,rightSMRCSPFirst,'r'); % plot the first component of CSP, right hand
hold on;
plot(baselineIdx/sampleRate + epochRange(1),rightSMRCSPFirst(baselineIdx),'k','linewidth',2 ); % overlay the baseline
title('The first comp. CSP, Right Hand'); 
xlabel('Time (s)');
ylabel('Relative Power (%)');

subplot(2,2,4);
plot(trialTimeIdx/sampleRate,rightSMRCSPLast,'r'); % plot the last component of CSP, right hand
hold on;
plot(baselineIdx/sampleRate + epochRange(1),rightSMRCSPLast(baselineIdx),'k','linewidth',2); % overlay the baseline
title('The last comp. CSP, Right Hand');  
xlabel('Time (s)');
ylabel('Relative Power (%)');

% End of Problem 3


