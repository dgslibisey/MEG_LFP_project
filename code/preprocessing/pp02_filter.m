function pp02_filter(P, subs)
% PP02_FILTER  Bant geciren filtre + sebeke gurultusu (DFT) filtresi.
%   Girdi: 01_import   Cikti: 02_filtered

for s = 1:numel(subs)
    sub = subs{s};
    out = stage_file(P, '02_filtered', sub);
    fprintf('[pp02] %s\n', sub);
    if ~needs_run(P, out), continue; end

    cfg            = [];
    cfg.inputfile  = stage_file(P, '01_import', sub);
    cfg.outputfile = out;
    cfg.hpfilter   = 'yes';
    cfg.hpfreq     = P.filter.hp;
    cfg.lpfilter   = 'yes';
    cfg.lpfreq     = P.filter.lp;
    cfg.dftfilter  = 'yes';
    cfg.dftfreq    = P.filter.linefreq * (1:3);
    ft_preprocessing(cfg);
end
end
