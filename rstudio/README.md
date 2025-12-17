# Create a Custom RStudio Open OnDemand App for your environment in Farmshare

A quick example to get you started in creating a custom RStudio Open OnDemand App in Farmshare. Using Farmshare allows us to wrap our RStudio launch in a container, which gives us the ability to automatically install and instantiate an existing `renv` environment upon launch. This tutorial assumes that you have an existing R environment, created as `.lock` file with the `renv` package. [This tutorial](https://github.com/stanford-sdss/package-management/tree/main/renv) will show you how to create an environment file if you don't have it yet.

---

## Step 1: Create a project directory for your R project 

We'll start by creating a project directory on your Farmshare space that will serve as the main working directory for your environment files and any files that you generate in RStudio. 

Let's make this directory using the command line
```shell
mkdir path/to/my-project/
```

You might already have an existing project directory on your local machine. You can use `rsync` or `scp` to move it over to Farmshare.
```shell
rsync -rltP /path/to/my-project/ $SUNETID@login.farmshare.stanford.edu:/path/to/my-project/
```

You can also just move your existing `.lock` file into the project directory if you prefer not to copy the whole project.
```shell
rsync -t /path/to/renv.lock $SUNETID@login.farmshare.stanford.edu:/path/to/my-project/
```

Verify that your `.lock` file exists in your Farmshare directory. It is preferable to name your environment `renv.lock`.
```shell
ls path/to/my-project/*.lock
```






Credits: Many thanks to Christina Gancayco, [@cagancayco](https://github.com/cagancayco), for providing template files for launching RStudio in Open OnDemand using a container!