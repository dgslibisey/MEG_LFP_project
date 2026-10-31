function P = setup_paths()
% SETUP_PATHS  Projeyi ve FieldTrip'i path'e ekler, proje ayarlarini dondurur.
%   Her script / analiz bununla baslar:   P = setup_paths();

proj_root = fileparts(fileparts(mfilename('fullpath')));

% Temiz path: baska FieldTrip kopyalari veya ~/Documents/MATLAB altindaki
% kopyalanmis mex dosyalari FieldTrip fonksiyonlarini golgelemesin.
restoredefaultpath;

addpath(fullfile(proj_root, 'config'));
addpath(fullfile(proj_root, 'code'));
addpath(fullfile(proj_root, 'code', 'functions'));
addpath(fullfile(proj_root, 'code', 'preprocessing'));

P = project_config(proj_root);

% --- FieldTrip (sabit surum, genpath KULLANMA) ---
if ~exist(fullfile(P.ft_dir, 'ft_defaults.m'), 'file')
    error('FieldTrip bulunamadi: %s', P.ft_dir);
end
addpath(P.ft_dir);
ft_defaults;

% Dogru FieldTrip mi kullaniliyor?
ft_used = fileparts(which('ft_preprocessing'));
if ~strcmp(ft_used, P.ft_dir)
    warning('ft_preprocessing beklenen yerden gelmiyor: %s', ft_used);
end

fprintf('Proje     : %s\n', P.root);
fprintf('FieldTrip : %s\n', P.ft_dir);
fprintf('Denek     : %d (include=1)\n', numel(P.subjects));
end
