FROM ubuntu:20.04
#Define timezone to enable installation apps with this requirement
RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone
#Instalation required packages for bioinformatics tools
RUN apt-get update 
RUN apt-get install -y apt-transport-https
RUN apt-get install -y build-essential
RUN apt-get install -y gcc
RUN apt-get install -y make
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y libbz2-dev
RUN apt-get install -y liblzma-dev
RUN apt-get install -y libcurl4-gnutls-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y libncurses5-dev
RUN apt-get install -y libperl-dev
RUN apt-get install -y libgsl0-dev
RUN apt-get install -y curl
RUN apt-get install -y vim
RUN apt-get install -y wget
RUN apt-get install -y autoconf
RUN apt-get install -y automake
RUN apt-get install -y perl
RUN apt-get install -y pkg-config
RUN apt-get install -y g++
RUN apt-get install -y libidn11
RUN apt-get install -y ninja-build

#Download and extract bioinformatics tools. Couldn't run one-line command with &&
#Download and extract htslib-1.19.1. Release date 22.01.2024
RUN wget https://github.com/samtools/htslib/releases/download/1.19.1/htslib-1.19.1.tar.bz2
RUN tar -xvjf htslib-1.19.1.tar.bz2
#Download and extract samtools-1.19. Release date 24.01.2024
RUN wget https://github.com/samtools/samtools/releases/download/1.19.2/samtools-1.19.2.tar.bz2
RUN tar -xvjf samtools-1.19.2.tar.bz2
#Download and extract bcftools-1.19. Release date 12.12.2023
RUN wget https://github.com/samtools/bcftools/releases/download/1.19/bcftools-1.19.tar.bz2
RUN tar -xvjf bcftools-1.19.tar.bz2
#Download and extract vcftools-0.1.16. Release date 02.08.2018
RUN wget https://github.com/vcftools/vcftools/releases/download/v0.1.16/vcftools-0.1.16.tar.gz
RUN tar -xvzf vcftools-0.1.16.tar.gz

#Create directories for apps. Couldn't create with the one line command line dir/{dir1,dir2}

RUN mkdir -p /soft/bcftools-1.19 && mkdir -p /soft/samtools-1.19.2 && mkdir -p /soft/vcftools-0.1.16 && mkdir -p /soft/htslib-1.19.1

#Install bioinformatics apps into /soft dir and modify ~/.bashr for running them
#Install htslib-1.19.1. 
RUN cd htslib-1.19.1 && ./configure --prefix=/soft/htslib-1.19.1 --exec-prefix=/soft/htslib-1.19.1 && make install && echo 'export PATH=/soft/htslib-1.19.1/bin:$PATH' >> ~/.bashrc
#Install samtools-1.19. 
RUN cd samtools-1.19.2 && ./configure --prefix=/soft/samtools-1.19.2 --exec-prefix=/soft/samtools-1.19.2 && make install && echo 'export PATH=/soft/samtools-1.19.2/bin:$PATH' >> ~/.bashrc
#Install bcftools-1.19. 
RUN cd bcftools-1.19 && ./configure --prefix=/soft/bcftools-1.19 --exec-prefix=/soft/bcftools-1.19 && make install && echo 'export PATH=/soft/bcftools-1.19/bin:$PATH' >> ~/.bashrc
#Install vcftools-0.1.16. 
RUN cd vcftools-0.1.16 && ./configure --prefix=/soft/vcftools-0.1.16 --exec-prefix=/soft/vcftools-0.1.16 && make install && echo 'export PATH=/soft/vcftools-0.1.16/bin:$PATH' >> ~/.bashrc
#Define enviromental variables
RUN echo 'export SOFT="/soft"' >> ~/.bashrc && echo 'export SAMTOOLS="/soft/samtools-1.19.2/bin/samtools"' >> ~/.bashrc && echo 'export BCFTOOLS="soft/bcftools-1.19/bin/bcftools"' >> ~/.bashrc && echo 'export VCFTOOLS="/soft/vcftools-0.1.16/bin/vcftools"' >> ~/.bashrc

#Download and install CMake-3.29.0
RUN wget "https://github.com/Kitware/CMake/releases/download/v3.29.0/cmake-3.29.0-linux-x86_64.tar.gz"
RUN tar xf cmake-3.29.0-linux-x86_64.tar.gz
#Move CMake dir to /soft
RUN mv -v cmake-3.29.0-linux-x86_64 /soft
#Add CMake to $PATH
ENV PATH="/soft/cmake-3.29.0-linux-x86_64/bin:${PATH}"

#Download and extract libdeflate-1.20
RUN wget "https://github.com/ebiggers/libdeflate/releases/download/v1.20/libdeflate-1.20.tar.gz"
RUN tar xf libdeflate-1.20.tar.gz
#Build libdeflate
RUN mv libdeflate-1.20 ./soft/ && cd soft/libdeflate-1.20/ && cmake -B build && cmake --build build
#Add dir with scripts to $PATH
RUN echo 'export PATH=/soft/libdeflate-1.20/scripts/:$PATH' >> ~/.bashrc

#Removing downloaded archives of bioinformatics apps and their dirs
RUN rm -rf htslib-1.19.1 && rm htslib-1.19.1.tar.bz2
RUN rm -rf bcftools-1.19 && rm bcftools-1.19.tar.bz2
RUN rm -rf samtools-1.19.2 && rm samtools-1.19.2.tar.bz2
RUN rm -rf vcftools-0.1.16 && rm vcftools-0.1.16.tar.gz
RUN rm cmake-3.29.0-linux-x86_64.tar.gz
RUN rm libdeflate-1.20.tar.gz
#Clear apt cashe
RUN apt-get clean
