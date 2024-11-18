class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  attr_reader :word
  attr_reader :guesses
  attr_reader :wrong_guesses

  def find_positions(str, char)
    positions = []
    index = str.downcase().index(char.downcase())
    until index.nil?
      positions << index
      index = str.downcase().index(char.downcase(), index + 1)
    end
    positions
  end

  def guess(letter)
    # todo
    # 判断letter是否是valid
    if not letter or !letter.match?(/^[a-zA-Z]$/)
      throw ArgumentError
    end
    #
    # 判断是否wrong_guesses
    # if self.wrong_guesses.split("").to_set().length == 7
      
    # end
    # 判断是否重复猜中
    if find_positions(self.guesses, letter) != []
      return false
    end

    is_match = find_positions(self.word, letter)
    if is_match != []
      self.guesses << letter
    elsif find_positions(self.wrong_guesses, letter) == []
      self.wrong_guesses << letter
    else
      return false
    end
    true
  end

  def word_with_guesses()
    length = self.word.length
    word_with_guesses = '-' * length
    self.guesses.each_char do |letter|
      indexes = find_positions(self.word, letter)
      indexes.each do |index|
        word_with_guesses[index] = letter
      end
    end
    word_with_guesses
  end

  def check_win_or_lose()
    if self.wrong_guesses.split("").to_set().length == 7
      result = :lose
    elsif self.word.split("").to_set == self.guesses.split("").to_set
      result = :win
    else
      result = :play
    end
    result
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end
end
