% Create a timing matrix for all the blocks of one subject
%
% Output tables
% (1) All trial start and end times
% (2) 1 + stop times are cut to length of shortest trial duration
% (3) 2 + timing info with intertrial length shorter than preference is NaN
% Additional output: minimum trial length
%
% Note: This function removes first trial due to unknown inter-trial length
%
% Author: Maria.Olaru@ucsf.edu

function [trl, trls, trlsr, min_trl] = fun_trialTimings(config)
    timing_df = readtable(config.paths.timings);
    timing_df.Properties.VariableNames = {'subjID_epoch' 'start_sec' 'stop_sec'};
   
    %create matrix for each block
    trl_mat = [];
    min_trl = NaN;
    
    %Create 3D matrix with trial start/stop times
    for b = 1:length(config.block)
        %find index for each block
        indxOfInt = find(contains(timing_df.subjID_epoch, ...
            strcat(config.subj(b), '_', config.block(b))));
        
        new_mat = timing_df{indxOfInt, 2:3};
        
        %continue updating minimum trial length for each block
        new_min_trl = min(new_mat(:,2) - new_mat(:,1));
        if (isnan(min_trl) || new_min_trl < min_trl)
            min_trl = new_min_trl;
        end
        
        if ~isempty(trl_mat)
            
            trl_diff = abs(size(new_mat, 1) - size(trl_mat, 1));
            if size(new_mat, 1) > size(trl_mat, 1) %add addl trials to matrix
                trl_mat = cat(1, trl_mat, ...
                    NaN(trl_diff, size(trl_mat, 2), size(trl_mat, 3)));
            elseif size(new_mat, 1) < size(trl_mat, 1) %add addl trials to new block
                new_mat = cat(1, new_mat, NaN(trl_diff, size(new_mat, 2)));
            end
        end
   
        %append new trial timing info to matrix
        trl_mat = cat(3, trl_mat, new_mat);
    end
    
    %all trials
    trl = trl_mat;
    
    %shorten all trials to minimum trial length
    trls = trl;
    trls(:,2,:) = trl_mat(:,1,:) + min_trl;
    
    %find inter-trial lengths
    trl_sil = trl;
    trl_sil = trl_sil(2:length(trl_sil),1,:) - trl_sil(1:(length(trl_sil)-1),2,:);
    trl_sil = cat(1, NaN(1, size(trl_sil,2), size(trl_sil,3)), trl_sil);
    
    trl_rm = cat(2, trl_sil > 2, trl_sil > 2);
    trlsr = trls;
    trlsr(~trl_rm) = NaN; %remove trial stamps w/ too short of an inter-trial length
end
