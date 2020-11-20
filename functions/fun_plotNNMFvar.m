%Plot 3: NNMF PLOTS - variance explained for for k = 1:9
%
% Author: maria.olaru@ucsf.edu

function [] = fun_plotNNMFvar(cfg, data_bhnm)

  %input parameters
  data = data_bhnm(1:256, :); 
  n = 2:9;
  pve = zeros(length(n), 1); 
  
  %ger variance
  for i = 1:length(n)
    [W, W_custom] = fun_runNMF(data', 1:256, 0, n(i)); %custom NMF package
    pve(i) = NMF_percentvariance(data', W, W_custom);
  end
  
  %run NMF and find percent variance explained by each K
  figure('units','normalized','outerposition',[0 0 1 1])
  plot([0; pve], 'Marker', '*', 'LineWidth', 2.0, 'MarkerSize', 15)

  ylim([0.90 1]);

  %Enlarge font
  ax = gca;
  ax.FontSize = 35;

  xlabel('K (clusters)', 'fontsize', 40)
  ylabel('Percent Variance Explained', 'fontsize', 40)

  title(sprintf("NNMF: Variance explained"))
   
  fileName = sprintf(cfg.paths.study + "plots/plot3");
  print(fileName, '-dpng');   
 
end