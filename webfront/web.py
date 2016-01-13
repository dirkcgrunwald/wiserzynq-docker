from flask import Flask
from flask import send_file
import uuid
import subprocess
import os
import sys
import threading
import time
app = Flask(__name__)
threads = []

@app.route("/")
def index():
	return "Welcome to Vivado Build!"

def backend_build(build_command):
	subprocess.Popen(build_command, stdout=sys.stdout, stderr=sys.stderr, shell=True).communicate()

@app.route("/build")
def build():
	vivado_files = "/home/work/nigo9731/dockers/webfront/vivado-files"
	uuid_rand = str(uuid.uuid4())
	build_dir = vivado_files + "/" + uuid_rand
	try:
		os.mkdir(vivado_files)
	except OSError:
		pass
	try:
		os.mkdir(build_dir)
	except OSError:
		pass
	
	prepareMount = "\
	cp -R /home/work/nigo9731/xilinx/hdl/* " + build_dir + "/;\
	/home/work/nigo9731/dockers/vivado/run.sh " + build_dir + ";"
	thread = threading.Thread(target = backend_build, args = (prepareMount,))
	thread.start()
	threads.append(thread)
	return "get the bits file via URL /get/" + uuid_rand

@app.route("/get/<which_build>")
def get(which_build):
	vivado_files = "/home/work/nigo9731/dockers/webfront/vivado-files"
        build_dir = vivado_files + "/" + which_build
	bit_file =  build_dir + "/projects/fmcomms2/zed/fmcomms2_zed.runs/impl_1/system_top.bit"
	if os.path.isfile(bit_file) == False:
		return "Build not complete!"
	return send_file(bit_file, attachment_filename="system.bit", as_attachment = True)
	

def clean_threads():
	while True:
		deleted_threads = []
		for thread in threads:
			if thread.isAlive() == False:
				print "collect one thread"
				thread.join()
				deleted_threads.append(thread)
		# remove the deleted threads from the threadpool
		for thread in deleted_threads:
			threads.remove(thread)
		time.sleep(10)

if __name__ == "__main__":
	clean_thread = threading.Thread(target = clean_threads)
	clean_thread.setDaemon(True)
	clean_thread.start()
	app.run(host="localhost", port=5000, debug=True)
