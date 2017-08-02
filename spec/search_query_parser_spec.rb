require_relative '../search_query_parser'

describe SearchQueryParser do
  describe '#text' do
    it "finds the text" do
      parser = described_class.new("tag:'monkey' tag:'monkey business' monkey")
      expect(parser.text).to eql('monkey')
    end
  end

  describe '#tags' do
    it "finds the tags" do
      parser = described_class.new("tag:'monkey' tag:'monkey business' monkey")
      expect(parser.tags).to eql(['monkey', 'monkey business'])
    end
  end
end
