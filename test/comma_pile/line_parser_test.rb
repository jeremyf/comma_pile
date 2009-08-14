require '../test_helper'

class CommaPile::LineParserTest < Test::Unit::TestCase

  context 'define column' do
    should 'allow column method to be defined via an integer' do
      klass = Class.new(CommaPile::LineParser) {
        define_attribute :name, 1
      }

      assert_equal 'b', klass.new(['a','b','c']).name
    end

    should 'allow column to be set by a block' do
      klass = Class.new(CommaPile::LineParser) {
        define_attribute(:name) { self[1] + (self[2] * 2) }
      }
      assert_equal 'bcc', klass.new(['a','b','c']).name
    end

    should 'raise exception if both index and block are passed' do
      assert_raises ArgumentError do
        Class.new(CommaPile::LineParser) {
          define_attribute(:name, 1) { self[1] + (self[2] * 2) }
        }
      end
    end
  end
end
