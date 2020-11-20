% Configure/initialize parameters for preprocessing workflow
% Author: maria.olaru@ucsf.edu

function [cfg_out] = fun_cfg(fp)


    %Create list of all blocks for EC118 analysis
    cfg.subj          = repelem("EC118", 9);
    cfg.block         = ["B41", "B57", "B61", "B66", "B69", "B73", ...
                       "B77", "B83", "B87"];

    %master file w/ all block timings
    cfg.paths.study = fp;
    cfg.paths.timings = fp + "data/trial.times.txt"; 

    %amount of time (seconds) to start before trigger
    cfg.pretrigger     = 2;
    cfg.sil_min        = 2;

    %amount of time (seconds) for normalization window
    cfg.start_preonset = 1.75;
    cfg.stop_preonset  = 1.25;


    %Configure object appropriately for analysis
    cfg.trials          = NaN;
    
    %output cfg object
    cfg_out = cfg;
end

