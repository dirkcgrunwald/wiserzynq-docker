# This script starts the whole build in docker machine
# specifically
# 	it pulls the code from bitbucket
#	run the script in the code to actually do the build
#	store everything to the redis
#
# args
# 	vivado version, e.g. 2014.4, 2015.1
#	uuid to fetch the config from redis
#
import os
import argparse
import subprocess
import RedisHelper

def runBash(command):
	subprocess.Popen(command, shell=True).communicate()
def runBashOutput(command):
	return subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()


parser = argparse.ArgumentParser()
parser.add_argument("-v", "--vivado",dest="vivado", help="vivado version: supported are 2014.4, 2015.1", required = True)
parser.add_argument("-c", "--config", dest="config", help="config uuid in redis db", required = True)
parser.add_argument("-i", "--iplib", dest="iplib", help="ip block library", required = False)
args = parser.parse_args()

config_json = RedisHelper.GetConfig(args.config) 
cur_dir = os.path.dirname(os.path.realpath(__file__))
config_dest = cur_dir + "/" + "config.json"
with open(config_dest, "w") as text_file:
    text_file.write(config_json)

iplib = ""
if args.iplib is not None:
	iplib = " -i " + args.iplib

RunCmd = "\
	cd /vivado/build;\
	git clone git@bitbucket.org:cusdr/cunoc_sdr.git;\
	cd /vivado/build/cunoc_sdr;\
	cp /vivado/build/config.json /vivado/build/cunoc_sdr/;\
	python run.py gen -v " + args.vivado + " -c config.json" + iplib + ";\
	python run.py run;\
	tar -czf /vivado/build/result.tar.gz BOOT.BIN config.json.out Build_Dir/AXIS_SWITCH_IP_gen.tcl Build_Dir/VER_CTRL_REG_IP_gen.tcl Build_Dir/Base_build.tcl Build_Reports \
		system.bit fsbl.elf Zynq_Sys_Build/boot_bin/zynq.bif Zynq_Sys_Build/uboot/u-boot.elf Zynq_Sys_Build/linux_image/uImage Zynq_Sys_Build/device_tree/zynq-zed.dtb\
		Zynq_Sys_Build/boot_bin/uEnv.txt\
	"
runBash(RunCmd)
f = open('/vivado/build/result.tar.gz', 'r')
contents = ""
for line in f:
	contents += line
RedisHelper.StoreResult(args.config, contents)
