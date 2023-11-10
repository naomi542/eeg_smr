function [ C3LeftSMR, C4LeftSMR, C3RightSMR, C4RightSMR ] = ...
    mySMRCalculation( filterB, filterA, C3, C4, leftEpochStartTime, rightEpochStartTime, trialTimeIdx, baselineIdx)


% filtering the signal 
C3Filtered = filtfilt(filterB, filterA, C3);
C4Filtered = filtfilt(filterB, filterA, C4);

% extract epochs of left and right hand movements
% power of the left epoches (how to get the power?)
% 
for epochID=1:length(leftEpochStartTime)
    
    C3LeftEpoches(epochID,:) = C3Filtered(leftEpochStartTime(epochID) + trialTimeIdx);
    C4LeftEpoches(epochID,:) = C4Filtered(leftEpochStartTime(epochID) + trialTimeIdx);
end
% power of the right epoches
for epochID=1:length(rightEpochStartTime)
    
    C3RightEpoches(epochID,:) = C3Filtered(rightEpochStartTime(epochID) + trialTimeIdx);
    C4RightEpoches(epochID,:) = C4Filtered(rightEpochStartTime(epochID) + trialTimeIdx);
end


% get the ave. power of all trials
C3LeftEpochesAvePower = bandpower(C3LeftEpoches);
C4LeftEpochesAvePower = bandpower(C4LeftEpoches);

C3RightEpochesAvePower = bandpower(C3RightEpoches);
C4RightEpochesAvePower = bandpower(C4RightEpoches);

% find the power of the baseline range
C3LeftBaselinePower = bandpower(mean(C3LeftEpoches(baselineIdx),1));
C4LeftBaselinePower = bandpower(mean(C4LeftEpoches(baselineIdx),1));

C3RightBaselinePower = bandpower(mean(C3RightEpoches(baselineIdx),1));
C4RightBaselinePower = bandpower(mean(C4RightEpoches(baselineIdx),1));

% calculate the SMR of the trials (substract the baseline, then normalized
% w.r.t. the baseline. Express as a percentage
C3LeftSMR = ((C3LeftEpochesAvePower- C3LeftBaselinePower)/C3LeftBaselinePower).*100;
C4LeftSMR = ((C4LeftEpochesAvePower- C4LeftBaselinePower)/C4LeftBaselinePower).*100;

C3RightSMR = ((C3RightEpochesAvePower- C3RightBaselinePower)/C3RightBaselinePower).*100;
C4RightSMR = ((C4RightEpochesAvePower- C4RightBaselinePower)/C4RightBaselinePower).*100;

end

