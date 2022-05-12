# ora-pjmf-cml-downscale
An R starter template with the (Downscale)[https://cran.r-project.org/web/packages/downscale/index.html] package already available using an enhanced Dockerfile for McGovern using CDP in a ML Workspace / Project.  

If you are constantly using the same R(install.packages) or Python(pip) items, you may want to consider just having an image that already has these items installed for you.

This file will go through the steps manually (read: no automated Docker building or pulling directly from GitHub.com) so you can customize at your own pace. If you are constantly updating your Dockerfile, you may want to consider building in some automated building.

# Information From
* https://ondemand.cloudera.com/courses/course-v1:CDP+CML+200221/
* https://docs.cloudera.com/machine-learning/cloud/runtimes/topics/ml-creating-a-customized-runtimes-image.html
    * This guide does not do the "LEGACY ENGINE" version. They both have extremely similar documentation, please make sure you are using the correct guide.
	* **NOTICE**: When copying and pasting from the [sample custom runtime image](https://docs.cloudera.com/machine-learning/cloud/runtimes/topics/ml-create-a-dockerfile-for-the-new-custom-runtimes-image.html), please note on line 8 and line 9 that the line has accidently been broken into two lines. The full command should be the following:
	    * `RUN apt-get update && apt-get upgrade -y && apt-get clean && rm -rf /var/lib/apt/lists/*`
* Your Cloudera Machine Learning Run-time Catalog
    * This will give you CLOUDERA's base runtime image you can DOCKER-FROM and customize.
	* Example Detailed Kernel and Edition Window (as of 5/12/2022 for R4.1 "Standard" Edition): ![docker.repository.cloudera.com/cloudera/cdsw/ml-runtime-workbench-r4.1-standard:2021.12.1-b17](./readme-img/base-runtime-image.png?raw=true "Finding CDP Base Runtime Image Names")
* https://docs.cloudera.com/machine-learning/cloud/runtimes/topics/ml-runtimes-packaging.html 
    * This page will contain what packages and libraries are immediately available for your usage.
    

# Requirements and Special OS Notes
For this you need the following:
1. Basic Computer Jargon/Terms until I can simplify this README.
    - "Terminal" in this readme can refer to your Unix/Linux Terminal or "Windows PowerShell" depending on your OS of choice.
1. Linux Ubuntu/Debian `apt-get` knowledge if you need to install packages that require sudo or root access. 
    - CDP uses Ubuntu as its base. You will need to know what packages you need to install in this case.
    - If on Windows and using R, I found it very useful to manually go through the process using the WSL2-Ubuntu and figure out what packages are needed and keep an open document of what I needed to install. Python may not have this annoying issue.
1. An Installation of Docker
    - (If Windows OS, see next point) Follow instructions for your operating system at https://docs.docker.com/get-docker/
	- Super Special Windows Things you should do before you start to make it go smooth(ish):
		1. Have Windows PowerShell runnable as an admin. Right click on it from the start-search menu and choose "Run as administrator"
	    1. Have WSL 2 (Windows Subsystem for Linux available). If it is unavailable, please see WSL 2 installation instructions at https://docs.microsoft.com/en-us/windows/wsl/install
		1. After running the install (and yes, this one time you actually have to reboot the machine to continue installing...), you may want to consider entering `wsl --set-default-version 2`.
		1. Consider running the instructions for Docker here: https://docs.docker.com/desktop/windows/wsl/
	- If Using WSL2-Ubuntu specifically and you are actually SSH'd into your Ubuntu Machine
	    - If you get an error: "docker: Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?."
		    - Run: `sudo service docker start`. Docker service didn't start automatically and needs to be turned on.
			- `sudo systemctl start docker` WILL NOT WORK ON WSL2-UBUNTU AT THE MOMENT:
                - System has not been booted with systemd as init system (PID 1). Can't operate.
                - Failed to connect to bus: Host is down
	- After installation, try running `docker run hello-world`. It should give you a "Hello from Docker!" message and let you know it is working correctly.
1. Access to Cloudera Machine Learning 
    - Ability to "Add Runtime" in the "Runtime Catalog" Page
	- IF YOU DO NOT SEE THIS OPTION, ARE UNABLE TO ADD A NEW RUNTIME, OR DO NOT SEE "SITE ADMINISTRATION" OPTION, CONTACT YOUR ADMINISTRATOR FOR ADDITIONAL HELP AND GUIDANCE.

# Optional
The following can be substituted out.
1. A publically visible docker repository. This Readme is using https://hub.docker.com for simplicity, so you may want to create a free account here.

# Notable Commands
## For https://hub.docker.com/
- docker run hello-world
- docker login 
    - Follow the prompts.
- docker build --network=host -t {YOUR_USER_NAME_HERE}/{YOUR_REPO_HERE}:{YOUR_TAGS} . -f Dockerfile`
    - network=host is required since this Dockerfile uses apt-get and other connections.
- docker push {YOUR_USER_NAME_HERE}/{YOUR_REPO_HERE}:{YOUR_TAGS}
    - example: docker push danfarns910/cml-training:1

# Troubleshooting/Instructions For Docker Installation 
## Windows
NYI
## OSX
NYI
## Linux (Ubuntu)
NYI

# Instructions (After Docker Installation)
## Building a New Docker - CDP Runtime Image
Begin this section after confirming that `docker run hello-world` has successfully displayed the hello message and information on your screen/terminal.  
1. Clone this repo or create a new folder that will contain your `Dockerfile`.
1. Log in to your CDP Machine Learning Workspace and open to your "Runtime Catalog".
    1. Find the closest Runtime Kernel and Edition that has the basic set of features you want. 
	1. Click on the row that has the Runtime Kernel and Edition that you want to use. This should open a side panel with more detailed information.
	1. Click the Version in the accordion list that is available (or one you specifically want to use) and it will show more detailed information about that specific version. (See Image for "Example Detailed Kernel and Edition Window" above)
	    - This will give you the "RUNTIME IMAGE" you can use as a base to start with and customize on top of.
1. Open your terminal if it is not open already.
1. CD into the directory that contains the `Dockerfile` you want to start with.
    1. If you need a sample Dockerfile or want to follow along, copy and paste the contents from this (Dockerfile)[./Dockerfile]
	1. If you want a blank Dockerfile for your own commands, copy the contents from (Base Dockerfile)[./BASE_Dockerfile]
1. Edit your Dockerfile
    1. Edit your "FROM" command (Line 4) to the "RUNTIME IMAGE" to be:
        - `FROM {RUNTIME_IMAGE}`
	    - Examples:
    	    * Python 3.9 (No GPU/No RAPIDS): `FROM docker.repository.cloudera.com/cloudera/cdsw/ml-runtime-workbench-python3.9-standard:2021.12.1-b17`
		    * R 4.1: `FROM docker.repository.cloudera.com/cloudera/cdsw/ml-runtime-workbench-r4.1-standard:2021.12.1-b17`
	1. In between "RUNTIME CUSTOM CONTENT START" and "RUNTIME CUSTOM CONTENT END" in the Dockerfile, place your commands that you would like to run.
	    - Installing R Packages Automatically (Just like you would in R):
		    - RUN Rscript -e "install.packages(c('Package_1...','Package_2',... ), dependencies = TRUE)"
			- Example: `RUN Rscript -e "install.packages('downscale', dependencies = TRUE)"`
	    - Installing Python Packages Automatically (Just like how you would using Python Normally):
		    - RUN pip install --no-cache-dir PACKAGE_NAME
			- Example: `RUN pip install --no-cache-dir sklearn`
		- For example, if you always use `dplyr` for R (and it is not installed by default as per CDP documentation), you may want to consider adding the command to install these packages so the runtime is immediately available and you aren't wasting time installing it every single time.
	    - This is also where you would install your additional packages from `apt-get` if necessary (like with the R package "downscale" requiring a few additionally installed system libraries)
	1. Consider filling out "ML_RUNTIME_EDITION" and "ML_RUNTIME_DESCRIPTION" specifically, as these values will be used on the Cloudera Runtime Catalog area.
	1. Also consider filling out the version environment variables.
1. Build your docker container:
    - For more information, see https://docs.docker.com/engine/reference/commandline/build/
	- If using hub.docker.com, follow the command below:
		- Your terminal must be in the directory your `Dockerfile` is for the command below to work.
        - `docker build --network=host -t {YOUR_USER_NAME_HERE}/{YOUR_REPO_HERE}:{YOUR_TAGS} . -f Dockerfile`
        - Example Build Command: `docker build --network=host -t danfarns910/ora-pjmf-cdp-custom-runtimes:1 . -f Dockerfile`
		- Building may take a long time. As long as it doesn't crash or freeze, let it go.
	- If you are on Windows and also have Docker Desktop installed, this should now appear under your "Images" menu. You can actually run it from here and give it a go.
1. Try your Image out
    - `docker run --name any-name-here -it {YOUR_USER_NAME_HERE}/{YOUR_REPO_HERE}:{YOUR_TAGS}`
    - Example: `docker run --name cdp-runtime-image -it danfarns910/ora-pjmf-cdp-custom-runtimes:1`
1. After you are satisfied with your image, you can remove the container safely.
    1. `docker ps -a`
	1. Find the container id you just made in the previous step and want to remove.
	1. `docker rm {CONTAINER ID}`

## Pushing to a Public Docker Repository
Please note I am using https://hub.docker.com/ and you will need to find the comparable command if using another repository.

1. Log into Docker Hub with `docker login`
	1. It will prompt you for your username and password.
1. After successfully logging in, run `docker push {YOUR_USER_NAME_HERE}/{YOUR_REPO_HERE}:{YOUR_TAGS}`.
	- Example: `docker push danfarns910/ora-pjmf-cdp-custom-runtimes:1`
1. After the image has been pushed, it should appear on your hub account.
1. Optionally run `docker logout` after you pushed successfully if you want.

## Adding your new image to the Runtime Catalog
This assumes you have already started an ML Workspace. If not, please provision one that has enough CPU and RAM.

1. Log in to your Cloudera ML Workspace. ((Offical Instructions)[https://docs.cloudera.com/machine-learning/cloud/runtimes/topics/ml-registering-customized-runtimes.html])
1. It should look similar to this: ![Runtime Catalog Interface](./readme-img/runtime-catalog-start.png?raw=true "Runtime Catalog Interface - Before Image")
1. Click "Add Runtime" in the upper right corner.
1. If you are using https://hub.docker.com/, you will only need to enter `{YOUR_USER_NAME_HERE}/{YOUR_REPO_HERE}:{YOUR_TAGS}` into the box, despite "registry" appearing to be required.
	- Example: `danfarns910/ora-pjmf-cdp-custom-runtimes:1`
1. If you are not using the hub.docker.com repository, you will most likely have to add the "registry" url portion. 
	- Remember: This Docker Repository MUST BE PUBLICALLY ACCESSIBLE.
1. You must have Cloudera Validate your link. After validation, it will look like the below image and allow you to "Add to Catalog" in the bottom right corner. ![Runtime Catalog Interface - Add To Catalog](./readme-img/runtime-catalog-add.png?raw=true "Runtime Catalog Interface - Before Image")
1. After you click "Add to Catalog", it will now appear on your list.
1. Remember or make note of where to find your new image's "Editor", "Kernel", and "Edition" as you may need it for the next part.

## Using the New Image
### New Project In ML Workspace
1. If you did the previous step correct, then when you create a new project, this runtime should be immediately available in the "Runtime Setup" section. Easy!

### Existing Project
1. Go to your Project's Project Setting Page.
1. Click on the "Runtime/Engine" Tab. It will look similar to the following image ![Project Settings - Runtime/Engine](./readme-img/existing-project-settings-rte.png?raw=true "Project Settings - Runtime/Engine")
1. Click "Add Runtime"
1. You will need to find your image using the "Editor", "Kernel", and "Edition" dropdown boxes.
1. If you find your image, your "Runtime Image" information should match what you set above when pushing to your docker repository.
1. Click "Submit" to add the runtime.
1. Now, when you start a new session, you will have access to this runtime. See image below for an example. ![New Session](./readme-img/new-session.png?raw=true "New Session")

