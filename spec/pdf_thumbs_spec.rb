require 'spec_helper'

describe PdfThumbs do
  it 'is configurable' do
    expect {
      PdfThumbs.configure(
        pdf_dir: '/some/path/of/pdfs'
      )
    }.to raise_error 'Missing required config option: :img_dir'

    expect {
      PdfThumbs.configure(
        pdf_dir: '/some/path/of/pdfs',
        img_dir: '/some/path/of/pdfs'
      )
    }.to raise_error 'Missing required config option: :thumb_sizes'

    expect {
      PdfThumbs.configure(
        img_dir: '/some/path/of/images',
        pdf_dir: '/some/path/of/pdfs',
        thumb_sizes: [1000, 500]
      )
    }.not_to raise_error
  end

  it 'can generate pdf page thumbnails for a single pdf file' do
    img_dir = File.expand_path('../thumbnails', __FILE__)
    thumb_sizes = [1000, 500]
    PdfThumbs.configure img_dir: img_dir, thumb_sizes: thumb_sizes

    num_pages = PdfThumbs.thumbnail_single! File.expand_path('../pdfs', __FILE__), 'First.pdf'
    (1..3).each do |page_num| # First.pdf has 3 pages
      thumb_sizes.each do |thumb_size|
        expect(File).to exist(File.join(img_dir, 'First.pdf', "#{thumb_size}_#{page_num}.png"))
      end
    end

    expect(num_pages).to eql(3)

    FileUtils.rm_rf img_dir
  end

  it 'can generate pdf page thumbnails' do
    img_dir = File.expand_path('../thumbnails', __FILE__)
    thumb_sizes = [1000, 500]
    PdfThumbs.configure(
      pdf_dir: File.expand_path('../pdfs', __FILE__),
      img_dir: img_dir,
      thumb_sizes: thumb_sizes
    )
    expected_dirs = [
      File.join(File.expand_path('../thumbnails/First.pdf', __FILE__), ''),
      File.join(File.expand_path('../thumbnails/Second.pdf', __FILE__), '')
    ]
    idx = 0
    PdfThumbs.thumbnail! do |thumb_dir|
      expect(thumb_dir).to eq(expected_dirs[idx])
      expect(File).to be_directory(thumb_dir)
      (1..3).each do |page_num| # each file has 3 pages
        thumb_sizes.each do |thumb_size|
          expect(File).to exist(File.join(thumb_dir, "#{thumb_size}_#{page_num}.png"))
        end
      end
      idx += 1
    end

    FileUtils.rm_rf img_dir
  end
end
