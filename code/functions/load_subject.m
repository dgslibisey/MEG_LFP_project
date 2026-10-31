function data = load_subject(P, sub, stage)
% LOAD_SUBJECT  Bir denegin istenen asamadaki FieldTrip verisini yukler.
%   data = load_subject(P, 'sub-01', '04_epoched')

f = stage_file(P, stage, sub);
if ~exist(f, 'file')
    error('Dosya yok: %s  (preprocessing bu asamaya kadar calisti mi?)', f);
end
tmp  = load(f);
fn   = fieldnames(tmp);
data = tmp.(fn{1});
end
