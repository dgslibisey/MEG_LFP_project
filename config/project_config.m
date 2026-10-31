function P = project_config(proj_root)
% PROJECT_CONFIG  Projenin TEK parametre kaynagi.
%   Path'ler, denek listesi ve tum preprocessing / analiz parametreleri burada.
%   Scriptlerin icine sayi gommek yerine buraya ekleyin.
%   Ana makaleden alinan degerlerin yanina kaynagini yazin (orn. "% main paper, Methods 2.3").

%% Path'ler
P.root    = proj_root;
P.ft_dir  = '/Users/dsabur/Documents/MATLAB/fieldtrip-20240110';
P.raw     = fullfile(proj_root, 'data', 'raw');
P.deriv   = fullfile(proj_root, 'data', 'derivatives');
P.results = fullfile(proj_root, 'data', 'results');

% Preprocessing asamalari (klasor adlari = derivatives altindaki klasorler)
P.stages = {'01_import', '02_filtered', '03_epoched', '04_clean'};

% true ise var olan derivative dosyalari yeniden uretilir
P.overwrite = false;

%% Denekler (config/subjects.tsv, sadece include == 1 olanlar)
P.subject_table = readtable(fullfile(proj_root, 'config', 'subjects.tsv'), ...
    'FileType', 'text', 'Delimiter', '\t', 'TextType', 'char');
P.subject_table = P.subject_table(P.subject_table.include == 1, :);
P.subjects      = P.subject_table.participant_id';

% Yeni analizler once bu tek denekte gelistirilir (*_single.m scriptleri)
P.dev_subject = 'sub-01';   % TODO: gercek bir denek secin

%% Kanallar
% TODO: veri formatina gore doldurun (orn. MEGIN: 'MEGGRAD'/'MEGMAG', LFP: 'MISC*' veya 'EEG*')
P.chan.meg = {'MEG'};
P.chan.lfp = {};

%% Filtreleme
P.filter.hp       = 1;        % Hz   TODO: ana makale
P.filter.lp       = 100;      % Hz   TODO: ana makale
P.filter.linefreq = 50;       % Hz   Turkiye/Avrupa sebeke frekansi

%% Epoch
P.epoch.length  = 2;          % s    dinlenim verisi icin sabit uzunluklu segment
P.epoch.overlap = 0;          % 0-1

%% Artefakt
P.artifact.method = 'summary'; % ft_rejectvisual yontemi
end
