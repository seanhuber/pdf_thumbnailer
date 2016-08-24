require 'spec_helper'

describe PdfThumbs do
  it 'is configurable' do
    expect {
      PdfThumbs.configure
    }.to raise_error 'Missing required config option: :pdf_dir'

    expect {
      PdfThumbs.configure(
        pdf_dir: '/some/path/of/pdfs'
      )
    }.to raise_error 'Missing required config option: :img_dir'

    expect {
      PdfThumbs.configure(
        img_dir: '/some/path/of/images',
        pdf_dir: '/some/path/of/pdfs'
      )
    }.not_to raise_error
  end
end
