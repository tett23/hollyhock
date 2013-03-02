# coding: utf-8

class Feed
  def self.contents
    merge_contents(StaticPage.all, Page.all(:is_public=>true))
  end

  private
  def self.merge_contents(arr1, arr2)
    arr1 = arr1.delete_if do |item|
      item.created_at.nil?
    end
    arr2 = arr2.delete_if do |item|
      item.created_at.nil?
    end

    (arr1.to_a + arr2.to_a).sort do |x, y|
      y.created_at <=> x.created_at
    end
  end
end
