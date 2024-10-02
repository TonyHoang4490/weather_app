module RedisHelper

  def self.get(key)
  	redis.get(key)
  end

  # expiry_in_sec: unit in second.
  def self.set(key, value, expiry_in_sec=nil)
  	redis.set(key, value)
  	redis.pexpire(key, expiry_in_sec * 1000) if expiry_in_sec.present?  # pexpire takes in expiry value in milli-second
  end

  def self.del(key)
  	redis.del(key)
  end

  private
	def self.redis
		@redis ||=  Redis.new(host: "127.0.0.1", timeout: 60, db: 1, password: nil)
	end

end