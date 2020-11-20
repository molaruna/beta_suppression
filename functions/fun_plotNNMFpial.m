% Plot spatial distribution of electrodes in each NNMF cluster
% using the subject's pial surface
%
% Author: maria.olaru@ucsf.edu

function [] = fun_plotNNMFpial(cfg, data_bhnm)

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


  %load subject data
  cfg.paths.pial = cfg.paths.study + 'data/EC118_pial/';
  load(cfg.paths.pial + 'EC118_lh_pial.mat');
  load(cfg.paths.pial + 'TDT_elecs_all.mat');

  %create color scale: 
  c_color = zeros(100, 3);

  %For blue-light blue ramp
  c_color(1:25, 1) = linspace(0, 0.06, 25);    %R: Create slight red ramp
  c_color(1:25, 2) = linspace(0, 1, 25);       %G: Create green ramp
  c_color(1:25, 3) = 1;                        %B: Maintain full blue

  %For light-blue grey ramp
  c_color(26:50, 1) = linspace(0.06, 0.8, 25); %R: increase red ramp
  c_color(26:50, 2) = linspace(1, 0.8, 25);    %G: decrease green ramp
  c_color(26:50, 3) = linspace(1, 0.8, 25);    %B: decrease blue ramp

  %For grey-yellow ramp
  c_color(51:75, 1) = linspace(0.8, 1, 25); %R: Create grey to yellow ramp
  c_color(51:75, 2) = linspace(0.8, 1, 25); %G: Create grey to yellow ramp
  c_color(51:75, 3) = linspace(0.8, 0, 25); %B: Remove grey ramp 

  %For yellow-red ramp
  c_color(76:100, 1) = 1;                   %R: Maintain full red
  c_color(76:100, 2) = linspace(1, 0, 25);  %G: Remove yellow ramp
  c_color(76:100, 3) = 0;                   %B: Maintain zero blue

  for cl_num = 1:length(ch_cl)
      ch_list = ch_cl{cl_num};
    
      %plot pial surface
      ctmr_gauss_plot(cortex, [0,0,0], 0, 'lh');
   
      scatter3(elecmatrix(1:256,1), elecmatrix(1:256,2), ...
          elecmatrix(1:256,3), 25, W(1:256, 1), 'filled');
    
      colormap(c_color);
      colorbar;
      max_val = max(W(:, cl_num));
      caxis([-1 * max_val max_val])

      title(sprintf('NMF %d clusters | Cluster %d > %g', n, cl_num, ...
                    prcntThresh), 'fontsize', 20);
      fileName = sprintf(cfg.paths.study + "plots/plot5/" + ... 
          "NMFpialSurface%dclst.clst%d.png", n, cl_num);
      print(fileName, '-dpng');
      close all
end
end