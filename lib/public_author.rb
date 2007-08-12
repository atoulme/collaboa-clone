module PublicAuthor
  def author_text
    if self.author == User.public_user
      self.public_author_text
    else
      self.author.name
    end
  end
end