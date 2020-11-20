% Preprocess data: read in raw HTK ECoG data, filter 
% and reshape into 3D matrix: channel x time x trial
%
% Author: maria.olaru@ucsf.edu

function[cfg, data_bh_out] = fun_preprocessing(cfg)

data_bh             = [];
for b = 1:length(cfg.block)
    
    fprintf("\nProcessing subject: " + cfg.subj(b) + ...
        " | block: " + cfg.block(b) + "\n\n");
    
    %Load new block
    cfg.paths.block(b) = cfg.paths.study + "data/" + cfg.subj(b) + ...
        "_" + cfg.block(b) + "/RawHTK";
    [data, cfg.sampFreq] = fun_readhtks(cfg.paths.block(b));
    
    %Run band-pass & hilbert 
    fprintf("\nRunning bandpass & Hilbert\n\n");
    nf = cfg.sampFreq/2;
    d = fir1(200,[13/nf 30/nf]); %band-pass filter
    data_b = filtfilt(d, 1, data); %run bandpass
    data_bh_temp = abs(hilbert(data_b));
    
    %add new block of data to data object | dims: time x ch x trl x block
    data_bh = fun_addBlockData(cfg, data_bh, data_bh_temp, b);
end

data_bh = permute(data_bh, [2, 1, 3, 4]); %dims: ch x time x trl x block

% Reshape data to concatenate blocks into trial dimension
data_bh_out = reshape(data_bh, [size(data_bh, 1), size(data_bh, 2), ...
    size(data_bh, 3) * size(data_bh, 4)]); %dims: ch x time x trl
end
