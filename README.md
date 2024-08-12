# atonsa_genome

This pipeline will run Hifiasm, optionally purge_dups, calculate summary stats, and then run BUSCO. 

run nextflow pipeline with:

```bash
nextflow run ~/tonsa_genome/scripts/hifi_v2.nf --prefix primary --run_type primary --s_option 0.1 --s_name 1 -w /gxfs_work/geomar/smomw504/tonsa_genome/new_assembly/work --purge_dups -with-tower -process.echo
```

- `--s_option` is the s value to run  
- `--s_name` is the name to assign to the output  
- `prefix` is the name to assign to the output, prefix.   
- `--run_type` is `primary` or `hi-c`  
- `--purge_dups` when included will run duplicate purging on the output.   

BUSCO will be run on all assemblies output, both purged and not. 

Note that a bunch of stuff is hard coded in there. would need to edit to make exportable. 

