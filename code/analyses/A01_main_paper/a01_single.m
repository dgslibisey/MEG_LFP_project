%% A01 - Ana makale - TEK DENEK (gelistirme)
% Kaynak : literature/main_paper/notes.md
% Girdi  : derivatives/04_clean
% Calisinca: hesaplamayi a01_subject.m'e tasi, a01_all.m'i yaz (bkz. ../_template).

P   = setup_paths();
sub = P.dev_subject;

%% Veriyi yukle
data = load_subject(P, sub, '04_clean');

%% Ornek: guc spektrumu (parametreleri ana makaleye gore guncelleyin)
cfg        = [];
cfg.method = 'mtmfft';
cfg.taper  = 'hanning';
cfg.foilim = [1 P.filter.lp];
cfg.output = 'pow';
freq = ft_freqanalysis(cfg, data);

%% Kontrol figurleri
figure;
semilogy(freq.freq, freq.powspctrm');
xlabel('Frekans (Hz)'); ylabel('Guc');
legend(freq.label, 'Interpreter', 'none');
title(sub, 'Interpreter', 'none');
