% Plot all channels in NNMF clusters
% Author: maria.olaru@ucsf.edu

function [] = fun_plotNNMFchannels(cfg, data_bhn, data_bhnm)

  %input parameters
  data = data_bhnm(1:256, :); 
  n = 4;
  [W, W_custom] = fun_runNMF(data', 1:256, 0, n);   
  W = cell2mat(W);
  W = W';

  %Create sorted table value and electrode # for each cluster
  W_map = zeros(size(data, 1), n*2);

  for i = 1:n
      [out, indx] = sort(W(:,i));
      row_end = i*2;
      row_start = row_end-1;
      W_map(:,row_start:row_end) = [out, indx];
  end

  %pick top X percentile

  %temp_vec = reshape(W, [], 1);
  %prcntThresh = prctile(temp_vec, 90, [1]); %show all values in 90th percentile
  prcntThresh = 0.001;

  %create list of channels above percentile threshold in each cluster
  ch_cl = {};

  for i = 1:n
    ch_label = i*2;
    ch_value = ch_label-1;
    
    ch_cl{i} = W_map(find(W_map(:,ch_value) > prcntThresh), ch_label);
  end

  %Plot channels for each cluster

  figure('units','normalized','outerposition',[0 0 1 1])
  fprintf("\n\nPlotting now...\n")

  for cl_num = 1:length(ch_cl)
    ch_list = ch_cl{cl_num};
    count = 0;
    for i = 1:length(ch_list)
      c = ch_list(length(ch_list) + 1 - i);
      fprintf("\n\nChannel %d\n", c)
      nexttile %create plot filling each row column-by-column
               %Create 2D matrix: trial x time
      data_temp = squeeze(data_bhn(:, :, c))';
        
      %plot mean & SE 
      H = shadedErrorBar([], data_temp, ...
          {@nanmean, @(x) nanstd(x)/sqrt(size(data_temp, 1))}, ...
          'lineprops', '-b', 'patchSaturation',0.1);
      set(H.edge, 'Color', 'w')
      hold on

      %additional plot lines
      ylim([-15 6]);
      yline(0, 'Color', '#6B6B6B'); %horizontal line
      xline(cfg.pretrigger*cfg.sampFreq, 'Color', 'r'); %vertical line
      xline(cfg.start_norm, 'Color', '#6D2A8A'); %baseline window start
      xline(cfg.stop_norm, 'Color', '#6D2A8A'); %baseline window end
        
      zero_center = cfg.pretrigger * cfg.sampFreq;
        
      %Enlarge font
      ax = gca;
      ax.FontSize = 20;
        
      set(gcf, 'defaultaxesfontsize', 20); 
         
      %Format axis tick marks
      xticks([zero_center + cfg.sampFreq * [-2:0.5:4]])
      xticklabels(round(xticks/cfg.sampFreq - cfg.pretrigger, 2));
        
      %Add labels
      xlabel('Time (s)', 'fontsize', 15)
      ylabel('analytic signal (norm)', 'fontsize', 15)
      title(sprintf("Ch: %d", c), 'fontsize', 15)
        
       
      if (mod(i, 16) == 0 || i == length(ch_list)) %create new png file
        count = count + 1;
        suptitle(sprintf('NMF %d clusters | Cluster %d > %g', n, ...
                         cl_num, prcntThresh));
        fileName = sprintf(cfg.paths.study + "plots/plot4/" + ...
                           "BetaFH_avgzscNMF%dclst.clst%d_pg%d.png", ...
                            n, cl_num, count);
        print(fileName, '-dpng');
        tiledlayout(4, 4)
      end
    end
  end
close all
end