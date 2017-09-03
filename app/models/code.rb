class Code
  SAFE_CHARACTERS = 'abcdefghijkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789'.freeze

  def self.generate(length)
    (0...length).reduce '' do |memo|
      memo << SAFE_CHARACTERS[Random.rand(SAFE_CHARACTERS.size)]
    end
  end
end
