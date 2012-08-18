class Image < ActiveRecord::Base
  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_presence_of :author, :on => :create, :message => "can't be blank"
  validates_presence_of :photo, :on => :create, :message => "can't be blank"

  validates_format_of     :name,
                         :with => /[a-zA-Z0-9_-]/,  
                         :message => " must not include spaces and must be alphanumeric, as it'll be used in the URL of your image, like: http://site.org/image/your-image-name. You may use dashes and underscores.",
                         :on => :create
 
 # Paperclip
  has_attached_file :photo,
     :styles => {
     :thumb=> "100x100#",
     :large =>   "400x400>" }

  def image_from_dataurl(data)
    # remove image/png:base,
    data = data.split(',').pop

    # decode base64:
    data = Base64.decode64(data)

    self.photo = Paperclip::string_to_file('capture.png', 'image/png', data)
    self.save
  end

end
