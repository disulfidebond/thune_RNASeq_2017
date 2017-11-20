# thune_RNASeq_2017

Analysis and methods for Thune Lab, second *Ictalurus Punctatus* RNASeq experiment

9 samples: 1,2,3,4,5,6,7,8,9, with 3 conditions/Groups: 

 * 1,2,3: WT
 * 4,5,6: delta-K
 * 7,8,9: uninfected

1) Used typical Pipeline of Cutadapt, and STAR, then forked with both CuffDiff and DESeq2

 * This was done due to time constraints and because generating figures would be simpler
 
 * This was also done because generally/vaguely following guidelines in [Conesa et al](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-0881-8)

 * Cautioned Thune via email that this analysis would only show gene count expression, not isoforms, but isoform analysis (CuffDiff) was available
 
  * Thune asked for WT vs. deltaK, WT vs. uninfected, and deltaK vs. uninfected

2) Thune also asked for gene descriptions.  This was setu using a bash script to parse and wrangle the data.  Note that this despearately needs to be cleaned up and formatted, but otherwise is a fully functioning and usable script to match gene names within an output dataset.

3) As briefly mentioned, DESeq2 was used to conduct the analysis, with default conditions and cutoffs

4) A heatmap was created using a cutoff of the top 50 statistically significantly differently expressed genes for deltaK vs. uninfected and uninfected vs. WT; there were no statistically significantly differently expressed genes for deltaK vs. WT.

5) the DESEeq2 output was sent to Thune on 11/17/2017, the output with gene descriptions and the heatmaps was sent to Thune on 11/19/2017

Notes and Comments:
 * results are late getting to Thune
 
