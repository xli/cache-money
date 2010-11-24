require File.join(File.dirname(__FILE__), 'spec_helper')

module Cash
  describe 'cache_specific_model' do
    it 'should not cache Card model' do
      card = Card.create!(:name => 'a story')
      Card.find(card.id)
      $memcache.get("Card:1/id/#{card.id}").should == nil
    end

    it 'should cache Story model' do
      Story.is_cached :repository => Cash::Transactional.new($memcache, $lock)
      Story.class_eval do
        index :title
        index [:id, :title]
        index :published
      end

      story = Story.create!(:title => 'a real story')
      $memcache.get("Story:1/id/#{story.id}").should_not == nil

      Story.find_by_title('a real story')
      $memcache.get("Story:1/title/a+real+story").should_not == nil

      Story.count(:conditions => "title = 'a real story'")
      $memcache.get("Story:1/title/a+real+story/count", true).should == '1'
      Story.count(:conditions => "title = 'a real story'").should == 1
    end
  end
end
