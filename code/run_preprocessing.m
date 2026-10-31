function run_preprocessing(steps, subs)
% RUN_PREPROCESSING  Preprocessing adimlarini sirayla calistirir.
%   run_preprocessing              % tum adimlar, tum denekler
%   run_preprocessing(2:3)         % sadece filtre + epoch
%   run_preprocessing(1:4, {'sub-01'})
%   run_preprocessing(1:3, 'dev')  % sadece gelistirme denegi (P.dev_subject)
%
%   Var olan ciktilar atlanir; yeniden uretmek icin project_config'te
%   P.overwrite = true yapin veya ilgili derivatives dosyasini silin.

P = setup_paths();
if nargin < 1 || isempty(steps), steps = 1:numel(P.stages); end
if nargin < 2 || isempty(subs),  subs  = P.subjects;        end
if ischar(subs) && strcmp(subs, 'dev'), subs = {P.dev_subject}; end

pipeline = {@pp01_import, @pp02_filter, @pp03_epoch, @pp04_clean};

for k = steps
    fprintf('\n=== Adim %d: %s ===\n', k, P.stages{k});
    pipeline{k}(P, subs);
end
end
