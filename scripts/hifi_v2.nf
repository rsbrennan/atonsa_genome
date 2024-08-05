nextflow.enable.dsl=2

// Function to check for mandatory parameters
def checkAndSetParams() {
    if (!params.s_option) {
        error "Parameter 's_option' is not set. Please provide a value."
    }
    if (!params.s_name) {
        error "Parameter 's_name' is not set. Please provide a value."
    }
    if (!params.prefix) {
        error "Parameter 'prefix' is not set. Please provide a value."
    }
    if (!params.run_type || !(params.run_type in ['hi-c', 'primary'])) {
        error "Parameter 'run_type' is not set or has an invalid value. Please provide either 'hi-c' or 'primary'."
    }
}

// Call the parameter check function
checkAndSetParams()

process HIFIASM {

    cpus 25
    memory '180 GB'
    time '30h'
    queue 'base'

    publishDir "/gxfs_work/geomar/smomw504/tonsa_genome/new_assembly/${params.prefix}", mode: 'copy'

    input:
    val prefix // name input for saving - primary vs hi-c integrated
    val s_option // s value input to pass
    val s_name // name for output
    val run_type // flag to determine which pipeline to run

    output:
    path "*.r_utg.gfa", emit: raw_unitigs
    path "*.ec.bin", emit: corrected_reads
    path "*.ovlp.source.bin", emit: source_overlaps
    path "*.ovlp.reverse.bin", emit: reverse_overlaps
    path "*.bp.p_ctg.gfa", emit: processed_contigs, optional: true
    path "*.p_utg.gfa", emit: processed_unitigs, optional: true
    path "*.p_ctg.gfa", emit: primary_contigs, optional: true
    path "*.a_ctg.gfa", emit: alternate_contigs, optional: true
    path "*.p_ctg.gfa.fa", emit: primary_fasta, optional: true
    path "*.a_ctg.gfa.fa", emit: alternate_fasta, optional: true
    path "*.hap1.p_ctg.gfa", emit: paternal_contigs, optional: true
    path "*.hap2.p_ctg.gfa", emit: maternal_contigs, optional: true
    path "*.hap1.p_ctg.gfa.fa", emit: paternal_fasta, optional: true
    path "*.hap2.p_ctg.gfa.fa", emit: maternal_fasta, optional: true
    path "*.fasta_stats.primary.txt", emit: stats_primary, optional: true
    path "*.fasta_stats.alternate.txt", emit: stats_alternate, optional: true
    path "*.log", emit: log
    path "versions.yml", emit: versions

    script:
    def args = task.ext.args ?: '' // additional arguments passed to hifiasm
    def readsPath = '/gxfs_work/geomar/smomw504/tonsa_genome/pacbio_v2/*fastq.gz'
    def hicRead1Path = '/gxfs_work/geomar/smomw504/OmniC_reads/DTG-OmniC-468_R1_001.fastq.gz'
    def hicRead2Path = '/gxfs_work/geomar/smomw504/OmniC_reads/DTG-OmniC-468_R2_001.fastq.gz'

    if (run_type == 'primary') {
        """
        /gxfs_home/geomar/smomw504/bin/hifiasm/hifiasm \\
            $args \\
            --primary \\
            -s ${s_option} \\
            -o Atonsa.${prefix}.${s_name} \\
            -t 25 \\
            ${readsPath} \\
            2> ${prefix}.${s_name}.stderr.log | tee ${prefix}.${s_name}.stdout.log

        # Convert to fasta
        awk '/^S/{print ">" \$2;print \$3}' Atonsa.${prefix}.${s_name}.p_ctg.gfa > Atonsa.${prefix}.${s_name}.p_ctg.gfa.fa
        awk '/^S/{print ">" \$2;print \$3}' Atonsa.${prefix}.${s_name}.a_ctg.gfa > Atonsa.${prefix}.${s_name}.a_ctg.gfa.fa

        # Get fasta stats
        /gxfs_home/geomar/smomw504/bin/fasta_stats/bin/fasta_stats Atonsa.${prefix}.${s_name}.p_ctg.gfa.fa > Atonsa.${prefix}.${s_name}.fasta_stats.primary.txt
        /gxfs_home/geomar/smomw504/bin/fasta_stats/bin/fasta_stats Atonsa.${prefix}.${s_name}.a_ctg.gfa.fa > Atonsa.${prefix}.${s_name}.fasta_stats.alternate.txt

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            hifiasm: \$(hifiasm --version 2>&1)
        END_VERSIONS
        """
    } else if (run_type == 'hi-c') {
        if (!file(hicRead1Path).exists() || !file(hicRead2Path).exists()) {
            error "Both R1 and R2 reads are required for Hi-C pipeline."
        }
        """
        /gxfs_home/geomar/smomw504/bin/hifiasm/hifiasm \\
            $args \\
            -o Atonsa.${prefix}.${s_name} \\
            -t 25 \\
            -s ${s_option} \\
            -l3 \\
            --n-perturb 75000 \\
            --f-perturb 0.15 \\
            --h1 ${hicRead1Path} \\
            --h2 ${hicRead2Path} \\
            ${readsPath} \\
            2> ${prefix}.${s_name}.stderr.log | tee ${prefix}.${s_name}.stdout.log

        # Convert to fasta
        awk '/^S/{print ">" \$2;print \$3}' Atonsa.${prefix}.${s_name}.hic.hap1.p_ctg.gfa > Atonsa.${prefix}.${s_name}.asm.p_ctg.gfa.fa
        awk '/^S/{print ">" \$2;print \$3}' Atonsa.${prefix}.${s_name}.hic.hap2.p_ctg.gfa > Atonsa.${prefix}.${s_name}.asm.a_ctg.gfa.fa

        # Get fasta stats
        /gxfs_home/geomar/smomw504/bin/fasta_stats/bin/fasta_stats Atonsa.${prefix}.${s_name}.asm.p_ctg.gfa.fa > Atonsa.${prefix}.${s_name}.fasta_stats.primary.txt
        /gxfs_home/geomar/smomw504/bin/fasta_stats/bin/fasta_stats Atonsa.${prefix}.${s_name}.asm.a_ctg.gfa.fa > Atonsa.${prefix}.${s_name}.fasta_stats.alternate.txt

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            hifiasm: \$(hifiasm --version 2>&1)
        END_VERSIONS
        """
    }
}

process PURGE_DUPS {
    cpus 25
    memory '80 GB'
    time '26h'
    queue 'base'

    publishDir "/gxfs_work/geomar/smomw504/tonsa_genome/new_assembly/${params.prefix}", mode: 'copy'

    input:
    path primary_fasta

    output:
    path "Atonsa.${params.prefix}.${params.s_name}.purged.fasta", emit: purged_assembly
    path "dups.bed", emit: dups_bed
    path "*.log", emit: logs
    path "PB.base.cov", emit: pb_base_cov
    path "PB.stat", emit: pb_stat
    path "cutoffs", emit: cutoffs
    path "*purged.fasta_stats.txt", emit: purged_stats
	path "purge_dups_${params.prefix}.${params.s_name}.output.log", emit: full_log

    script:
    """
    {
        source ~/miniforge3/etc/profile.d/conda.sh
        conda activate assembly

        while IFS= read -r line; do
            echo "mapping \$line"
            minimap2 -map-hifi ${primary_fasta} /gxfs_work/geomar/smomw504/tonsa_genome/pacbio_v2/\$line -t 25 | gzip -c - >  \$line.paf.gz
            echo "Finished \$line"
        done < /gxfs_home/geomar/smomw504/tonsa_genome/scripts/pacbio_list.txt

        # calc stats from files above
        /gxfs_home/geomar/smomw504/bin/purge_dups/bin/pbcstat *.paf.gz
        /gxfs_home/geomar/smomw504/bin/purge_dups/bin/calcuts PB.stat > cutoffs 2>calcults.log

        echo "split and do self-self alignment"
        /gxfs_home/geomar/smomw504/bin/purge_dups/bin/split_fa ${primary_fasta} > assembly.split
        minimap2 -xasm5 -DP assembly.split assembly.split -t 25 | gzip -c - > assembly.split.self.paf.gz

        echo "Starting step2: purging dups"
        /gxfs_home/geomar/smomw504/bin/purge_dups/bin/purge_dups -2 -T cutoffs -c PB.base.cov assembly.split.self.paf.gz > dups.bed 2> purge_dups.log

        /gxfs_home/geomar/smomw504/bin/purge_dups/bin/get_seqs dups.bed ${primary_fasta}

        mv purged.fa Atonsa.${params.prefix}.${params.s_name}.purged.fasta

        # Get fasta stats
        /gxfs_home/geomar/smomw504/bin/fasta_stats/bin/fasta_stats Atonsa.${params.prefix}.${params.s_name}.purged.fasta > Atonsa.${params.prefix}.${params.s_name}.purged.fasta_stats.txt
	
	
	} > purge_dups_${params.prefix}.${params.s_name}.output.log 2>&1
	"""
}


process BUSCO {
    cpus 16
    memory '64 GB'
    time '24h'
    queue 'base'

    publishDir "/gxfs_work/geomar/smomw504/tonsa_genome/new_assembly/${params.prefix}/", mode: 'copy'

    input:
    tuple path(input_fasta), val(assembly_type)

    output:
    path "Atonsa.${params.prefix}.${params.s_name}.${assembly_type}/*", emit: busco_results

    script:
    """
    source ~/miniforge3/etc/profile.d/conda.sh
    conda activate assembly

    busco -f --offline --download_path /gxfs_work/geomar/smomw504/busco_downloads/ \
          -i ${input_fasta} -c 16 -o Atonsa.${params.prefix}.${params.s_name}.${assembly_type} \
          -m genome -l arthropoda_odb10
    """
}

workflow {
    // Create channels from the params
    prefix_ch = Channel.of(params.prefix)
    s_option_ch = Channel.of(params.s_option)
    s_name_ch = Channel.of(params.s_name)
    run_type_ch = Channel.of(params.run_type)

    // Call HIFIASM process with all required inputs
    HIFIASM(
        prefix_ch,
        s_option_ch,
        s_name_ch,
        run_type_ch
    )

    // Create a channel for BUSCO inputs
    busco_inputs = HIFIASM.out.primary_fasta.map { [it, 'primary'] }

    // Conditionally run PURGE_DUPS process
    if (params.purge_dups) {
        PURGE_DUPS(HIFIASM.out.primary_fasta)
        
        // Add purged assembly to BUSCO inputs
        purged_input = PURGE_DUPS.out.purged_assembly.map { [it, 'purged'] }
        busco_inputs = busco_inputs.mix(purged_input)
    }

    // Run BUSCO on all inputs
    BUSCO(busco_inputs)
}

