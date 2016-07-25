import redis
Host = "192.12.242.172"
Port = "6379"
Password = "CUNOC_sdr_20160722_By_Ning"

ConfigDB = "0"
XilinxDB = "1"

def OpenRedisDB(dbName):
	return redis.StrictRedis(host=Host, port=Port, db=dbName, password=Password, socket_timeout=None, connection_pool=None, charset='utf-8', errors='strict', unix_socket_path=None)

'''
	configuration is stored at Redis as a JSON string
	GetConfig/StoreConfig only deals with JSON string
'''
def GetConfig(key):
	redis_conn = OpenRedisDB(ConfigDB)
	return redis_conn.get(key)

def StoreConfig(key, config):
	redis_conn = OpenRedisDB(ConfigDB)
	redis_conn.set(key, config)

def StoreResult(key, result):
	redis_conn = OpenRedisDB(XilinxDB)
	redis_conn.set(key, result)

def GetResult(key):
	redis_conn = OpenRedisDB(XilinxDB)
	return redis_conn.get(key)
