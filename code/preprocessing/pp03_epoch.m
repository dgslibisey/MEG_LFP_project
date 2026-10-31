function pp03_epoch(P, subs)
% PP03_EPOCH  Surekli veriyi sabit uzunluklu segmentlere boler.
%   Girdi: 02_filtered   Cikti: 03_epoched
%   Gorev (task) verisi ise ft_definetrial ile olay-tabanli epoch'a cevirin.

for s = 1:numel(subs)
    sub = subs{s};
    out = stage_file(P, '03_epoched', sub);
    fprintf('[pp03] %s\n', sub);
    if ~needs_run(P, out), continue; end

    cfg            = [];
    cfg.inputfile  = stage_file(P, '02_filtered', sub);
    cfg.outputfile = out;
    cfg.length     = P.epoch.length;
    cfg.overlap    = P.epoch.overlap;
    ft_redefinetrial(cfg);
end
end
