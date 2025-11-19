# HPC Workshop on Reproducible Package Management Workflows
Brought to you by the [SDSS Center for Computation](https://sdss-compute.stanford.edu) and [OpenSource@Stanford](https://opensource.stanford.edu/).
Thursday, Nov. 20th in CoDa W401 from 1-2pm

In today's workshop we are going to cover how to create reproducible package management containers that allow you to build, share, and run scientific software reliably across different HPC environments. This will provide you with a reliable framework to move your code between systems with confidence, reduce “it only works on my machine” issues when you share your code, and speed up your workflow setup on a new machine. We will be learning how to use Apptainer to containerize our package management, first in Python with `conda`, and then we'll expand this to show you how to do this in R with `renv`, and in Julia with `Pkg`.

### Today's Tutorial Agenda:
1. What is containerization and why is it useful for package management on HPC?
2. Building your first Apptainer container for Python using `conda`
3. Run a script with apptainer in shell mode
4. Run your first containerized batch job on Sherlock
5. Building an Apptainer container for R using `renv`
6. Building an Apptainer container for Julia using `Pkg`

### Do you have any questions? 
Please reach out to us on our slack channel, `#sdss-compute-users`, at [sdss-compute@stanford.edu](mailto:sdss-compute@stanford.edu), or schedule a consultation with our team [here](https://sdss-compute-consultation.stanford.edu/).

### Would you like to provide feedback on today's tutorial?
Please provide anonymous feedback [here](https://forms.gle/x3wB8qMPWBbeNosR9).

---

# How this Repository is Organized
This goal of this repository is to make package management easier on Sherlock and the variety of compute systems available to you on campus. As a result, it tends to be under active development as we develop materials to address specific researcher needs, so check back in!

1. `apptainer`: The `apptainer` directory contains all the files that we'll be focusing on in this workshop.
2. `renv`: The `renv` directory contains a workflow for managing R environments between your local machine and an HPC cluster like Sherlock.