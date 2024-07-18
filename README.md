# atonsa_genome

run nextflow pipeline with:

```bash
nextflow run ~/tonsa_genome/scripts/nextflow_files/hifi_v2.nf --prefix primary --run_type primary --s_option 0.3 --s_name 3 -w /gxfs_work/geomar/smomw504/tonsa_genome/new_assembly/work --purge_dups -with-tower
```

- `--s_option` is the s value to run  
- `--s_name` is the name to assign to the output  
- `prefix` is the name to assign to the output, prefix.   
- `--run_type` is `primary` or `hi-c`  
- `--purge_dups` when included will run duplicate purging on the output.   

BUSCO will be run on all assemblies output, but purged and not. 

Note that a bunch of stuff is hard coded in there. would need to edit to make exportable. 

