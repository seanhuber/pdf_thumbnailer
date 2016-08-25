class PdfThumbs
  def self.configure **opts
    # [:pdf_dir, :img_dir, :thumb_sizes].each do |required_opt|
    [:img_dir, :thumb_sizes].each do |required_opt|
      raise ArgumentError, "Missing required config option: :#{required_opt}" unless opts[required_opt]
    end
    @@img_dir = File.join(opts[:img_dir], '') # adds trailing '/' if it doesn't already have one
    @@pdf_dir = File.join(opts[:pdf_dir], '') if opts[:pdf_dir]# adds trailing '/' if it doesn't already have one
    @@thumb_sizes = opts[:thumb_sizes].is_a?(Fixnum) ? [opts[:thumb_sizes]] : opts[:thumb_sizes]
  end

  def self.thumbnail!
    Dir.glob(File.join(@@pdf_dir, '**', '*.pdf')) do |pdf|
      img_dir = thumbnail_pdf @@pdf_dir, pdf.gsub(@@pdf_dir, '')
      yield(img_dir) if block_given?
    end
  end

  # TODO: add spec and document in README.md
  def self.thumbnail_single! pdf_dir, relative_pdf_path
    thumbnail_pdf pdf_dir, relative_pdf_path
  end

  private

  def self.clear_img_dir relative_pdf_path
    relative_path = File.dirname relative_pdf_path
    relative_img_path = relative_path == '.' ? File.basename(relative_pdf_path) : File.join(relative_path, File.basename(relative_pdf_path))
    img_dir = File.join(@@img_dir, relative_img_path, '')

    FileUtils.rm_rf(img_dir) if File.directory?(img_dir)
    FileUtils.mkdir_p img_dir

    img_dir
  end

  def self.thumbnail_pdf pdf_dir, relative_pdf_path
    img_dir = clear_img_dir relative_pdf_path

    @@thumb_sizes.each do |thumb_size|
      `pdftoppm -png -scale-to #{thumb_size} "#{File.join(pdf_dir, relative_pdf_path)}" "#{img_dir}"`

      Dir.glob(File.join(img_dir, '-*.png')) do |img_path|
        page_num = File.basename(img_path, '.png').split('-')[-1].to_i
        File.rename(img_path, File.join(img_dir, "#{thumb_size}_#{page_num}.png"))
      end
    end

    img_dir
  end
end
