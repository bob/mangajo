require 'spec_helper'

describe "Post show page" do
  it "should be ok for diet" do
    diet = create(:diet, :user => create(:user))
    post = create(:post, :published_at => Time.now, :postable => diet, :user => diet.user)

    visit "/posts/#{post.id}"

    page.should have_selector("div#diet_content")
  end
end
