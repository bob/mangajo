class Blog

  def initialize(entry_fetcher = Post.public_method(:all))
    @entry_fetcher = entry_fetcher
  end

  def new_post(resource, *args)
    p = post_source.call(*args)
    p.blog = self
    p.title = resource.name
    p.postable = resource
    p.user = resource.user
    p
  end

  private
  def fetch_entries
    @entry_fetcher.()
  end

  def post_source
    @post_source ||= Post.public_method(:new)
  end
end
