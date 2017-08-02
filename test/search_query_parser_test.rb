require_relative 'test_helper'
require "test/unit"

require_relative "../search_query_parser"

class SearchQueryParserTest < Test::Unit::TestCase

  def setup
    @test_string = "tag:'monkey' tag:'banana fun-time' monkey banana fun-time"
    @tag_output = ['monkey','banana fun-time']
    @text_output = "monkey banana fun-time"

    @parser_class = SearchQueryParser
  end

  def test_parser_does_nothing_if_passed_empty_string
    @test_string = " "
    @parser = @parser_class.new(@test_string)

    assert_equal [], @parser.tags
    assert_equal nil, @parser.text
  end

  def test_parser_only_stores_unique_tags
    @test_string << "tag:'monkey'"
    @parser = @parser_class.new(@test_string)

    assert_equal @tag_output, @parser.tags
  end

  def test_parser_only_stores_tags_once
    @test_string << "tag:'monkey'"
    @parser = @parser_class.new(@test_string)

    assert_equal @tag_output, @parser.tags
  end

  def test_parser_stores_n_copies_of_text
    @parser = @parser_class.new(@test_string * 20)

    assert_equal 20, @parser.text.scan(/monkey/).count
  end

  def test_parser_cleans_spaces_and_indicator_from_dirty_tags
    @parser = @parser_class.new(@test_string)

    tag_regx = @parser_class::TAG_REGEX
    extra_text_regx = /(\s+'.*'|'.*'\s+)/

    assert @parser.tags.select{|t| t =~ tag_regx}.empty?
    assert @parser.tags.select{|t| t =~ extra_text_regx}.empty?
  end

  def test_parser_cleans_spaces_from_dirty_text
    @test_string += " " * 20 + "another-monkey"
    @parser = @parser_class.new(@test_string)

    expected = "#{@text_output} another-monkey"
    assert_equal expected, @parser.text
  end



end
