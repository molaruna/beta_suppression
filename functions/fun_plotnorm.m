% Plot normalized channels
% Author: maria.olaru@ucsf.edu

function [] = fun_plotnorm(cfg, data_bhn)
  figure('units','normalized','outerposition',[0 0 1 1])
  fprintf("\n\nPlotting now...\n")
  tiledlayout(4, 4)
  
  for c = 1:256 
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
         
    %Format axis tick marks
    xticks([zero_center + cfg.sampFreq * [-2:0.5:4]])
    xticklabels(round(xticks/cfg.sampFreq - cfg.pretrigger, 2));
        
    %Add labels
    xlabel('Time (s)', 'fontsize', 25)
    ylabel('analytic signal (norm)', 'fontsize', 15)
    title(sprintf("Ch: %d", c))  
       
    if (mod(c, 16) == 0) %create new png file
      suptitle(sprintf("%s | Beta filter | Hilbert Transform", cfg.subj(1)))
      fileName = sprintf(cfg.paths.study + "plots/plot1/" + ...
          "BetaFH_%s_avgzscCh1to256_pg%d", cfg.subj(1), c/16);
      print(fileName, '-dpng');
      tiledlayout(4, 4)
    end
  end
end