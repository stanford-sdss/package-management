# Create a Custom RStudio OnDemand App for your environment in Farmshare

A quick example to get you started in creating a custom RStudio Open OnDemand App in Stanford's [Farmshare](https://ondemand.farmshare.stanford.edu/). This tutorial is under active development, so stay tuned for updates! Using Farmshare allows us to wrap our RStudio launch in a container, which gives us the ability to automatically install and instantiate an existing `renv` environment upon launch. This tutorial assumes that you have an existing R environment, created as `.lock` file with the `renv` package. [This tutorial](https://github.com/stanford-sdss/package-management/tree/main/renv) will show you how to create an environment file if you don't have it yet.

---

## Step 1: Create a project directory for your R project 

We'll start by creating a project directory on your Farmshare space that will serve as the main working directory for your environment files and any files that you generate in RStudio. 

Let's make this directory using the command line
```shell
mkdir ~/my_project/
```

For ease-of-use in this tutorial, we create the project directory in the home directory, but you can also specify a different path if you prefer.

You might already have an existing project directory on your local machine. You can use `rsync` or `scp` to move it over to Farmshare.
```shell
rsync -rltP /path/to/my_project/ $SUNETID@login.farmshare.stanford.edu:~/my_project/
```

You can also just move your existing `.lock` file into the project directory if you prefer not to copy the whole project.
```shell
rsync -t /path/to/renv.lock $SUNETID@login.farmshare.stanford.edu:~/my_project/
```

Verify that your `.lock` file exists in your Farmshare directory. It is preferable to name your environment `renv.lock`.
```shell
ls ~/my_project/*.lock
```


## Step 2: Create or modify an .Rprofile in your project directory

RStudio explicitly resets the working directory to a default location (usually the home directory) every time you launch a new session. Because `renv` determines the active project based on the current working directory, the working directory must be set to the project directory that contains your `.lock` file in order to ensure that the correct packages are installed and loaded automatically. 

Creating an `.Rprofile` in your project directory allows you to explicitly set your project directory as the working directory on launch. We can also use the `.Rprofile` to automatically load the R environment on launch. An example .Rprofile is located in this repo. If you have imported an existing project directory, you might already have an `.Rprofile`, which you can check by listing the hidden files, using `ls -a ~/my_project/`. If you have an existing `.Rprofile`, skip to editing the file with the editor of your choice.

We'll first create an `.Rprofile` in your project directory from Step 1.
Let's make this directory using the command line
```shell
touch ~/my_project/.Rprofile
```

You can verify that this file exists by listing the hidden files in your directory.
```shell
ls -a ~/my_project/
```

Now we'll edit the file with your editor of choice. Here we'll use `vim` since it's available as a default in Farmshare.
```shell
vim ~/my_project/.Rprofile
```

Press `i` to insert lines in `vim`, and copy in the following lines:
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
To save your work and exit `vim`, press the Esc key, then type in `:wq`, and then press the Enter key.

This code snipped explicitly sets your working directory using `setwd()` and loads your environment using `renv::load()`. If you had an existing `.Rprofile`, you still need to add these lines, and delete any previously existing lines which might introduce conflicting commands (i.e. previous code in the file that set the working directory or loaded an environment).

You might notice that we defined the project directory as `proj`, and this inherited the `PROJECT_DIR` variable from the system environment. Where did that come from? That variable is actually defined in the container files that OnDemand uses to launch RStudio, and that's what we'll work on in the final step.


## Step 3: Create a custom RStudio OnDemand app using your project directory

In your home directory on Farmshare you might have a directory named `ondemand` with a directory named `dev` inside it. If you have that directory you can create it.
```shell
mkdir ~/ondemand/dev
```

Next copy in the files contained in `ondemand/dev/` within [this repo](https://github.com/stanford-sdss/package-management/tree/main/rstudio) into your new `dev/` directory. Here's one way to do this that ensures only the necessary files are placed in `ondemand/dev` in a directory called `custom_rstudio`.
```shell
cd
git clone https://github.com/stanford-sdss/package-management.git
rsync -a ~/package-management/rstudio/ ~/ondemand/dev/custom_rstudio/
rm ~/ondemand/dev/custom_rstudio/README.md
rm -rf ~/ondemand/dev/custom_rstudio/my_project/
```

Once these files are in `~/ondemand/dev/`, navigate into the template directory within them.
```shell
cd ~/ondemand/dev/custom_rstudio/template/
```

There you should see a file named `script.sh.erb`. This file will launch the containerized custom RStudio app an it is the only file in the `~/ondemand/` tree that you will need to change. Open this file with the editor of your choice. Here, we'll once again use `vim`.
```shell
vim ~/ondemand/dev/custom_rstudio/template/script.sh.erb
```

We'll navigate to the line we need. Press the Esc key, then type in `:31`, and then press Enter. This should move your cursor to line 31 which defines the `PROJECT_DIR` variable that we used in our `.Rprofile` from Step 2. This is where you'll direct the container to use the project directory that you created in Step 1.

Once you see that your cursor is on line 31, press `i` to insert text. Replace `my_project` with the name of your project directory. Note that this assumes your project directory is located in the home directory. If it has a different path, make sure to add the full explicit path. As an example, if your project is named `r_proj`, you should edit line 31 to look like the following:
```shell
PROJECT_DIR="${HOME}/r_proj"
```
To save your work and exit `vim`, press the Esc key, then type in `:wq`, and then press the Enter key.

Finally, let's make the template executable by running `chmod` on the template directory.
```shell
chmod +x ~/ondemand/dev/custom_rstudio/template
```

Now, if you refresh [Farmshare OnDemand](https://ondemand.farmshare.stanford.edu/), you should see your custom RStudio app at the bottom of the left menu bar labeled "Sandbox." If you are unable to see this, there's a chance that you don't have developer access. Reach out to [sdss-compute@stanford.edu](mailto:sdss-compute@stanford.edu) and we'll help you get that process started. If you do see your new RStudio app, let's verify that your app is working!

Launch your RStudio app and select the resource requirements that you need. If you're just testing, then all you need are the smallest requirements. Once your RStudio app is launched, run the following command in the R console:
```R
getwd()
```
Verify that this prints out the project directory that you created in Step 1. If your project is named `r_proj`, you should see `/home/users/your-sunet/r_proj`.

Next verify that your environment loaded properly from your `.lock` file.
```R
renv::status()
```
Verify that this prints out `No issues found -- the project is in a consistent state.` This means that `renv` recognized the `.lock` file, and that no packages are missing installations or out of sync. Now you're ready to code in your custom RStudio app!

---

Credits: Many thanks to Christina Gancayco, [@cagancayco](https://github.com/cagancayco), for providing template files for launching RStudio in Open OnDemand using a container!
