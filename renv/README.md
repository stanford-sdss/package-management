# Clone your local setup using environments in R

A quickstart example to get you set up with environments in R using `renv`. This tutorial assumes that you are working in RStudio, which is available through [Sherlock On-Demand](https://ondemand.sherlock.stanford.edu/pun/sys/dashboard/batch_connect/sys/sh_rstudio/session_contexts/new).

---
## Step 1: Build an R environment on your local machine

We'll start by creating an environment that captures all R packages, along with their versions, on your local machine. This tutorial will show you how to capture every package, but you can also alter the [`snapshot`](https://rstudio.github.io/renv/reference/snapshot.html) command to capture packages only from your project. All the commands in this step are for your local machine.

First, as an optional step, create a new directory for your R project from the Terminal in R Studio.
```shell
mkdir /path/to/r-project/
```

Next move over to the Console, and we'll do the remaining steps in R, starting by changing the working directory to the new directory that you just made. We'll also double check that the working directory is the new directory.
```r
setwd("/path/to/r-project/")
getwd()
```
If you'd like to work from an existing project, do the following instead.
```r
setwd("/path/to/existing-project/")
getwd()
```

Now initialize an empty environment. We'll fill this environment with all the packages installed in your machine's home directory later.
```r
renv::init(bare = TRUE)
```

Next, activate the empty environment.
```r
renv::activate()
```

Use snapshot to initialize a `.lock` file, which will be used to capture all your packages and versions in the following steps.
```r
renv::snapshot()
```
If you are working inside an existing project, this will capture all the packages that are currently in use within the project, otherwise this triggers the following message.
```
It looks like you've called renv::snapshot() in a project that hasn't been activated yet.
How would you like to proceed? 

1: Activate the project and use the project library.
2: Do not activate the project and use the current library paths.
3: Cancel and resolve the situation another way.

Selection:
```
To continue, select 1.

Now, to capture all of the packages that are also installed in the main path on your local machine, run `snapshot` again, specifying that the packages in your library path are included.
```r
renv::snapshot(type = "all", library = .libPaths(), prompt = FALSE)
```
After running this command, R will output a list of packages and versions that will be included in the `.lock` file and the path at which your updated `.lock` file is located.

## Step 2. Copy environment files over to Oak

R package files can be quite large, and you only have 15GB of space on your Sherlock login node. For this reason, we recommend storing any R environments on Oak. If you want to use them with faster I/O on Sherlock, you can make an additional copy on $SCRATCH, but if you use this workflow, it's a good idea to make sure that you have a backup on Oak as well.

`rsync` allows you to copy files from your local to Oak. Use the following command from your local machine.
```shell
 rsync -rltP /path/to/r-project/ $SUNETID@dtn.oak.stanford.edu:/path/to/your/oak/space/for/r-project/
```

This will copy over the `.lock` file that you just created, and additional useful files like the library associated with the R environment that you created and the `.Rprofile` file associated with your new environment, which can be used to deploy this environment automatically.

## Step 3. Deploy your Environment from RStudio in Sherlock Open On-Demand

Start an [interactive RStudio session](https://ondemand.sherlock.stanford.edu/pun/sys/dashboard/batch_connect/sys/sh_rstudio/session_contexts/new) from Sherlock Open On-Demand. This will reinstall all of your R packages, with the specified versions, into your Sherlock/Oak spaces, and will take time. We recommend keeping installation time in mind when requesting runtime length for this session.

Once your session is running, navigate to the R console there on Sherlock. Set your working directory to the path on Oak where you copied over your environment file from your local machine. All of the commands in this step are for your Sherlock session.
```r
setwd("/path/to/your/oak/space/for/r-project/")
getwd()
```

Now you can restore the environment, which will install all of the R packages from your local machine in your Sherlock path, which includes `/path/to/your/oak/space/for/r-project/` since you set it inside this session.
```r
renv::restore()
```
This will output which packages will be installed, which will be updated, and will inform you of any installation errors. It is likely that your machine and Sherlock might have different versions of R and RStudio, and as a result there might be some packages or package versions that are not compatible with both.