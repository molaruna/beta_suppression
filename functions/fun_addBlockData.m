% This function organizes that data structure by including a new dimension
% with each trial and appends an additional block dimension

% Functions: 
% Uses timings with equal (shortened) trial lengths
% modifies the timing file to include pretrigger period


function newData = fun_addBlockData(config, data, data_block, b)
 
    newDataBlock = [];
    
    fprintf("\n\nCreating new trial dimension") 
    trlp_len = floor((config.minTrlLen + config.pretrigger) * config.sampFreq);
    
    for trl = 1:size(config.trialsShort, 1)
        fprintf("...%d", trl)
        trlp_start = ceil((config.trialsShort(trl, 1, b) - config.pretrigger) * config.sampFreq);
        trlp_stop = trlp_start + trlp_len;
        
        if(isnan(trlp_start) || isnan(trlp_stop))
            newDataBlock = cat(3, newDataBlock, ...
                NaN(trlp_len + 1, size(data_block, 2)));
        else
            newDataBlock = cat(3, newDataBlock, data_block(trlp_start:trlp_stop, :));
        end
    end
   fprintf("\n")
    
    %add new block to data object
    newData = cat(4, data, newDataBlock);

end