# ora-pjmf-cml-downscale
An R starter template with an enhanced Dockerfile for McGovern using CDP for use in a ML Workspace / Project.

This file will go through the steps manually (read: no automated Docker building or pulling directly from GitHub.com) so you can customize at your own pace. If you are constantly updating your Dockerfile, you may want to consider building in some automated building.

# Information From
* https://ondemand.cloudera.com/courses/course-v1:CDP+CML+200221/
* https://docs.cloudera.com/machine-learning/cloud/runtimes/topics/ml-creating-a-customized-runtimes-image.html
    * This guide does not do the "LEGACY ENGINE" version. They both have extremely similar documentation, please make sure you are using the correct guide.
	* **NOTICE**: When copying and pasting from the [sample custom runtime image](https://docs.cloudera.com/machine-learning/cloud/runtimes/topics/ml-create-a-dockerfile-for-the-new-custom-runtimes-image.html), please note on line 8 and line 9 that the line has accidently been broken into two lines. The full command should be the following:
	    * RUN apt-get update && apt-get upgrade -y && apt-get clean && rm -rf /var/lib/apt/lists/*
* Your Cloudera Machine Learning Run-time Catalog
    * This will give you CLOUDERA's base runtime image you can DOCKER-FROM and customize.
	* Example (as of 5/12/2022 for R4.1 "Standard" Edition): ![docker.repository.cloudera.com/cloudera/cdsw/ml-runtime-workbench-r4.1-standard:2021.12.1-b17](./readme-img/base-runtime-image.png?raw=true "Finding CDP Base Runtime Image Names")
    

# Requirements and Special OS Notes
For this you need the following:
1. Basic Computer Jargon/Terms until I can simplify this README.
1. Installation of Docker on any machine.
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
    - Including: Runtime Catalog Option

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


