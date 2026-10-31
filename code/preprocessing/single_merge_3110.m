%% Merge REST segments (from events.tsv) of the artifact-rejected files of one subject
% All subjects: all_merge_3110.m
% Output: P.rest_merged_dir/<sub>_REST_<MedOn|MedOff>_merged.mat + <sub>_merge_log.xlsx

clc; close all;
P = setup_paths();

%% Settings: subject = P.dev_subject (config/project_config.m)
subject_id = P.dev_subject;
bids_dir   = fullfile(P.raw, subject_id);
input_dir  = fullfile(P.artrej_dir, subject_id);
output_dir = P.rest_merged_dir;
conditions = {'MedOn', 'MedOff'};
log_file   = fullfile(output_dir, sprintf('%s_merge_log.xlsx', subject_id));

if ~isfolder(output_dir)
    mkdir(output_dir);
end
seg_log = table();   % one row per rest window
sum_log = table();   % one row per saved merged file

%% Process MedOn and MedOff
for c = 1:numel(conditions)
    condition = conditions{c};
    files = dir(fullfile(input_dir, sprintf('%s_*_acq-%s_*_artrej.mat', subject_id, condition)));
    files = files(~startsWith({files.name}, '._'));   % skip macOS metadata files

    rest_parts = {};
    label_parts = {};
    file_log = struct('file', {}, 'rest_start_sec', {}, 'rest_end_sec', {}, 'n_samples', {});

    for i = 1:numel(files)
        load(fullfile(files(i).folder, files(i).name), 'data');
        fs = data.fsample;

        % rest window: the events.tsv row with trial_type 'rest'
        ev_file = fullfile(bids_dir, '*', 'meg', strrep(files(i).name, '_meg_artrej.mat', '_events.tsv'));
        ev_file = dir(ev_file);
        events  = readtable(fullfile(ev_file(1).folder, ev_file(1).name), 'FileType', 'text', 'Delimiter', '\t');
        rest    = events(strcmpi(string(events.trial_type), 'rest'), :);
        assert(height(rest) == 1, 'Expected exactly one rest event in %s.', ev_file(1).name);
        rest_first = round(rest.onset * fs) + 1;
        rest_last  = round((rest.onset + rest.duration) * fs);

        % keep the clean pieces (trials left after artifact rejection) that fall inside the rest window
        n = 0;
        for k = 1:numel(data.trial)
            s = data.sampleinfo(k, :);
            a = max(s(1), rest_first);
            b = min(s(2), rest_last);
            if a <= b
                rest_parts{end+1}  = data.trial{k}(:, a-s(1)+1 : b-s(1)+1);
                label_parts{end+1} = data.label;
                n = n + (b - a + 1);
            end
        end
        file_log(end+1) = struct('file', files(i).name, 'rest_start_sec', rest.onset, ...
            'rest_end_sec', rest.onset + rest.duration, 'n_samples', n);
        fprintf('%s: %s -> %.3f s clean rest\n', condition, files(i).name, n / fs);
        seg_log = [seg_log; table({subject_id}, {condition}, {files(i).name}, rest.onset, ...
            rest.onset + rest.duration, rest.duration, n / fs, ...
            'VariableNames', {'subject', 'condition', 'file', 'rest_onset_s', 'rest_offset_s', ...
            'rest_duration_s', 'clean_duration_s'})];
        clear data
    end

    %% Keep channels present in all files (bad channels from channels.tsv were already removed)
    assert(~isempty(rest_parts), 'No rest segments found for %s.', condition);
    labels = label_parts{1};
    for k = 2:numel(label_parts)
        labels = intersect(labels, label_parts{k}, 'stable');
    end
    for k = 1:numel(rest_parts)
        [~, idx] = ismember(labels, label_parts{k});
        rest_parts{k} = rest_parts{k}(idx, :);
    end

    %% Save
    rest_data = cat(2, rest_parts{:});
    output_file = fullfile(output_dir, sprintf('%s_REST_%s_merged.mat', subject_id, condition));
    save(output_file, 'rest_data', 'labels', 'fs', 'file_log', 'subject_id', 'condition', '-v7.3');
    fprintf('%s: saved %d channels, %.3f seconds.\n', condition, numel(labels), size(rest_data, 2) / fs);
    sum_log = [sum_log; table({subject_id}, {condition}, numel(file_log), numel(labels), size(rest_data, 2) / fs, ...
        'VariableNames', {'subject', 'condition', 'n_rest_windows', 'n_channels', 'merged_duration_s'})];
    clear rest_data rest_parts label_parts
end

%% Excel log of durations
writetable(sum_log, log_file, 'Sheet', 'merged_files', 'WriteMode', 'overwritesheet');
writetable(seg_log, log_file, 'Sheet', 'rest_windows', 'WriteMode', 'overwritesheet');
fprintf('Log saved: %s\n', log_file);
