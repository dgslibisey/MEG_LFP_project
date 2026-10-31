function f = stage_file(P, stage, sub)
% STAGE_FILE  Bir denegin belirli preprocessing asamasindaki dosya yolu.
%   f = stage_file(P, '02_filtered', 'sub-01')
%   stage, P.stages icindeki bir isim veya numarasi (1..N) olabilir.

if isnumeric(stage)
    stage = P.stages{stage};
end
assert(ismember(stage, P.stages), 'Bilinmeyen asama: %s', stage);
f = fullfile(P.deriv, stage, [sub '_meglfp.mat']);
end
