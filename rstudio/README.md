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


## Step 2: Create or modify an .Rprofile in your project directory

RStudio explicitly resets the working directory to a default location (usually the home directory) every time you launch a new session. Because `renv` determines the active project based on the current working directory, the working directory must be set to the project directory that contains your `.lock` file in order to ensure that the correct packages are installed and loaded automatically. 

Creating an `.Rprofile` in your project directory allows you to explicitly set your project directory as the working directory on launch. We can also use the `.Rprofile` to automatically load the R environment on launch. An example .Rprofile is located in this repo. If you have imported an existing project directory, you might already have an `.Rprofile`, which you can check by listing the hidden files, using `ls -a path/to/my-project/`. If you have an existing `.Rprofile`, skip to editing the file with the editor of your choice.

We'll first create an `.Rprofile` in your project directory.
Let's make this directory using the command line
```shell
touch path/to/my-project/.Rprofile
```

You can verify that this file exists by listing the hidden files in your directory.
```shell
ls -a path/to/my-project/
```

Now we'll edit the file with your editor of choice. Here we'll use `vim` since it's available as a default in Farmshare.
```shell
vim path/to/my-project/
```

Press `i` to insert lines in `vim`, and copy in the following lines.:
```R
source("renv/activate.R")
proj <- Sys.getenv("PROJECT_DIR")
if (nzchar(proj) && dir.exists(proj)) {
  setwd(proj)
}

if (requireNamespace("renv", quietly = TRUE)) {
  renv::load()
}
```
To save your work and exit `vim`, press the Esc key, then type `:wq`, and then press the Enter key.

This code snipped explicitly sets your working directory using `setwd()` and loads your environment using `renv::load()`. If you had an existing `.Rprofile`, you still need to add these lines, and delete any previously existing lines which might introduce conflicting commands (i.e. previous code in the file that set the working directory or loaded an environment).

You might notice that we defined the project directory as `proj`, and this inherited the `PROJECT_DIR` variable from the system environment. Where did that come from? That variable is actually defined in the container files that Open OnDemand uses to launch RStudio, and that's what we'll work on in the final step.





Credits: Many thanks to Christina Gancayco, [@cagancayco](https://github.com/cagancayco), for providing template files for launching RStudio in Open OnDemand using a container!