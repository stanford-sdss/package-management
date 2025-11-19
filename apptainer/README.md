# Using Singularity on Sherlock!
This directory provides a short and simple example to use Apptainer, also known as Singularity, for Python, Julia, and R.

# A step-by-step explanation using Python
We'll walk through a step-by-step process for building an Apptainer container for Python first, and then give an overview of how to build a similar container for Julia and R afterwards.

---
**NOTE**

It is recommended you run all of the following `apptainer` commands from a compute node on Sherlock - NOT a login node!

You can get an interactive session on a compute node via...
* Sherlock OnDemand [Interactive Sessions](https://ondemand.sherlock.stanford.edu/pun/sys/dashboard/batch_connect/sessions)
* Using `sh_dev` in Sherloc via [ssh](https://www.sherlock.stanford.edu/docs/getting-started/connecting/) or in an [interactive shell](https://ondemand.sherlock.stanford.edu/pun/sys/shell/ssh/localhost)
* Or using `salloc` within a `screen`/`tmux` session
* [See more info on Interactive Jobs here](https://www.sherlock.stanford.edu/docs/user-guide/running-jobs/#interactive-jobs)

---

## Step 1: Build your container

Apptainer containers are build from "recipe" files.  An example of a recipe file is `simple_python.def`, available in the Python directory here.  A recipe file contains many different sections.  The [Apptainer documentation on all sections can be found here](https://docs.sylabs.io/guides/2.6/user-guide/container_recipes.html).  For our example, these are the three sections we'll use:

1. Header
    * In the header, you'll define the base image you're working from, and where to find that image.
    * In this example, we're using the `continuumio/miniconda3` image from Docker.
2. `%post`
    * The `%post` section contains commands to run after the base image has been installed.
    * This is where we will install our Python packages.
3. `%runscript`
    * The `%runscript` section tells Apptainer what to run when the image is executed.
    * This is where we will run our Python code.


Let's quickly look at some important lines in our [`simple_python.def`](https://github.com/stanford-sdss/package-management/blob/main/apptainer/python/simple_python.def):
* We chose a container with `conda` already installed - so no need to install `conda`!
* A conda env is created with Python 3.11 and `numpy` and `pandas` are installed in line 8: `conda create --name myenv python=3.11 pandas numpy`
* If you need to `conda activate` in the `%post` section, you need to run this special command, in line 10, first: `. /opt/conda/etc/profile.d/conda.sh`
* After conda is installed and your environment is activated, you can run `conda install` and `pip install` normally to update your environment
* At the end, lines 16-17 ensure that your environment is always activated.  Be sure to change `myenv` to your environment name!
    * `echo ". /opt/conda/etc/profile.d/conda.sh" >> $SINGULARITY_ENVIRONMENT`
    * `echo "conda activate myenv" >> $SINGULARITY_ENVIRONMENT`


Once you've filled out your recipe file with any packages, scripts, files, or other things that you might need, then you build your image with the following command on the command line:

`apptainer build path/to/image_file.sif my_recipe.def`

This command builds the instructions from `my_recipe.def` file into an image file located at `path/to/image_file.sif`.


## Step 2: Test out your image

You probably want to test your image before deploying it.  You can start an Apptainer shell from within your image with the following command:

`apptainer shell path/to/image_file.sif`

From this shell, you can activate your conda environment, and run some Python commands to test the installation.  You'll also be able to access all of the local `/oak/` and `/scratch/` directories for any scripts you might need. It's a good idea to include the fully explicit paths, and not the relative paths, to any files on `/oak/` and `/scratch/`.


## Step 3: Run your image

When you're ready, you can run your image via the following command:

`apptainer run path/to/image_file.sif`

This will run any commands you have in the `%runscript` section.  You can place this command in your SBATCH files to run as a batch job on Sherlock! Here's [an example](https://github.com/stanford-sdss/package-management/blob/main/apptainer/python/simple_python.submit).