function pp01_import(P, subs)
% PP01_IMPORT  Ham MEG + LFP verisini okur, tek FieldTrip yapisi olarak kaydeder.
%   Cikti: derivatives/01_import/<sub>_meglfp.mat

for s = 1:numel(subs)
    sub  = subs{s};
    info = P.subject_table(strcmp(P.subject_table.participant_id, sub), :);
    out  = stage_file(P, '01_import', sub);
    fprintf('[pp01] %s\n', sub);
    if ~needs_run(P, out), continue; end

    raw_meg = char(string(info.raw_meg));
    raw_lfp = char(string(info.raw_lfp));   % bos sutun readtable'da NaN olarak gelebilir

    if isempty(raw_lfp) || strcmp(raw_lfp, 'NaN') || strcmp(raw_lfp, raw_meg)
        % MEG ve LFP ayni dosyada (orn. LFP, MEG sisteminin EEG/MISC kanallarina kaydedilmis)
        cfg            = [];
        cfg.dataset    = fullfile(P.raw, raw_meg);
        cfg.channel    = [P.chan.meg, P.chan.lfp];
        cfg.continuous = 'yes';
        cfg.outputfile = out;
        ft_preprocessing(cfg);
    else
        % TODO: MEG ve LFP ayri dosyalarda. Senkronizasyon yontemi (ortak trigger,
        % zaman damgasi vb.) veriye bagli; netlesince burada okuyup hizalayin,
        % ortak orneklemeye getirip ft_appenddata ile birlestirin.
        error('pp01_import: ayri MEG/LFP dosyalari icin senkronizasyon henuz tanimli degil (%s).', sub);
    end
end
end
