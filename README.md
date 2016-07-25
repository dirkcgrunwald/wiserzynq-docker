# wiserzynq-docker
Docker containers for an SDR platform project

Directory
vivado-build
	build a docker image that supports viavdo software 
webfront
	python flask based web service within ngnix web server


Instructions:
	1. Create vivado docker images
		follow the instructions in vivado-build
		push to the docker registry
	2. Launch Web Service
		follow the instructions in webfront
		run webfront/run.sh
