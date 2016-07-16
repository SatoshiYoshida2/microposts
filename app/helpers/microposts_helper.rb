module MicropostsHelper
  def image_for(micropost)
    link_to image_tag(micropost.image.url, size:"500x500", alt: micropost.content, class: "img"),micropost.image.url if micropost.image?
  end
end