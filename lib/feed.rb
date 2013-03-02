# coding: utf-8

class Feed
  def self.contents
    merge_contents(StaticPage.all, Page.all(:is_public=>true))
  end

  private
  def self.merge_contents(arr1, arr2)
    (arr1.to_a + arr2.to_a).sort do |x, y|
      next -1 if x.created_at.nil? || y.created_at.nil?

      y.created_at <=> x.created_at
    end
  end
end
