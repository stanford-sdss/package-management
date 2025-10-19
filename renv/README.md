# Clone your local setup using environments in R

A quickstart example to get you set up with environments in R using `renv`. This tutorial assumes that you are working in RStudio, which is available through [Sherlock On-Demand](https://ondemand.sherlock.stanford.edu/pun/sys/dashboard/batch_connect/sys/sh_rstudio/session_contexts/new).

---
## Step 1: Initialize an Environment on Your Local Machine

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