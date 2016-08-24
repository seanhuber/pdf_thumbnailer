class PdfThumbs
  def self.configure **opts
    [:pdf_dir, :img_dir, :thumb_sizes].each do |required_opt|
      raise ArgumentError, "Missing required config option: :#{required_opt}" unless opts[required_opt]
    end
    @@pdf_dir = File.join(opts[:pdf_dir], '') # adds trailing '/' if it doesn't already have one
    @@img_dir = File.join(opts[:img_dir], '') # adds trailing '/' if it doesn't already have one
    @@thumb_sizes = opts[:thumb_sizes].is_a?(Fixnum) ? [opts[:thumb_sizes]] : opts[:thumb_sizes]
  end

  def self.thumbnail!
    Dir.glob(File.join(@@pdf_dir, '**', '*.pdf')) do |pdf|
      img_dir = clear_img_dir pdf

      @@thumb_sizes.each do |thumb_size|
        `pdftoppm -png -scale-to #{thumb_size} "#{pdf}" "#{img_dir}"`

        Dir.glob(File.join(img_dir, '-*.png')) do |img_path|
          page_num = File.basename(img_path, '.png').split('-')[-1].to_i
          File.rename(img_path, File.join(img_dir, "#{thumb_size}_#{page_num}.png"))
        end
      end
      yield(img_dir) if block_given?
    end
  end

  private

  def self.clear_img_dir pdf
    relative_path = File.dirname pdf.gsub(@@pdf_dir, '')
    relative_img_path = relative_path == '.' ? File.basename(pdf) : File.join(relative_path, File.basename(pdf))
    img_dir = File.join(@@img_dir, relative_img_path, '')

    FileUtils.rm_rf(img_dir) if File.directory?(img_dir)
    FileUtils.mkdir_p img_dir

    img_dir
  end
end
