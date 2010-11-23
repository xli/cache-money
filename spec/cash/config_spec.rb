require File.join(File.dirname(__FILE__), '..', 'spec_helper')

module Cash
  describe Config do
    describe '#disable_cache' do
      it 'should be able to disable specific model cache' do
        Card.disable_cache
        card = Card.create!(:name => 'a story')
        Card.find(card.id)
        $memcache.get("Card:1/id/#{card.id}").should == nil

        Story.version 1
        story = Story.create!(:title => 'a real story')
        $memcache.get("Story:1/id/#{story.id}").should_not == nil
      end

      it 'should not be able to index anything' do
        Card.disable_cache
        Card.indices.should == []
        lambda { Card.index(:name) }.should raise_error
      end
    end
  end
end