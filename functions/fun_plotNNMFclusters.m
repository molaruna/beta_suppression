%Plot 2: NNMF PLOTS - cluster-weighted time series for k = 1:9
%
% Author: maria.olaru@ucsf.edu

function [] = fun_plotNNMFclusters(cfg, data_bhnm)
  %input parameters
  data = data_bhnm(1:256, :); 
  n = 2:9;
  pve = zeros(length(n), 1); 

  figure('units','normalized','outerposition',[0 0 1 1])
  tiledlayout(3, 3)
  %Plot the cluster-weighted time series for each cluster 
  for i = 1:length(n)
    [W, W_custom] = fun_runNMF(data', 1:256, 0, n(i)); %custom NMF package

    pve(i) = NMF_percentvariance(data', W, W_custom);

    W_custom = cell2mat(W_custom);

    time_series = data' * W_custom;
    nexttile
    plot(time_series, 'LineWidth', 1.6)

    zero_center = round(cfg.pretrigger * cfg.sampFreq);

    %Enlarge font
    ax = gca;
    ax.FontSize = 25;

    xticks([zero_center + cfg.sampFreq * [-2:0.5:4]])
    xticklabels(round(xticks/cfg.sampFreq - cfg.pretrigger, 2));

    yline(0, 'Color', '#6B6B6B', 'LineWidth', 1.3); %horizontal line
    xline(cfg.pretrigger*cfg.sampFreq, 'Color', 'r' , 'LineWidth', 1.3); %vertical line
    xline(cfg.start_norm, 'Color', '#6D2A8A', 'LineWidth', 1.3); %baseline window start
    xline(cfg.stop_norm, 'Color', '#6D2A8A', 'LineWidth', 1.3); %baseline window end


    xlabel('Time (s)', 'fontsize', 20)
    ylabel('Cluster-weighted values', 'fontsize', 15)

    title(sprintf("K = %d", n(i)), 'fontsize', 20)

    suptitle("NNMF: Timeseries for Ks")
    fileName = sprintf(cfg.paths.study + "plots/plot2");
    print(fileName, '-dpng');  
  end
end