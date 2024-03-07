% % % Saving Features with and without Outliers for different configurations

clc;
clear variables; % Changed from 'clear all' to avoid clearing function handles
close all;

% Directories
normalDir = '../dataset/features/US_102/Normal/mcc/';
whisperDir = '../dataset/features/US_102/Whisper/mcc/';

% File lists
filelist = dir([normalDir, '*.mcc']);
filelist1 = dir([whisperDir, '*.mcc']);

% Parameters and preallocations
dim = 40;
X = [];
Y = [];

% Adjust the number of files to process
numFilesToProcess = min(length(filelist), length(filelist1));

for index = 1:numFilesToProcess

    fprintf('Processing %s\n', filelist(index).name);

    % Reading 'Normal' mcc files
    fid = fopen([normalDir, filelist(index).name], 'r');
    if fid == -1
        warning('Failed to open %s', filelist(index).name);
        continue;  % Skip to the next file
    end
    x = fread(fid, Inf, 'float');
    fclose(fid); % Close the file after reading
    if isempty(x)
        warning('No data in %s', filelist(index).name);
        continue;  % Skip to the next file
    end
    x = reshape(x, dim, length(x) / dim);

    % Reading 'Whisper' mcc files
    fid1 = fopen([whisperDir, filelist1(index).name], 'r');
    if fid1 == -1
        warning('Failed to open %s', filelist1(index).name);
        continue;  % Skip to the next file
    end
    y = fread(fid1, Inf, 'float');
    fclose(fid1); % Close the file after reading
    if isempty(y)
        warning('No data in %s', filelist1(index).name);
        continue;  % Skip to the next file
    end
    y = reshape(y, dim, length(y) / dim);

    % Dynamic Time Warping
    try
        [min_distance, d, g, path] = dtw_E(x, y);
        x = x(1:40, path(:,1));
        y = y(1:40, path(:,2));
        X = [X x];  % Accumulate the data
        Y = [Y y];  % Accumulate the data
    catch e
        warning('Error during DTW for %s: %s', filelist(index).name, e.message);
        continue;  % Skip to the next file
    end

end

% Saving the 'Normal' features
if ~isempty(X)
    Z = X;  % Ensure that we use a fresh variable
    save(['../dataset/features/US_102/Normal/', 'Z.mat'], 'Z', '-v7.3');
else
    warning('X is empty, not saving Normal Z.mat');
end

% Saving the 'Whisper' features
if ~isempty(Y)
    Z = Y;  % Ensure that we use a fresh variable
    save(['../dataset/features/US_102/Whisper/', 'Z.mat'], 'Z', '-v7.3');
else
    warning('Y is empty, not saving Whisper Z.mat');
end
