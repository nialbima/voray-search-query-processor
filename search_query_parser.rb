require 'set'

# Rules:
# A user can pass in any number of strings, and/or tags
# There can be 0..n 'tags'
# There can be 0..n 'strings'
# There can be 0..n spaces in a tag

class SearchQueryParser
  TAG_REGEX = /^tag:'/
  SPLITTER_REGEX = /(tag:'[\w\s-]+'|\b) /
  EMPTY_STRING_REGEX = /\w/

  def initialize(string)
    # I don't think we can get around this split for now.
    # Later, I might try to single-line it.
    # Splitting it now lets us process in a single subsequent pass.
    @string = string
    @output = {tags: Set.new([])}

    # The last line of a function is the implicit return in Ruby, but a tiny bit
    # of research indicated that explicit returns help with efficiency.
    return extract_text_and_tags
  end

  def extract_text_and_tags
    # we don't need to store a copy of the string in mem.
    return true unless @string.split(SPLITTER_REGEX).map { |str|
      next if str.scan(EMPTY_STRING_REGEX).empty?
      extract_from_str(str)
    }.empty?
  end

  def extract_from_str(str)
    str = str.split(" ").join(" ")
    if str.match(TAG_REGEX)
      # Set lookup is way, way faster than arr lookup, and it already enforces
      # uniqueness without needing to check every element.
      return @output[:tags] = @output[:tags].add(str.split("'")[1])
    else
      if !@output[:text]
        return @output[:text] = str
      else
        # using a memo saves on memory reassignment time.
        # This would depend on output
        return @output[:text] = "#{@output[:text]} #{str}"
      end
    end
  end

  def text
    # It's just a string here.
    return @output[:text]
  end

  def tags
    # Because I'm only returning unique tags, this'll be quick.
    return @output[:tags].to_a
  end

end
