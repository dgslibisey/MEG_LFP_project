function tf = needs_run(P, outfile)
% NEEDS_RUN  Cikti dosyasi yoksa veya P.overwrite acik ise true.

tf = P.overwrite || ~exist(outfile, 'file');
if ~tf
    fprintf('  atlandi (zaten var): %s\n', outfile);
end
end
