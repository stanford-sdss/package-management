# Using Singularity on Sherlock!
This directory provides a short and simple example to use Apptainer, also known as Singularity, for Python, Julia, and R.

# A step-by-step explanation for a Python container
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

Apptainer containers are build from "recipe" files.  An example of a recipe file is [`simple_python.def`](https://github.com/stanford-sdss/package-management/blob/main/apptainer/python/simple_python.def), available in the Python directory in this repository.  A recipe file contains many different sections.  The [Singularity documentation on all sections can be found here](https://docs.sylabs.io/guides/2.6/user-guide/container_recipes.html).  For our example, these are the three sections we'll use:

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
* We chose a container with `conda` already installed - so no need to install `conda`! This will allow us to manage our Python packages.
* A conda env is created with Python 3.11 and `numpy` and `pandas` are installed in line 8: `conda create --name myenv python=3.11 pandas numpy`.
* If you need to `conda activate` in the `%post` section, you need to run this special command, in line 10, first: `. /opt/conda/etc/profile.d/conda.sh`.
* After conda is installed and your environment is activated, you can run `conda install` and `pip install` normally to update your environment.
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

---

# A quick overview of a Julia container

We'll quickly run through how to build a similar container for Julia, using `Pkg` to manage our Julia packages. Similarly, we create a lightweight recipe file, [`simple_julia.def`](https://github.com/stanford-sdss/package-management/blob/main/apptainer/julia/simple_julia.def), available in the Julia directory in this repository.

## Step 1: Build your container

In this example, we use four sections in our container:

1. Header
    * In this example, we're using the `julia:1.10` image from Docker. Docker's Julia images are more minimal than the conda images, so we'll need to install some system level build tool in our container.
2. `%post`
    * This is where we will install system level build tools, create an organization scheme for our Julia environment/s, and install Julia packages.
3. `environment`
    * This is where we set environment variables to ensure that our Julia environment is always activated. It's just a reorganization of the workflow in [`simple_python.def`](https://github.com/stanford-sdss/package-management/blob/main/apptainer/python/simple_python.def), where we did something similar in `%post`.
4. `%runscript`
    * Run any Julia or shell scripts here!


Let's look at the important lines in [`simple_julia.def`](https://github.com/stanford-sdss/package-management/blob/main/apptainer/julia/simple_julia.def):
* In lines 5-6 we use `apt-get` to install build tools that will help us install Julia packages.
* We create a space in our container for Julia to store environments in lines 9-10. 
* We install `DataFrames` using Julia's `Pkg` in lines 13-18, ensuring that the environment is located in the space we created just above.
* In lines 22-23, we add these paths to our container environment. By specifying `export JULIA_PROJECT="/opt/julia/environments/v1.10/"` we no longer need to manually activate the environment.


## Steps 2 and 3: Testing and Running Your Image
Follow the same steps as above in the Python section to test and run your image.
