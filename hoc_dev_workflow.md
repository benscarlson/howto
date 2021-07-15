# Steps to developing a script for hpc

## Local

### Interactive

#### Serial execution

Run inside rstudio

#### Parallel execution (doMC)

Run inside rstudio

### Local script

#### Serial execution

```bash
hpc_script.r -t
```

#### Parallel execution (uses doMC)

```bash
hpc_script.r -p mc -t
```

## HPC

### Interactive queue

```bash
srun --pty -p interactive -n 4 bash #request four tasks in the interactive queue

wd=~/projects/ms3/analysis/full_workflow_poc
src=~/projects/ms3/src

cd $wd

module load miniconda
source activate parallelR3
```

#### Serial execution

```bash
Rscript --vanilla $src/poc/ctmm/poc_hpc_sqlite_simple.r test3/out3.csv
```

#### Parallel execution

```bash
out=test3/out4/out.csv
logs=test3/out4/mpilogs

mpirun -n 4 R --slave -f $src/poc/ctmm/poc_hpc_sqlite_simple.r --args $out -p mpi -m $logs
```

### Scavenge queue

#### Parallel execution

Set up slurm script

```bash
#!/bin/bash

#SBATCH --mail-user=ben.s.carlson@gmail.com
#SBATCH --mem-per-cpu=5G
#SBATCH --error=%x/poc_hpc_sqlite_simple.log
#SBATCH --output=%x/poc_hpc_sqlite_simple.log

module load miniconda
source activate parallelR3

mpirun -n $n Rscript --vanilla $src/poc/ctmm/poc_hpc_sqlite_simple.r $out -p mpi -m $logs
```

Run using slurm

```bash
wd=~/projects/ms3/analysis/full_workflow_poc/test3

#need these for all scripts
export src=~/projects/ms3/src
export outp=out5
export out=$outp/out.csv
export logs=$outp/mpilogs

#slurm variables
export n=4
export t=10:00
export p=scavenge
export J=out5 #note this is used as folder name for slurm error and 
export mail=NONE

#Make sure to make the output directory or mpi will fail because mpi log files go here
cd $wd
mkdir -p $outp

# These have to start with the --option b/c echo won't print - as first character
pars=`echo --ntasks $n -p $p -t $t -J $J --mail-type $mail`
exp=`echo --export=ALL,n=$n,p=$p,t=$t,J=$J,mail=$mail`

sbatch $pars $exp $src/poc/ctmm/poc_hpc_sqlite_simple_sbatch.sh
```

### Full run in day queue
