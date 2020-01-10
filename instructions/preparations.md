# Metagenomic Binning Teaching Module Data Preparations

This markdown describes how raw data was accessed and prepared at various stages. Contents: 

- Downloading draft genomes and metagenomic samples
- Quality filtering metagenomic reads
- Preparing individual metagenomic assemblies and single co-assembly
- Mapping metagenomic reads to assemblies for binning
- Individual and co-assembled bins for dereplication
- Final bins (module assembled or publication drafts)

Raw, staged, and polished forms of data are stored on the Figshare repository for this module. They can be downloaded in bulk for a workshop, or as needed as students go through the workshop. 

## Dependencies 
- ncbi-genome-download
- SRA Toolkit
- Prokka
- fastp
- SPAdes
- BBMap

### Downloading Draft Genomes

Genomic data for this paper is available at BioProject number [PRJNA418244](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA418244). Download the accession list which looks like: 

```
# PRJNA418244 Assembly Details
# Assembly	Level	WGS	BioSample	Isolate	Taxonomy
GCA_003862175.1	Scaffold	QOUN00000000	SAMN09651351	COR3	Coriobacteriaceae bacterium	
GCA_003862195.1	Scaffold	QOUO00000000	SAMN09651350	COR2	Coriobacteriaceae bacterium	
GCA_003862165.1	Scaffold	QOUS00000000	SAMN09651346	COR1	Coriobacteriaceae bacterium	
GCA_003862185.1	Contig	QOUT00000000	SAMN09651345	EUB1	Eubacteriaceae bacterium	
GCA_003862155.1	Contig	QOUV00000000	SAMN09651343	LCO1	Lachnospiraceae bacterium	
GCA_003862355.1	Contig	QOUU00000000	SAMN09651344	LAC1	Lactobacillus sp.	
GCA_003862265.1	Scaffold	QOUM00000000	SAMN09651352	LAC5	Lactobacillus sp.	
GCA_003862295.1	Scaffold	QOUR00000000	SAMN09651347	LAC2	Lactobacillus sp.	
GCA_003862275.1	Scaffold	QOUQ00000000	SAMN09651348	LAC3	Lactobacillus sp.	
GCA_003862285.1	Contig	QOUP00000000	SAMN09651349	LAC4	Lactobacillus sp.	
```

With `tail -n +3 PRJNA418244_AssemblyDetails.txt | cut -f1` > mcfa-accessions.txt get the list of accessions: 

```
GCA_003862175.1
GCA_003862195.1
GCA_003862165.1
GCA_003862185.1
GCA_003862155.1
GCA_003862355.1
GCA_003862265.1
GCA_003862295.1
GCA_003862275.1
GCA_003862285.1
```

Feed this to `ncbi-genome-download` with the command: 

```
ncbi-genome-download -s genbank -A mcfa-accessions.txt -F fasta all -m mcfa-mags-metadata.txt 
```

The accession file and resulting metadata file are in the `data/metadata/` folder. 

To get all downstream file formats prepped (functional annotations, genbank files for later use), run Prokka. These are all bacterial genomes, so you can use the default bacterial annotation pipeline. 

## Downloading Metagenomic Samples

The `metagenomic-SRA-sample-names.txt` file contains the sample names and corresponding SRA accessions for downloading using the SRA Toolkit: 

```
Sample_name SRA
Switchgrass_CR_Fermentation_Bioreactor_120d SRS2688102
Switchgrass_CR_Fermentation_Bioreactor_96d  SRS2688101
Switchgrass_CR_Fermentation_Bioreactor_84d  SRS2688103
Switchgrass_CR_Fermentation_Bioreactor_48d  SRS2688105
Switchgrass_CR_Fermentation_Bioreactor_12d  SRS2688104
```

Feed the SRA numbers to the SRA toolkit `downloadSRRs.sh` script usage with `./downloadSRR.sh mfca-metagenomes-srrs.txt with the list: 
```
SRX3393715
SRX3393718
SRX3393717
SRX3393720
SRX3393719
```
This will download paired-end read files of each metagenomic experiment. 

## Filtering Metagenomic Reads

