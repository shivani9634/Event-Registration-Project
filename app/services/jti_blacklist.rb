class JtiBlacklist
  REDIS_KEY = "jwt:blacklist"

  def self.add(jti, exp)
    ttl = exp.to_i - Time.now.to_i
    $redis.setex("#{REDIS_KEY}:#{jti}", ttl, true)
  end

  def self.blacklisted?(jti)
    $redis.exists?("#{REDIS_KEY}:#{jti}")
  end
end
