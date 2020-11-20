function [FLs, W] = fun_runNMF(X, chs, spatial_weighting,Ms)
% function [FLs, W] = run_NMF(X, chs, spatial_weighting)
%
% This runs convex NMF on ECoG time series data to get a set of factor
% loadings (FLs) and weights (W) such that
%
% X ~ X*W*FLs
%
% using the distance-based weighting of spatial_dwFA.m.
%
% X is your z-scored time series [time points x channels] (note that dims
% are transposed compared to the normal dimensions!)
%
% chs is the list of channel numbers (should equal the number of columns in X)
%
% spatial_weighting = 1 or 0, for whether to force NMF clusters to be
% spatially near one another (assumes grid spacing -- make your own distance
% function if not using 256 grid electrodes)
%
% Outputs are cell arrays FLs and W, which contain the factor loadings for
% [Ms] clusters (see line 35).  FLs are the spatial indicators to view on
% the brain, XW is the cluster-weighted time series.
% 

out_file = '/Users/mattleonard/Documents/Research/data/repetition/clustering/NMF.mat';

%fprintf(1, 'Load ECoG Dat...\n');
% Load in your ECoG data here
%X = ...
%chs = ... % list of channels you'll use, corresponding to columns in X

% Calculating XX for NMF initialization (related to cross-correlation)
fprintf(1,'Calculating X''X\n');
tic;
XX = X'*X;
toc;

if ~spatial_weighting % Do not force clusters to be spatially near one another
    DM = ones(length(chs), length(chs));
end
% if ~exist(out_file, 'file')
    fprintf(1,'Calculating factor loadings (FLs)...\n');
    tic;
    
    % Number of clusters to try
    if isempty(Ms)
        Ms = [2 4 8 16 32];
    end
    
    FLs = {}; % Factor loadings (G matrix -- spatial indicators)
    W = {}; % Spatial indicators
    
    fprintf(1,'Band: ');
    for sb = 1:length(Ms)
        fprintf(1,'%d ', Ms(sb));
       
        M = Ms(sb);
        if spatial_weighting
            % Create a gaussian distance weighting function to make
            % clusters spatially close to one another
            DM = make_space_DM_ECoG256(M, chs);
        end
        if length(chs) >= M
            try
                % Initialize to varimax solution
                W0 = spatial_dwFA(X,[],M,'w',DM);
                W0 = max(W0,0); %rectify
                
                % Run convex NMF
                [W{sb}, FLs{sb}] = NMF_convex(XX, M, W0);
                
            catch
                fprintf(1,'Did not converge\n');
                FLs{sb} = [];
                W{sb} = [];
            end
        else
            fprintf(1,'\nThere are only %d channels, cannot cluster into %d levels\n', length(chs), M);
        end
        
    end
    fprintf(1,'\n');
    toc;
    
%     fprintf(1,'Saving factor loadings in %s\n', out_file);
%     save(out_file, 'FLs', 'Ms', 'DM', 'chs', 'W'); 
% else
%     load(out_file);
% end