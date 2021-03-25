module SinatraStatic
  TIME = Time.now.to_i
  private_constant :TIME

  set :static, false

  before(/.+?\.(css|js|ico)/) {
    cache_control(:public, :immutable, { max_age: 31536000 })
  }

  def time
    self.class.development? ? Time.now.to_i : TIME
  end

  def static(asset, rel)
    file, ext = *asset.split('.')
    %(<link rel="#{rel}" href="/#{file}_#{time}.#{ext}" />)
  end

  def css(file)
    static("#{file}.css", 'stylesheet')
  end
end
