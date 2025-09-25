# Using Singularity for Python!

This directory provides a short and simple example to use Singularity for python

---
**NOTE**

It is recommended you run all of the following `apptainer` commands from a compute node on Sherlock - NOT a login node!

You can get an interactive session on a compute node via...
* OnDemand
* `sh_dev`
* Or `screen`/`tmux` and `salloc`
* [See more info here](https://www.sherlock.stanford.edu/docs/user-guide/running-jobs/#interactive-jobs)

---

## Step 1: Build your container

Singularity containers are build from "recipe" files.  An example of a recipe file is simple_python.def.  A recipe file contains many different sections.  The [Singularity documentation on all sections can be found here](https://docs.sylabs.io/guides/2.6/user-guide/container_recipes.html).  For our example, these are the sections we'll use:

* Header
    * In the header, you'll define the base image you're working from, and where to find that image.
    * In this example, we're using the " " image from Docker
* %post
    * The %post section contains commands to run after the base image has been installed.
    * This is where we will install our Python packages
* %runscript
    * The %runscript section tells Singularity what to run when the image is executed
 

Let's quickly look at some important lines in our simple_python.def:
* We chose a container with `conda` already installed - so no need to install `conda`!
* A conda env is created with Python 3.11 and some packages in this line: `conda create --name myenv python=3.11 pandas numpy`
* If you need to `conda activate` in the %post section, you need to run this special command: `. /opt/conda/etc/profile.d/conda.sh`
* After conda is installed, you can `conda install` and `pip install` normally
* At the end, the following lines ensure that your env is always activated.  Be sure to change `myenv` to your env name!
    * `echo ". /opt/conda/etc/profile.d/conda.sh" >> $SINGULARITY_ENVIRONMENT`
    * `echo "conda activate myenv" >> $SINGULARITY_ENVIRONMENT`


Once you've filled out your recipe file with any packages, scripts, files, or other things you might need, then you build your image with the following command:

`apptainer build path/to/image_file.sif my_recipe.def`

This command builds the instructions from `my_recipe.def` file into an image file located at `path/to/image_file.sif`



## Step 2: Test out your image

You probably want to test your image before deploying it.  You can start a shell from within your image with the following command:

`apptainer shell path/to/image_file.sif`

From this shell, you can activate your conda env, and run some python commands to test the installation.  You'll also be able to access all of the local /oak/ and /scratch/ directories for any scripts you might need

## Step 3: Run your image

You can run your image via the following command:

`apptainer run path/to/image_file.sif`

This will run any commands you have in the %runscript section.  You can place this command in your SBATCH files to run on Sherlock!
