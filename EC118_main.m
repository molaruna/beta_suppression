% Show analytic signal for multiple trials of one subject
%
% Create vars for each block
% Author: maria.olaru@ucsf.edu

% Get repo parent directory path
fp = matlab.desktop.editor.getActiveFilename;
fp = convertCharsToStrings(fp);
fp = extractBefore(fp, "EC118");

addpath(fp + "functions/") % add path for functions

% Remove scientific notation
format longG

% Import config parameters for preprocessing
cfg = fun_cfg(fp);

% Create timing matrix for all blocks
[cfg.trials, cfg.trialsShort, ...
 cfg.trialsShortRm, cfg.minTrlLen] = fun_trialTimings(cfg);

% Processing pipeline
[cfg, data_bh] = fun_preprocessing(cfg); % Prepocessing
[cfg, data_bhn, data_bhnm] = fun_processing(cfg, data_bh); % Processing

% Plot 1: Normalized channels
fun_plotnorm(cfg, data_bhn); 
    
%Plot 2: NNMF cluster-weighted time series & variance (k=1-9)
%input parameters
pve = fun_plotNNMFclusters(cfg, data_bhnm);

%Plot 3: NNMF percent variance explained 
fun_plotNNMFvar(cfg, data_bhnm);

%Plot 4: NNMF for each electrode with k=4
fun_plotNNMFchannels(cfg, data_bhn, data_bhnm);

%Plot 5: pial surface electrodes
fun_plotNNMFpial(cfg, data_bhnm)

