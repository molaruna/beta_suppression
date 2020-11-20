function [D,fs] = fun_readhtks(htkpath,chs,duration,keepall)
%READHTKS(htkpath) reads several htk files from a given dir
%Inputs:
%   hktpath (string)
%   chs (1xN array): list of channels, default = 1:256
%   durations (1x2 array): [Start Stop] in ms, or [] for all
%   keepall: when 1, all bands are returned instead of taking average (0,
%   default)
%
%Outputs:
%   D (nT x xChan array): ecog
%   fs: frequency in seconds
%
%Custom script authored by the Chang Lab

a = dir(fullfile(htkpath,'*.htk'));
nchan = length(a);
gridn = 64;
ngrids = ceil(nchan/gridn);


if nargin < 1
    htkpath = uigetdir;
end

if ~exist('chs','var') || isempty(chs)
    chs = 1:nchan;
end

if ~exist('duration','var')
    duration = [];
end

if ~exist('keepall','var') || isempty(keepall)
    keepall = 0;
end

[y,fs] = fun_readhtk(fullfile(htkpath,'Wav11.htk'),duration);

%malloc
if ~keepall
    D = NaN(length(y),length(chs));
else
    D = NaN(size(y,2),size(y,1),length(chs));
end
try
    textprogressbar(['reading ' num2str(nchan) ' htk files ']);% from ', htkpath]);
    taskStart = tic;
end
k = 1;
ind = 1;
done = 0;
for i = 1:ngrids
    for j=1:gridn
        if ismember(k,chs)
            if ~exist(fullfile(htkpath,['Wav',num2str(i),num2str(j),'.htk']),'file')
                done = 1;
                break
            end
            if ~keepall
                try
                    [D(:,ind)] = mean(fun_readhtk(fullfile(htkpath,['Wav',num2str(i),num2str(j),'.htk']),duration),1);
                catch
                    keyboard
                %    [D(:,ind)] = mean(fun_readhtk(fullfile(htkpath,['Wav',num2str(i),num2str(j),'.htk']),duration),2);
                end
            else %keepall = 1
                [D(:,:,ind)] = fun_readhtk(fullfile(htkpath,['Wav',num2str(i),num2str(j),'.htk']),duration)';
            end
            ind = ind + 1;
            try
                textprogressbar((ind-1)/length(chs)*100);
            catch
                fprintf([num2str(ind-1) '. '])
            end
        end
        k = k+1;
    end
    if done; break; end
end

try
    time = toc(taskStart);
    textprogressbar(['done. ',time]);
catch
    fprintf('\n');
end