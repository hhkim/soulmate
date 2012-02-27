module Soulmate
  module Helpers

    def prefixes_for_phrase(phrase)
      normalized_phrase = normalize(phrase)
      words = normalized_phrase.split(' ').reject do |w|
        Soulmate.stop_words.include?(w)
      end
      
			words_for_kor = []
			suffix_word = normalized_phrase
			while true
      	words_for_kor += normalize_for_kor(suffix_word).split(' ').reject do |w|
       	 Soulmate.stop_words.include?(w)
				end

				suffix_words = suffix_word.split(' ', 2)
				break if suffix_words.length != 2

				suffix_word = suffix_words[1]
			end
		
      (words_for_kor + words).map do |w|
        (MIN_COMPLETE-1..(w.length-1)).map{ |l| w[0..l] }
      end.flatten.uniq
    end

    def normalize(str)
      str.downcase.gsub(/[^\uAC00-\uD7AFa-z0-9 ]/i, ' ').strip
    end
    
    def normalize_for_kor(str)
      # str.gsub(/[^a-z][ ]+[^a-z]/).each {|x| x[0] + x[-1]}
      str.gsub(/.[ ]+./).each do |x|
        unless x[0] =~ /[a-z]/ && x[-1] =~ /[a-z]/
          (x[0] + x[-1])           
        else
          x
        end
      end
    end
  end
end
