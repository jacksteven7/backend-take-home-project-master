class User < ApplicationRecord
  validates :email,    uniqueness: true
  validates :phone_number, uniqueness: true
  

  before_save :encrypt_password, :gen_key
  

  def encrypt_password
    self.password = crypt.encrypt_and_sign('my confidental data')
  end

  def gen_key
    self.key = SecureRandom.hex(32)
  end

  def crypt
    key = SecureRandom.random_bytes(32)
    @crypt ||= ActiveSupport::MessageEncryptor.new(key)
  end
end
