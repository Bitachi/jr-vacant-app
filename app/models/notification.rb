class Notification < ApplicationRecord
  require 'openssl'
  require 'base64'
  password = ENV['MYAES_KEY']
  validates :token,  presence: true
  before_save { encrypt_token }

  def aes_encrypt(plain_text, password, bit)

    # saltを生成
    salt = OpenSSL::Random.random_bytes(8)

    # 暗号器を生成
    enc = OpenSSL::Cipher::AES.new(bit, :CBC)
    if plain_text == nil
      return ["FILL_IN_YOUR_TOKEN", salt]
    else
      enc.encrypt

      # パスワードとsaltをもとに鍵とivを生成し、設定
      key_iv = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, 2000, enc.key_len + enc.iv_len, "sha256")
      enc.key = key_iv[0, enc.key_len]
      enc.iv = key_iv[enc.key_len, enc.iv_len]

      # 文字列を暗号化
      encrypted_text = enc.update(plain_text) + enc.final

      # Base64でエンコード
      encrypted_text = Base64.encode64(encrypted_text).chomp
      salt = Base64.encode64(salt).chomp

      # 暗号とsaltを返す
      [encrypted_text, salt]
    end
  end

  def aes_decrypt(encrypted_text, password, salt, bit)

    if encrypted_text == nil || salt == nil
      return "FILL_IN_YOUR_TOKEN"
    else
          # Base64でデコード
      encrypted_text = Base64.decode64(encrypted_text)
      salt = Base64.decode64(salt)

      # 復号器を生成
      dec = OpenSSL::Cipher::AES.new(bit, :CBC)
      dec.decrypt

      # パスワードとsaltをもとに鍵とivを生成し、設定
      key_iv = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, 2000, dec.key_len + dec.iv_len, "sha256")
      dec.key = key_iv[0, dec.key_len]
      dec.iv = key_iv[dec.key_len, dec.iv_len]

      # 暗号を復号
      dec.update(encrypted_text) + dec.final
    end
  end

  def encrypt_token
     self.token, self.salt = aes_encrypt(self.token, ENV['MYAES_KEY'], 128)
  end

  def get_token
    return aes_decrypt(self.token, ENV['MYAES_KEY'], self.salt, 128)
  end

  

end
