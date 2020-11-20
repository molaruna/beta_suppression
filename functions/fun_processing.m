% Process data by normalizing with mean and standard deviation during
% the baseline window (pre-speech onset portion of task)
%
% Output matrices:
% (1) Normalized trials - time x trial x channel
% (2) Normalized trials that have been averaged - channel x time
%
% Author: maria.olaru@ucsf.edu

function [cfg, data_bhn_out, data_bhnm] = fun_processing(cfg, data_bh)
% Find mean trial durations for each channel
data_bhm = squeeze(nanmean(data_bh, 3)); %dims: ch x time

%Create baseline window
cfg.start_norm = floor((cfg.pretrigger - cfg.start_preonset) * cfg.sampFreq);
cfg.stop_norm = ceil((cfg.pretrigger - cfg.stop_preonset) * cfg.sampFreq);

if(cfg.start_norm == 0)
    cfg.start_norm = 1;
end

%get mean and std for pre-onset window (all trials & channels)
mean_onset    = squeeze(nanmean(data_bhm(:, cfg.start_norm:cfg.stop_norm), 2));
std_onset     = squeeze(std(data_bhm(:, cfg.start_norm:cfg.stop_norm), ...
                        0, 2, 'omitnan'));

%normalize the dataset using baseline window measures
data_bhmn = (data_bhm - mean_onset)./std_onset;
data_bhn = (data_bh - mean_onset)./std_onset;

%Format data for plot
data_bhn_out = permute(data_bhn, [2, 3, 1]); %dims: time x trial x ch

%Take the average of all trials in the full normalized dataset
data_bhnm = nanmean(data_bhn, 3); %dims: ch x time


