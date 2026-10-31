function res = aXX_subject(P, sub)
% AXX_SUBJECT  Tek denek hesaplamasi. aXX_single.m'de calisan kod buraya tasinir.
%   Figur cizmez; sonucu data/results/A0X_<isim>/<sub>_<ad>.mat olarak kaydeder.

out = fullfile(P.results, 'A0X_isim');   % TODO: analiz klasor adi
if ~exist(out, 'dir'), mkdir(out); end

data = load_subject(P, sub, '04_clean');

% --- hesaplama ---
res = [];

save(fullfile(out, [sub '_res.mat']), 'res');
end
