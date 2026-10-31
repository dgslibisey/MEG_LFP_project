%% Merge REST segments (from events.tsv) of the artifact-rejected files of every subject
% Single subject version: single_merge_3110.m
% Output: P.rest_merged_dir/<sub>_REST_<MedOn|MedOff>_merged.mat + merge_log.xlsx

clc; close all;
P = setup_paths();

%% Settings (paths from config/project_config.m)
bids_root  = P.raw;
input_root = P.artrej_dir;
output_dir = P.rest_merged_dir;
conditions = {'MedOn', 'MedOff'};
log_file   = fullfile(output_dir, 'merge_log.xlsx');

if ~isfolder(output_dir)
    mkdir(output_dir);
end

subjects = P.subjects;   % config/subjects.tsv, include == 1
seg_log  = table();   % one row per rest window
sum_log  = table();   % one row per saved merged file

%% Process every subject
for s_i = 1:numel(subjects)
    subject_id = subjects{s_i};
    bids_dir   = fullfile(bids_root, subject_id);
    input_dir  = fullfile(input_root, subject_id);
    fprintf('\n[%d/%d] %s\n', s_i, numel(subjects), subject_id);

    %% Process MedOn and MedOff
    for c = 1:numel(conditions)
        condition = conditions{c};
        files = dir(fullfile(input_dir, sprintf('%s_*_acq-%s_*_artrej.mat', subject_id, condition)));
        files = files(~startsWith({files.name}, '._'));   % skip macOS metadata files

        rest_parts = {};
        label_parts = {};
        file_log = struct('file', {}, 'rest_start_sec', {}, 'rest_end_sec', {}, 'n_samples', {});

        for i = 1:numel(files)
            % rest windows: every events.tsv row with trial_type 'rest' (a file can have 0, 1 or more)
            ev_file = fullfile(bids_dir, '*', 'meg', strrep(files(i).name, '_meg_artrej.mat', '_events.tsv'));
            ev_file = dir(ev_file);
            events  = readtable(fullfile(ev_file(1).folder, ev_file(1).name), 'FileType', 'text', 'Delimiter', '\t');
            rest    = events(strcmpi(string(events.trial_type), 'rest'), :);
            if height(rest) == 0
                fprintf('%s: %s -> no rest event, skipped\n', condition, files(i).name);
                continue;
            end

            load(fullfile(files(i).folder, files(i).name), 'data');
            fs = data.fsample;

            for r = 1:height(rest)
                rest_first = round(rest.onset(r) * fs) + 1;
                rest_last  = round((rest.onset(r) + rest.duration(r)) * fs);

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
                file_log(end+1) = struct('file', files(i).name, 'rest_start_sec', rest.onset(r), ...
                    'rest_end_sec', rest.onset(r) + rest.duration(r), 'n_samples', n);
                fprintf('%s: %s (rest %d) -> %.3f s clean rest\n', condition, files(i).name, r, n / fs);
                seg_log = [seg_log; table({subject_id}, {condition}, {files(i).name}, rest.onset(r), ...
                    rest.onset(r) + rest.duration(r), rest.duration(r), n / fs, ...
                    'VariableNames', {'subject', 'condition', 'file', 'rest_onset_s', 'rest_offset_s', ...
                    'rest_duration_s', 'clean_duration_s'})];
            end
            clear data
        end

        %% Keep channels present in all files (bad channels from channels.tsv were already removed)
        if isempty(rest_parts)
            fprintf('%s: no rest segments found, nothing saved.\n', condition);
            continue;
        end
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

        % Excel log, rewritten after every save so nothing is lost if the run stops
        writetable(sum_log, log_file, 'Sheet', 'merged_files', 'WriteMode', 'overwritesheet');
        writetable(seg_log, log_file, 'Sheet', 'rest_windows', 'WriteMode', 'overwritesheet');
    end
end
fprintf('\nDone. Log saved: %s\n', log_file);
