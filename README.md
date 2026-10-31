# MEG + LFP projesi

## Başlarken
1. Ham veriyi `data/raw/` altına koyun (veya `config/project_config.m` içindeki `P.raw` yolunu verinin bulunduğu yere çevirin).
2. `config/subjects.tsv` dosyasını doldurun: her denek için ham dosya yolları, `include` = 1.
3. `config/project_config.m` içinde kanal adlarını (`P.chan.meg`, `P.chan.lfp`) ve filtre/epoch parametrelerini ana makaleye göre ayarlayın.
4. MATLAB'da:
   ```matlab
   cd ~/Documents/MATLAB/MEG_LFP_project/code
   run_preprocessing          % tüm adımlar
   run_preprocessing(2:3)     % sadece belirli adımlar
   ```

## Akış
```
data/raw ──pp01_import──▶ 01_import ──pp02_filter──▶ 02_filtered
         ──pp03_epoch──▶ 03_epoched ──pp04_clean──▶ 04_clean ──▶ code/analyses/A0X_*
```

## Analizler: önce tek denek, sonra tüm denekler
Her analiz klasöründe (`code/analyses/_template` kopyalanır):
- `a0X_single.m`: geliştirme dosyası, `P.dev_subject` üzerinde çalışır
- `a0X_subject.m`: tek denek hesaplaması, fonksiyon olarak (single çalışınca yazılır)
- `a0X_all.m`: tüm denekler + grup analizi

Preprocessing için de önce `run_preprocessing(1:3, 'dev')` çalıştırılır, sonra tüm denekler işlenir.

Ayrıntılar için `CLAUDE.md`.
