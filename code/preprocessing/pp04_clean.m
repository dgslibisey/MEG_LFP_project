function pp04_clean(P, subs)
% PP04_CLEAN  Artefaktli epoch/kanallarin gorsel olarak ayiklanmasi (INTERAKTIF).
%   Girdi: 03_epoched   Cikti: 04_clean
%   Atilan kanal/trial'lari config/subjects.tsv 'notes' sutununa da not edin.

for s = 1:numel(subs)
    sub = subs{s};
    out = stage_file(P, '04_clean', sub);
    fprintf('[pp04] %s\n', sub);
    if ~needs_run(P, out), continue; end

    cfg            = [];
    cfg.inputfile  = stage_file(P, '03_epoched', sub);
    cfg.outputfile = out;
    cfg.method     = P.artifact.method;
    ft_rejectvisual(cfg);
end
end
