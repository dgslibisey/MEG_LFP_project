%% AXX - TUM DENEKLER
% aXX_single.m tek denekte calistiktan sonra kullanilir.

P = setup_paths();

%% Denek bazinda
allres = cell(1, numel(P.subjects));
for s = 1:numel(P.subjects)
    fprintf('[AXX] %s (%d/%d)\n', P.subjects{s}, s, numel(P.subjects));
    allres{s} = aXX_subject(P, P.subjects{s});
end

%% Grup duzeyi (ortalama, istatistik, figurler)

