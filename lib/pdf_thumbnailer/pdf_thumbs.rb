class PdfThumbs
  def self.configure **opts
    [:pdf_dir, :img_dir].each do |required_opt|
      raise ArgumentError, "Missing required config option: :#{required_opt}" unless opts[required_opt]
    end
    @@pdf_dir = File.join(opts[:pdf_dir], '') # adds trailing '/' if it doesn't already have one
    @@img_dir = File.join(opts[:img_dir], '') # adds trailing '/' if it doesn't already have one
  end
end
