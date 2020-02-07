#! /bin/bash

######################
# MetaBAT Binning on GLBRC
# Elizabeth McDaniel
######################

# Queue assembly files
ASSEMB=$1
NAME=$(basename $ASSEMB assembly_contigs.fasta)
MAPDIR=/home/GLBRCORG/emcdaniel/mcfaData/metagenomes/mappingResults
METABATDIR=/opt/bifxapps/metabat-2.12.1/
OUTBIN=/home/GLBRCORG/emcdaniel/mcfaData/metagenomes/binningResults

# Get depth 
$METABATDIR/jgi_summarize_bam_contig_depths --outputDepth $OUTBIN/$NAME-depth.txt $MAPDIR/$NAME*-sorted.bam

# Run metabat
$METABATDIr/metabat2 -i $ASSEMB -a $OUTBIN/$NAME-depth.txt -o $OUTBIN/$ASSEMB-MCFA-BINS/bin
