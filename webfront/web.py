from flask import Flask
from flask import send_file
from flask import request
from flask import after_this_request
from werkzeug.utils import secure_filename
import uuid
import subprocess
import os
import sys
import threading
import time
import RedisHelper
app = Flask(__name__)
threads = []

@app.route("/")
def index():
	return """
		<!doctype html>
		<title>Building Your Xilinx Project</title>
		<h1>Welcome to Vivado Build</h1>
		<p>
		List of functions:</br>
		build----> building xilinx project</br>
		get/build_id----> get result with build_id from build function
		</p>
		"""

def RunBash(build_command):
	subprocess.Popen(build_command, shell=True).communicate()

ALLOWED_EXTENSIONS = set(['json'])

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS

@app.route("/build/", methods=['GET', 'POST'])
def build():
	if request.method == 'POST':
		file = request.files['File']
		if file and allowed_file(file.filename):
			filename = secure_filename(file.filename)
			uuid_rand = str(uuid.uuid4())
			config_json = ""
			for line in file:
				config_json += line
			RedisHelper.StoreConfig(uuid_rand, config_json)
			vivado_version = request.form['vivado_version']
			LaunchCmd = "./launch_docker.sh -v \
				" + vivado_version +" -c " + uuid_rand +" -L work.cs.colorado.edu"

			thread = threading.Thread(target = RunBash, args = (LaunchCmd,))
			thread.start()
			threads.append(thread)
			return "Building...\n"+"Request for object "+uuid_rand 
		else:
			return "please use json files"
	return """
		<!doctype html>
		<title>Building Your Xilinx Project</title>
		<h1>Building Your Xilinx Project</h1>
		<form action="" method=post enctype=multipart/form-data>
		vivado version: 
			<select name="vivado_version">
			<option value="2014.4">2014.4</option>
			<option value="2015.1">2015.1</option>
			</select><br>
		config file: 
			<input type=file name=File><br>
		<input type=submit value=Submit>
		</form>
		"""

@app.route("/get/<which_build>")
def get(which_build):
	returned_result = RedisHelper.GetResult(which_build)
	result_filename = which_build + ".tar.gz"
	if returned_result == None:
		return "Build not complete"
	with open(result_filename, 'w') as tar_file:
		tar_file.write(returned_result)
	@after_this_request
    	def cleanup(response):
		os.remove(result_filename)
		return response
	return send_file(result_filename, attachment_filename=result_filename, as_attachment = True)
	

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
