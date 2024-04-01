# some_bioinfo_apps
The dockerfile contains samtools-1.19.2 + htslib-1.19.1 + libdeflate-1.20, bcftools-1.19, vcftools-0.1.16, and apps for build some of them like cmake-3.29.0.
Command for building and running in interactive mode:
docker build -t some_bioinfo_apps .
docker run -it some_bioinfo_apps bash
